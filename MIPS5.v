`include "PC.v"
`include "InstructionMemory.v"
`include "PCAdder.v"
`include "MUX_2x1_5.v"
`include "MUX_2x1_32.v"
`include "HazardDetectionUnit.v"
`include "ControlMux.v"
`include "AND.v"
`include "Comparator.v"
`include "signExtend.v"
`include "ShiftLeft2.v"
module MIPS5 (
    input wire clk, reset
);

// Signal Declarations

// IF stage
wire [31:0] PC, Instruction , PC_Plus4;
wire [31:0] NextPC;
PC (
    .clk(clk),
    .stall() , // it comes from hazard detection unit
    .reset(reset),
    .PC_IN(NextPC),
    .PC_OUT(Pc)
);
InstructionMemory (
    .clk(clk),
    .PC(PC),
    .instruction(Instruction)
);
PCAdder (
    .PC_in(pc),
    .PC_out(PC_Plus4)
);
MUX_2x1_32(
    .input0(PC_Plus4),
    .input1(Branch_Address),
    .sel(taken), 
    .result(NextPC)
);
// IF/ID Register
wire [31:0] IF_ID_PC_Plus4 ,IF_ID_Instruction ;
IF_ID_Register (
    .clk(clk),
    .reset(reset),
    .flush(), // it comes from "and"(ID)
    .stall(), // it comes from hazard detection unit 
    .PC_Plus4(PC_Plus4),
    .Instruction(Instruction),
    .PC_Plus4_out(IF_ID_PC_Plus4),
    .Instruction_out(IF_ID_Instruction)
);

// ID stage
wire [31:0] RegData1, RegData2;
wire [4:0] writeadr;
wire RegWrite, MemRead, MemWrite, ALUSrc, RegDst, MemtoReg, Branch, Jump;
MUX_2x1_5 register_destination(
    .input0(IF_ID_Instruction[20:16]),
    .input1(IF_ID_Instruction[15:11]),
    .sel(), // it comes from RegDst(MEM/WB)
    .result(writeadr)
);

RegisterFile(
    .clk(clk),
    .reset(reset),
    .adr1(IF_ID_Instruction[25:21]),
    .adr2(IF_ID_Instruction[20:16]),
    .writeadr(writeadr),
    .RegWrite(RegWrite),
    .WriteData(), // it comes from MEM stage 
    .ReadData1(RegData1),
    .ReadData2(RegData2)
);
wire [7:0] control_signals ; 
wire Branch ; 
Controller(
    .opcode(Instruction[31:27]),
    .RegDst(control_signals[7]),
    .ALUSrc(control_signals[6]),
    .MemToReg(control_signals[5]),
    .RegWrite(control_signals[4]),
    .MemRead(control_signals[3]),
    .MemWrite(control_signals[2]),
    .Branch(Branch)
    .ALUOp(control_signals[1:0])
);
wire equal ; 
Comparator rs_rt_comparator(
    .A(RegData1),
    .B(RegData2),
    .equal(equal)
);
wire taken ; 
AND Branch_result(
    .a(Branch),
    .b(equal),
    .result(taken)
);

wire [31:0] signExtended
signExtend (
    .in(Instruction[15:0])
    .out(signExtended)
);
wire [31:0] signExtended_shiftleft2
ShiftLeft2(
    .in(signExtended),
    .out(signExtended_shiftleft2)
);
wire [31:0] Branch_Address
Adder branch_address_calculator(
    .input1(IF_ID_PC_Plus4),
    .input2(signExtended_shiftleft2),
    .result(Branch_Address)
);
// Hazard Detection Unit
wire IF_ID_stall , PC_stall , ControlMux ;

HazardDetectionUnit hazard_detection (
    .ID_EX_MemRead(MemRead_From_ID_EX_To_EX_MEM),
    .ID_EX_Rt(),
    .IF_ID_Rs(Instruction[25:21]),
    .IF_ID_Rt(Instruction[20:16]),
    .PC_stall(PC_stall)
    .IF_ID_stall(IF_ID_stall)
    .ControlMux(ControlMux)
);
wire [8:0] ControlMuxToRegister ; 
ControlMux(
    .stall(ControlMux),
    .control_in(control_signals),
    .control_out(ControlMuxToRegister),
);
wire RegDst_From_ID_EX_To_EX_MEM, MemRead_From_ID_EX_To_EX_MEM
wire [31:0] ID_EX_Rt
// ID/EX Register
ID_EX_Register (
    .clk(clk),
    .reset(reset),
    .RegDst(control_signals[7]),
    .ALUSrc(control_signals[6]),
    .MemToReg(control_signals[5]),
    .RegWrite(control_signals[4]),
    .MemRead(control_signals[3]),
    .MemWrite(control_signals[2]),
    .ALUOp(control_signals[1:0]),
    .RD1(RegData1),
    .RD2(RegData2),
    .SignExtend(signExtended),
    .Rs(Instruction[25:21]),
    .Rt(Instruction[20:16]),
    .Rd(Instruction[15:11]),
    .funct(Instruction[5:0]),
    .RegDst_out(RegDst_From_ID_EX_To_EX_MEM),
    .ALUSrc_out(),
    .MemRead_out(MemRead_From_ID_EX_To_EX_MEM),
    .MemWrite_out(),
    .MemToReg_out(),
    .RegWrite_out(),
    .ALUOp_out(),
    .RD1_out(),
    .RD2_out(),
    .SignExtend_out(),
    .Rs_out(),
    .Rt_out(ID_EX_Rt),
    .Rd_out(),
    .funct_out()
);


// ALU Control
wire [3:0] ALUControl;
ALUController alu_control (
    .ALUOp(ALUOp),
    .FunctionCode(IF_ID_Instruction[5:0]),
    .ALUControl(ALUControl)
);

// Forwarding Unit
wire [1:0] ForwardA, ForwardB;
ForwardingUnit forwarding_unit (
    .ID_EX_Rs(IF_ID_Instruction[25:21]),
    .ID_EX_Rt(IF_ID_Instruction[20:16]),
    .EX_MEM_Rd(EX_MEM_Rd),
    .MEM_WB_Rd(MEM_WB_Rd),
    .ID_EX_RegWrite(RegWrite),
    .EX_MEM_RegWrite(EX_MEM_RegWrite),
    .MEM_WB_RegWrite(MEM_WB_RegWrite),
    .ForwardA(ForwardA),
    .ForwardB(ForwardB)
);

// EX stage
wire [31:0] ALUInputA, ALUInputB, ALUResult;
ALU_InputA_Mux alu_input_a_mux (
    .Rs(RegData1),
    .EX_MEM_ALUResult(EX_MEM_ALUResult),
    .MEM_WB_ALUResult(MEM_WB_ALUResult),
    .ForwardA(ForwardA),
    .ALUInputA(ALUInputA)
);

ALU_InputB_Mux alu_input_b_mux (
    .Rt(RegData2),
    .EX_MEM_ALUResult(EX_MEM_ALUResult),
    .MEM_WB_ALUResult(MEM_WB_ALUResult),
    .ForwardB(ForwardB),
    .ALUInputB(ALUInputB)
);

ALU alu (
    .A(ALUInputA),
    .B(ALUInputB),
    .ALUControl(ALUControl),
    .Result(ALUResult),
    .Zero(Zero),
    .Overflow(Overflow)
);

// EX/MEM Register
wire [31:0] EX_MEM_ALUResult, EX_MEM_ReadData2;
EX_MEM_Register EX_MEM_reg (
    .clk(clk),
    .reset(reset),
    .ALUResult(ALUResult),
    .ReadData2(RegData2),
    .RegWrite(RegWrite),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .MemtoReg(MemtoReg),
    .EX_MEM_ALUResult(EX_MEM_ALUResult),
    .EX_MEM_ReadData2(EX_MEM_ReadData2)
);

// MEM stage
wire [31:0] DataMemoryOutput;
DataMemory data_memory (
    .clk(clk),
    .address(EX_MEM_ALUResult),
    .write_data(EX_MEM_ReadData2),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .read_data(DataMemoryOutput)
);

// MEM/WB Register
wire [31:0] MEM_WB_ALUResult, MEM_WB_DataMemoryOutput;
MEM_WB_Register MEM_WB_reg (
    .clk(clk),
    .reset(reset),
    .ALUResult(EX_MEM_ALUResult),
    .DataMemoryOutput(DataMemoryOutput),
    .RegWrite(RegWrite),
    .MemtoReg(MemtoReg),
    .MEM_WB_ALUResult(MEM_WB_ALUResult),
    .MEM_WB_DataMemoryOutput(MEM_WB_DataMemoryOutput)
);

// WB stage
wire [31:0] WriteData;
Mux2to1 mux2to1 (
    .A(MEM_WB_ALUResult),
    .B(MEM_WB_DataMemoryOutput),
    .Sel(MemtoReg),
    .Out(WriteData)
);

// Final Write Back
RegisterFile_WriteBack register_write_back (
    .clk(clk),
    .reset(reset),
    .RegWrite(RegWrite),
    .WriteData(WriteData),
    .WriteReg(MEM_WB_Rd)
);

endmodule
