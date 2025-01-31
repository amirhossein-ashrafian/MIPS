`include "PC.v"
`include "InstructionMemory.v"
`include "PCAdder.v"
`include "MUX_2x1_32.v"
`include "IF_ID_Reg.v"
`include "RegisterFile.v"
`include "Controller.v"
`include "Comparator.v"
`include "AND.v"
`include "signExtend.v"
`include "ShiftLeft2.v"
`include "Adder.v"
`include "HazardDetectionUnit.v"
`include "ControlMux.v"
`include "ID_EX_Reg.v"
`include "MUX_2x1_5.v"
`include "MUX_3x1_32.v"
`include "ALUController.v"
`include "ForwardingUnit.v"
`include "ALU.v"
`include "EX_MEM_Reg.v"
`include "DataMemory.v"
`include "MEM_WB_Reg.v"
module MIPS5 (
    input wire clk, reset
);
// IF stage
wire [31:0] PC, Instruction , PC_Plus4;
wire [31:0] NextPC;
PC (
    .clk(clk),
    .stall(PC_stall),
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
    .flush(taken), 
    .stall(IF_ID_stall), 
    .PC_Plus4(PC_Plus4),
    .Instruction(Instruction),
    .PC_Plus4_out(IF_ID_PC_Plus4),
    .Instruction_out(IF_ID_Instruction)
);

// ID stage
wire [31:0] RegData1, RegData2;
wire RegWrite, MemRead, MemWrite, ALUSrc, RegDst, MemtoReg, Branch, Jump;


RegisterFile(
    .clk(clk),
    .reset(reset),
    .adr1(IF_ID_Instruction[25:21]),
    .adr2(IF_ID_Instruction[20:16]),
    .writeadr(MEM_WB_Rd), 
    .RegWrite(MEM_WB_RegWrite),
    .WriteData(WriteData), 
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
    .ID_EX_MemRead(ID_EX_MemRead),
    .ID_EX_Rt(ID_EX_Rt),
    .IF_ID_Rs(Instruction[25:21]),
    .IF_ID_Rt(Instruction[20:16]),
    .PC_stall(PC_stall)
    .IF_ID_stall(IF_ID_stall)
    .ControlMux(ControlMux)
);
wire [7:0] ControlMuxToRegister ; 
ControlMux(
    .stall(ControlMux),
    .control_in(control_signals),
    .control_out(ControlMuxToRegister),
);
wire ID_EX_RegDst, ID_EX_MemRead ,ID_EX_ALUSrc,ID_EX_MemWrite , ID_EX_MemToReg , ID_EX_RegWrite;
wire [4:0] ID_EX_Rt,ID_EX_Rs,ID_EX_Rd;
wire [5:0] ID_EX_func;
wire [31:0] ID_EX_RD1 , ID_EX_RD2 ,ID_EX_SignExtended ;
wire [1:0] ID_EX_ALUOp ; 
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
    .RegDst_out(ID_EX_RegDst),
    .ALUSrc_out(ID_EX_ALUSrc),
    .MemRead_out(ID_EX_MemRead),
    .MemWrite_out(ID_EX_MemWrite),
    .MemToReg_out(ID_EX_MemToReg),
    .RegWrite_out(ID_EX_RegWrite),
    .ALUOp_out(ID_EX_ALUOp),
    .RD1_out(ID_EX_RD1),
    .RD2_out(ID_EX_RD2),
    .SignExtend_out(ID_EX_SignExtended),
    .Rs_out(ID_EX_Rs),
    .Rt_out(ID_EX_Rt),
    .Rd_out(ID_EX_Rd),
    .funct_out(ID_EX_func)
);

// EX stage 
wire [4:0] writeadr;
MUX_2x1_5 register_destination(
    .input0(ID_EX_Rt),
    .input1(ID_EX_Rd),
    .sel(ID_EX_RegDst), 
    .result(writeadr)
);
wire [31:0] rt_or_signExtended ; 
MUX_2x1_32 alu_src(
    .input0(ID_EX_Rt),
    .input1(ID_EX_SignExtended),
    .sel(ID_EX_ALUSrc),
    .result(rt_or_signExtended)
);
wire [31:0] inputA , inputB ;
MUX_3x1_32 A(
    .maininput(ID_EX_Rs),
    .fw1(EX_MEM_ALUResult),
    .fw2(MEM_WB_ALUResult),
    .sel(ForwardA),
    .result(inputA)
);
MUX_3x1_32 B(
    .maininput(rt_or_signExtended),
    .fw1(EX_MEM_ALUResult),
    .fw2(MEM_WB_ALUResult),
    .sel(ForwardB),
    .result(inputB)
);
// ALU Control
wire [3:0] ALUControl;
ALUController alu_control (
    .ALUOp(ID_EX_ALUOp),
    .FunctionCode(ID_EX_func),
    .ALUControl(ALUControl)
);

// Forwarding Unit
wire [1:0] ForwardA, ForwardB;
ForwardingUnit forwarding_unit (
    .ID_EX_Rs(ID_EX_Rs),
    .ID_EX_Rt(ID_EX_Rs),
    .EX_MEM_Rd(EX_MEM_Rd),
    .MEM_WB_Rd(MEM_WB_Rd),
    .ID_EX_RegWrite(ID_EX_RegWrite),
    .EX_MEM_RegWrite(EX_MEM_RegWrite),
    .MEM_WB_RegWrite(MEM_WB_RegWrite),
    .ForwardA(ForwardA),
    .ForwardB(ForwardB)
);
wire [31:0] ALUResult ; 
wire zero , overflow ; 
ALU alu (
    .A(inputA),
    .B(inputB),
    .ALUControl(ALUControl),
    .Result(ALUResult),
    .Zero(zero),
    .Overflow(overflow)
);

// EX/MEM Register
wire [31:0] EX_MEM_ALUResult ,EX_MEM_RD2 ;
wire [4:0] EX_MEM_Rd ; 
wire EX_MEM_MemRead , EX_MEM_MemWrite , EX_MEM_MemtoReg , EX_MEM_RegWrite ; 
EX_MEM_Register EX_MEM_reg (
    .clk(clk),
    .reset(reset),
    .MemRead(ID_EX_MemRead),
    .MemWrite(ID_EX_MemWrite),
    .MemtoReg(ID_EX_MemtoReg),
    .RegWrite(ID_EX_RegWrite),
    .ALUResult(ALUResult),
    .RD2(ID_EX_RD2),
    .Rd(writeadr),

    .MemRead_out(EX_MEM_MemRead),
    .MemWrite_out(EX_MEM_MemWrite),
    .MemtoReg_out(EX_MEM_MemtoReg),
    .RegWrite_out(EX_MEM_RegWrite),
    .ALUResult_out(EX_MEM_ALUResult),
    .RD2_out(EX_MEM_RD2),
    .Rd_out(EX_MEM_Rd),
);

// MEM stage
wire [31:0] DataMemoryOutput;
DataMemory data_memory (
    .clk(clk),
    .address(EX_MEM_ALUResult),
    .write_data(EX_MEM_RD2),
    .MemRead(EX_MEM_MemRead),
    .MemWrite(EX_MEM_MemWrite),
    .read_data(DataMemoryOutput)
);

// MEM/WB Register
wire        MEM_WB_RegWrite;   
wire        MEM_WB_MemtoReg;   
wire [31:0] MEM_WB_ALUResult;   
wire [31:0] MEM_WB_ReadData;    
wire [4:0]  MEM_WB_Rd;

MEM_WB_Register mem_wb_reg (
    .clk(clk),
    .reset(reset),
    .RegWrite(EX_MEM_RegWrite),
    .MemtoReg(EX_MEM_MemtoReg),
    .ALUResult(EX_MEM_ALUResult),
    .ReadData(DataMemoryOutput),
    .Rd(EX_MEM_Rd),
    
    .RegWrite_out(MEM_WB_RegWrite),
    .MemtoReg_out(MEM_WB_MemtoReg),
    .ALUResult_out(MEM_WB_ALUResult),
    .ReadData_out(MEM_WB_ReadData),
    .Rd_out(MEM_WB_Rd)
);
// WB stage
wire [31:0] WriteData;
MUX_2x1_32 mux2to1 (
    .A(MEM_WB_ALUResult),
    .B(MEM_WB_ReadData),
    .Sel(MEM_WB_MemtoReg)
    .Out(WriteData)
);
endmodule
