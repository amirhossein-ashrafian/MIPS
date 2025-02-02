module Adder (
    input wire signed [31:0]input1, 
    input wire signed [31:0]input2,
    output wire [31:0] result
);
assign result = input1 + input2 ;
endmodule
module ALU (
    input wire [31:0] A, B,       // دو ورودی 32 بیتی
    input wire [3:0] ALUControl,  // سیگنال کنترلی ALU
    output reg [31:0] Result,     // خروجی 32 بیتی ALU
    output reg Zero,              // پرچم Zero
    output reg Overflow           // پرچم Overflow برای ADD/SUB
);

    reg signed [31:0] signed_A, signed_B, signed_Result;

    always @(*) begin
        Overflow = 0;
        signed_A = A;
        signed_B = B;
        
        case (ALUControl)
            4'b0000: Result = A & B; // AND
            4'b0001: Result = A | B; // OR
            4'b0010: begin // ADD
                signed_Result = signed_A + signed_B;
                Result = signed_Result;
                Overflow = ((signed_A[31] == signed_B[31]) && (signed_A[31] != signed_Result[31]));
            end
            4'b0110: begin // SUB
                signed_Result = signed_A - signed_B;
                Result = signed_Result;
                Overflow = ((signed_A[31] != signed_B[31]) && (signed_A[31] != signed_Result[31]));
            end
            4'b0111: Result = (signed_A < signed_B) ? 32'b1 : 32'b0; // SLT (signed)
            4'b1100: Result = ~(A | B); // NOR
            default: Result = 32'b0;
        endcase

        // مقدار پرچم Zero اگر خروجی صفر باشد، 1 می‌شود.
        Zero = (Result == 32'b0) ? 1 : 0;
    end

endmodule
module ALUControl (
    input wire [1:0] ALUOp,
    input wire [5:0] Funct,
    output reg [3:0] ALUControl
);

    always @(*) begin
        case (ALUOp)
            2'b00: ALUControl = 4'b0010; // lw/sw (عملیات جمع)
            2'b01: ALUControl = 4'b0110; // beq (عملیات تفریق)
            2'b10: begin
                case (Funct) // دستورات R-type
                    6'b100000: ALUControl = 4'b0010; // ADD
                    6'b100010: ALUControl = 4'b0110; // SUB
                    6'b100100: ALUControl = 4'b0000; // AND
                    6'b100101: ALUControl = 4'b0001; // OR
                    6'b101010: ALUControl = 4'b0111; // SLT
                    default:   ALUControl = 4'b1111; // نامعتبر
                endcase
            end
            2'b11: ALUControl = 4'b0001; // ORI
            default: ALUControl = 4'b1111; // نامعتبر
        endcase
    end
endmodule
module AND(
    input wire a,
    input wire b,
    output wire result
);
assign result = a & b;
endmodule
module BranchPredictor (
    input         clk,      
    input         reset,   
    input  [31:0] PC,        
    input         update,    
    input         actual,    
    output        predict   
);

    reg [1:0] predictor_table [0:1023]; // جدول 1024 سطری ، هر سطر شامل 2 بیت

    wire [9:0] index;
    assign index = PC[9:0]; // انتخاب سطر مورد نظر برای بررسی بر اساس 10 بیت کم ارزش پی سی

    assign predict = (predictor_table[index] >= 2) ? 1'b1 : 1'b0; // خروجی پیشبینی به این صورت که اگر مقدار سطر از 2 بیشتر بود تیکن است

    integer i;
    // به‌روزرسانی جدول پیش‌بینی و مقداردهی اولیه
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // مقداردهی اولیه تمامی سطرها به حالت 01 (ضعیف غیرتیرش)
            for (i = 0; i < 1024; i = i + 1) begin
                predictor_table[i] <= 2'b01;
            end
        end else if (update) begin
            if (actual) begin
                // تا رسیدن به 11 افزایش میدهیم
                if (predictor_table[index] != 2'b11)
                    predictor_table[index] <= predictor_table[index] + 1;
            end else begin
                // تا رسیدن به 00 کاهش میدهیم
                if (predictor_table[index] != 2'b00)
                    predictor_table[index] <= predictor_table[index] - 1;
            end
        end
    end

endmodule
module Comparator (
    input wire [31:0] A, B,
    output wire equal
);

assign equal = (A == B);

endmodule
module Controller (
    input wire [5:0] opcode,     // Opcode از دستورالعمل
    output reg RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch,ZeroExtend
    output reg [1:0] ALUOp       // سیگنال کنترلی برای ALU
);

    always @(*) begin
        case (opcode)
            6'b000000: begin // R-type
                ZeroExtend = 1'b0; 
                RegDst   = 1;
                ALUSrc   = 0;
                MemToReg = 0;
                RegWrite = 1;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 0;
                ALUOp    = 2'b10;
            end
            6'b100011: begin // lw
                ZeroExtend = 1'b0;
                RegDst   = 0;
                ALUSrc   = 1;
                MemToReg = 1;
                RegWrite = 1;
                MemRead  = 1;
                MemWrite = 0;
                Branch   = 0;
                ALUOp    = 2'b00;
            end
            6'b101011: begin // sw
                ZeroExtend = 1'b0;
                RegDst   = 0; // X (بی‌اثر)
                ALUSrc   = 1;
                MemToReg = 0; // X (بی‌اثر)
                RegWrite = 0;
                MemRead  = 0;
                MemWrite = 1;
                Branch   = 0;
                ALUOp    = 2'b00;
            end
            6'b000100: begin // beq
                ZeroExtend = 1'b0;
                RegDst   = 0; // X (بی‌اثر)
                ALUSrc   = 0;
                MemToReg = 0; // X (بی‌اثر)
                RegWrite = 0;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 1;
                ALUOp    = 2'b01;
            end
            6'b001101: begin // ori
                ZeroExtend = 1'b1; 
                RegDst   = 0;
                ALUSrc   = 1;
                MemToReg = 0;
                RegWrite = 1;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 0;
                ALUOp    = 2'b11;  // کد جدید برای ORI
            end
            default: begin // دستورالعمل نامعتبر
                ZeroExtend = 1'b0;
                RegDst   = 0;
                ALUSrc   = 0;
                MemToReg = 0;
                RegWrite = 0;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 0;
                ALUOp    = 2'b00;
            end
        endcase
    end
endmodule

module ControlMux (
    input wire stall,
    input wire [7:0] control_in,  // سیگنال‌های کنترلی از کنترلر
    output wire [7:0] control_out 
);

    assign control_out = (stall) ? {7{1'b0}} : control_in;

endmodule
module DataMemory (
    input wire clk, MemRead, MemWrite,
    input wire [31:0] Address, WriteData,
    output reg [31:0] ReadData
);

    reg [31:0] memory [0:1023]; // 256 words (1024 bytes)

    initial begin
        memory[0] = 32'h00000000 ;
        memory[1] = 32'h00000001 ;
        for (integer i = 2 ; i < 255 ; i++)
        begin
            memory[i] = 32'h0 ; 
        end
    end
    always @(posedge clk) begin
        if (MemWrite) 
            memory[Address[31:2]] <= WriteData; // Writing data to memory
    end

    always @(*) begin
        if (MemRead) 
            ReadData = memory[Address[31:2]]; // Reading data from memory
        else
            ReadData = 32'b0;
    end

endmodule
module EX_MEM_Register (
    input wire clk, reset,
    input wire MemRead, MemWrite, MemToReg, RegWrite,
    input wire [31:0] ALUResult, RD2,
    input wire [4:0] Rd,

    output reg MemRead_out, MemWrite_out, MemToReg_out, RegWrite_out,
    output reg [31:0] ALUResult_out, RD2_out,
    output reg [4:0] Rd_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            MemRead_out <= 0;
            MemWrite_out <= 0;
            MemToReg_out <= 0;
            RegWrite_out <= 0;
            ALUResult_out <= 32'b0;
            RD2_out <= 32'b0;
            Rd_out <= 5'b0;
        end else begin
            MemRead_out <= MemRead;
            MemWrite_out <= MemWrite;
            MemToReg_out <= MemToReg;
            RegWrite_out <= RegWrite;
            ALUResult_out <= ALUResult;
            RD2_out <= RD2;
            Rd_out <= Rd;
        end
    end

endmodule
module ForwardingUnit (
    input wire [4:0] ID_EX_Rs, ID_EX_Rt, EX_MEM_Rd, MEM_WB_Rd,
    input wire ID_EX_RegWrite, EX_MEM_RegWrite, MEM_WB_RegWrite,
    output reg [1:0] ForwardA, ForwardB
);

    always @(*) begin
        // برای ForwardA:
if (EX_MEM_RegWrite && (ID_EX_Rs != 0) && (ID_EX_Rs == EX_MEM_Rd))
    ForwardA = 2'b10;
else if (MEM_WB_RegWrite && (ID_EX_Rs != 0) && (ID_EX_Rs == MEM_WB_Rd))
    ForwardA = 2'b01;
else 
    ForwardA = 2'b00;

// برای ForwardB:
if (EX_MEM_RegWrite && (ID_EX_Rt != 0) && (ID_EX_Rt == EX_MEM_Rd))
    ForwardB = 2'b10;
else if (MEM_WB_RegWrite && (ID_EX_Rt != 0) && (ID_EX_Rt == MEM_WB_Rd))
    ForwardB = 2'b01;
else 
    ForwardB = 2'b00;

    end

endmodule

module HazardDetectionUnit(
    input ID_EX_MemRead,
    input [4:0] ID_EX_Rt,
    input [4:0] IF_ID_Rs,
    input [4:0] IF_ID_Rt,
    output reg PC_stall,
    output reg IF_ID_stall,
    output reg ControlMux
);

always @(*) begin
    if (ID_EX_MemRead && 
        ((IF_ID_Rs == ID_EX_Rt ) || 
         (IF_ID_Rt == ID_EX_Rt ))) begin
        // Stall the pipeline
        PC_stall     = 1'b1;
        IF_ID_stall   = 1'b1;
        ControlMux  = 1'b1; // Insert bubble
    end else begin
        // No stall
        PC_stall     = 1'b0;
        IF_ID_stall   = 1'b0;
        ControlMux  = 1'b0; // Normal operation
    end
end

endmodule
module ID_EX_Register (
    input wire clk, reset,
    input wire RegDst, ALUSrc, MemRead, MemWrite, MemToReg, RegWrite,
    input wire [1:0] ALUOp, 
    input wire [31:0] RD1, RD2, SignExtend,
    input wire [4:0] Rs, Rt, Rd,
    input wire [5:0] funct, 

    output reg RegDst_out, ALUSrc_out, MemRead_out, MemWrite_out, MemToReg_out, RegWrite_out,
    output reg [1:0] ALUOp_out,
    output reg [31:0] RD1_out, RD2_out, SignExtend_out,
    output reg [4:0] Rs_out, Rt_out, Rd_out,
    output reg [5:0] funct_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            RegDst_out <= 0;
            ALUOp_out <= 2'b00;
            ALUSrc_out <= 0;
            MemRead_out <= 0;
            MemWrite_out <= 0;
            MemToReg_out <= 0;
            RegWrite_out <= 0;
            RD1_out <= 32'b0;
            RD2_out <= 32'b0;
            SignExtend_out <= 32'b0;
            Rs_out <= 5'b0;
            Rt_out <= 5'b0;
            Rd_out <= 5'b0;
            funct_out <= 6'b0;
        end else begin
            RegDst_out <= RegDst;
            ALUOp_out <= ALUOp;
            ALUSrc_out <= ALUSrc;
            MemRead_out <= MemRead;
            MemWrite_out <= MemWrite;
            MemToReg_out <= MemToReg;
            RegWrite_out <= RegWrite;
            RD1_out <= RD1;
            RD2_out <= RD2;
            SignExtend_out <= SignExtend;
            Rs_out <= Rs;
            Rt_out <= Rt;
            Rd_out <= Rd;
            funct_out <= funct;
        end
    end

endmodule
module IF_ID_Register (
    input wire clk, reset, flush, stall,
    input wire [31:0] PC_Plus4, Instruction, 
    output reg [31:0] PC_Plus4_out, Instruction_out
);

    always @(posedge clk or posedge reset) begin
        if (reset || flush) begin
            PC_Plus4_out <= 32'b0;
            Instruction_out <= 32'b0;
        end else if (!stall) begin  // در صورت فعال بودن stall، مقدار قبلی حفظ می‌شود
            PC_Plus4_out <= PC_Plus4;
            Instruction_out <= Instruction;
        end
    end

endmodule
module InstructionMemory (
    input wire clk,                   
    input wire [31:0] PC,       
    output reg [31:0] instruction    
);
    reg [31:0] mem [0:1];

    initial begin
    
        mem[0] = 32'b101011_00000_00001_0000_0000_0000_0000;
        

        
        // بقیه خانه‌های حافظه می‌توانند مقدار 0 داشته باشند یا به صورت دلخواه مقداردهی شوند.
        // در اینجا به صورت پیش‌فرض مقداردهی نمی‌شوند.
    end

    always @(posedge clk) begin
        instruction <= mem[PC[31:2]];
    end

endmodule

module MEM_WB_Register (
    input         clk,         
    input         reset,          
    // Inputs from MEM stage
    input          RegWrite,   
    input          MemtoReg,   
    input  [31:0]  ALUResult, 
    input  [31:0]  ReadData, 
    input  [4:0]   Rd,   
    // Outputs to WB stage
    output reg    RegWrite_out,    
    output reg    MemtoReg_out,  
    output reg [31:0] ALUResult_out, 
    output reg [31:0] ReadData_out,  
    output reg [4:0]  Rd_out 
);

// Sequential logic to latch inputs on clock edge or reset
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset all outputs to default values
     RegWrite_out  <= 1'b0;
     MemtoReg_out  <= 1'b0;
     ALUResult_out <= 32'h0;
     ReadData_out  <= 32'h0;
     Rd_out  <= 5'h0;
    end
    else begin
        // Pass MEM stage signals to WB stage
        RegWrite_out  <= RegWrite;
        MemtoReg_out  <= MemtoReg;
        ALUResult_out <= ALUResult;
        ReadData_out  <= ReadData;
        Rd_out  <= Rd;
    end
end

endmodule
module MUX_2x1_5(
    input wire [4:0] input0 ,
    input wire [4:0] input1 , 
    input wire sel ,
    output reg [4:0] result  
);

always @(*)begin
    case(sel)
        1'b0:
            begin
                result <= input0;
            end
        1'b1:
            begin
                result <= input1 ; 
            end
    endcase
end
endmodule
module MUX_2x1_32(
    input wire [31:0] input0 ,
    input wire [31:0] input1 , 
    input wire sel ,
    output reg [31:0] result  
);

always @(*)begin
    case(sel)
    1'b0:
    begin
        result <= input0;
    end
    1'b1:
    begin
        result <= input1 ; 
    end
endcase
end
endmodule
module MUX_3x1_32(
    input wire [31:0] maininput,
    input wire [31:0] fw1, 
    input wire [31:0] fw2,
    input wire [1:0] sel,
    output reg [31:0] result  
);

always @(*) begin
    case(sel)
        2'b00: result = maininput;
        2'b01: result = fw2;
        2'b10: result = fw1;
        default: result = maininput; // حالت نامعتبر
    endcase
end
endmodule
module PC_Register(
    input wire clk, 
    input wire reset,
    input wire stall,
    input wire [31:0] PC_IN,
    output reg [31:0] PC_OUT
);
always @(posedge clk or posedge reset) begin
    if (reset)
        PC_OUT <= 32'h0000;
    else if (!stall)
        PC_OUT <= PC_IN;
    // در صورت stall، مقدار قبلی حفظ می‌شود.
end
endmodule
module PCAdder (
    input wire [31:0] PC_in,   
    output wire [31:0] PC_out    
);
    assign PC_out = PC_in + 32'd4;
endmodule
module RegisterFile(
    input wire clk,
    input wire reset,
    input wire [4:0] adr1, 
    input wire [4:0] adr2, 
    input wire [4:0] writeadr, 
    input wire [31:0] WriteData,
    input wire RegWrite, 
    output reg [31:0] ReadData1, 
    output reg [31:0] ReadData2
);
    reg [31:0] registers[31:0];
    
    initial 
    begin 
        registers[0] = 32'h00000000 ; 
        registers[1] = 32'h00000006 ; 
        registers[2] = 32'h0 ; 
        registers[3] = 32'h0 ; 
        registers[4] = 32'h0 ; 
        registers[5] = 32'h0 ; 
        registers[6] = 32'h0 ; 
        registers[7] = 32'h0 ; 
        registers[8] = 32'h0 ; 
        registers[9] = 32'h0 ; 
        registers[10] = 32'h0 ; 
        registers[11] = 32'h0 ; 
        registers[12] = 32'h0 ; 
        registers[13] = 32'h0 ; 
        registers[14] = 32'h0 ; 
        registers[15] = 32'h0 ; 
        registers[16] = 32'h0 ; 
        registers[17] = 32'h0 ; 
        registers[18] = 32'h0 ; 
        registers[19] = 32'h0 ; 
        registers[20] = 32'h0 ; 
        registers[21] = 32'h0 ; 
        registers[22] = 32'h0 ; 
        registers[23] = 32'h0 ; 
        registers[24] = 32'h0 ; 
        registers[25] = 32'h0 ; 
        registers[26] = 32'h0 ; 
        registers[27] = 32'h0 ; 
        registers[28] = 32'h0 ; 
        registers[29] = 32'h0 ; 
        registers[30] = 32'h0 ; 
        registers[31] = 32'h0 ; 

    end
    
    always @(*) begin
        ReadData1 = registers[adr1];
        ReadData2 = registers[adr2];
    end
    
    always @(posedge clk) begin
        if (RegWrite)
            registers[writeadr] <= WriteData;
    end
endmodule
module ShiftLeft2 (
    input wire [31:0] in,
    output wire [31:0] out
);

assign out = in << 2;

endmodule
module SignExtend (
    input [15:0] in,
    input ZeroExtend,  // New control signal
    output reg [31:0] out
);
always @(*) begin
    if (ZeroExtend)
        out = {16'h0000, in};  // Zero-extension for ORI
    else
        out = { {16{in[15]}}, in };  // Sign-extension for others
end
endmodule


module MIPS5 (
    input wire clk, reset
);
// IF stage
wire [31:0] PC, Instruction , PC_Plus4;
wire [31:0] NextPC;
PC_Register pc(
    .clk(clk),
    .stall(PC_stall),
    .reset(reset),
    .PC_IN(NextPC),
    .PC_OUT(PC)
);
InstructionMemory instruction_memory(
    .clk(clk),
    .PC(PC),
    .instruction(Instruction)
);
PCAdder pc_adder(
    .PC_in(PC),
    .PC_out(PC_Plus4)
);
MUX_2x1_32 mux_2x1_32(
    .input0(PC_Plus4),
    .input1(Branch_Address),
    .sel(taken), 
    .result(NextPC)
);
// IF/ID Register
wire [31:0] IF_ID_PC_Plus4 ,IF_ID_Instruction ;
IF_ID_Register if_id_register(
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
// wire RegWrite, MemRead, MemWrite, ALUSrc, RegDst, MemtoReg, Jump;


RegisterFile register_file(
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
wire Branch , ZeroExtend ; 
Controller controller(
    .opcode(IF_ID_Instruction[31:26]),
    .RegDst(control_signals[7]),
    .ALUSrc(control_signals[6]),
    .MemToReg(control_signals[5]),
    .RegWrite(control_signals[4]),
    .MemRead(control_signals[3]),
    .MemWrite(control_signals[2]),
    .Branch(Branch),
    .ALUOp(control_signals[1:0]),
    .ZeroExtend(ZeroExtend)
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

wire [31:0] signExtended;
SignExtend sign_extend(
    .in(IF_ID_Instruction[15:0]),
    .out(signExtended),
    .ZeroExtend(ZeroExtend)
);
wire [31:0] signExtended_shiftleft2;
ShiftLeft2 shift_left_2(
    .in(signExtended),
    .out(signExtended_shiftleft2)
);
wire [31:0] Branch_Address;
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
    .IF_ID_Rs(IF_ID_Instruction[25:21]),
    .IF_ID_Rt(IF_ID_Instruction[20:16]),
    .PC_stall(PC_stall),
    .IF_ID_stall(IF_ID_stall),
    .ControlMux(ControlMux)
);
wire [7:0] ControlMuxToRegister ; 
ControlMux control_mux(
    .stall(ControlMux),
    .control_in(control_signals),
    .control_out(ControlMuxToRegister)
);
wire ID_EX_RegDst, ID_EX_MemRead ,ID_EX_ALUSrc,ID_EX_MemWrite , ID_EX_MemToReg , ID_EX_RegWrite;
wire [4:0] ID_EX_Rt,ID_EX_Rs,ID_EX_Rd;
wire [5:0] ID_EX_func;
wire [31:0] ID_EX_RD1 , ID_EX_RD2 ,ID_EX_SignExtended ;
wire [1:0] ID_EX_ALUOp ; 
// ID/EX Register
ID_EX_Register id_ex_register(
    .clk(clk),
    .reset(reset),
    .RegDst(ControlMuxToRegister[7]),
    .ALUSrc(ControlMuxToRegister[6]),
    .MemToReg(ControlMuxToRegister[5]),
    .RegWrite(ControlMuxToRegister[4]),
    .MemRead(ControlMuxToRegister[3]),
    .MemWrite(ControlMuxToRegister[2]),
    .ALUOp(ControlMuxToRegister[1:0]),
    .RD1(RegData1),
    .RD2(RegData2),
    .SignExtend(signExtended),
    .Rs(IF_ID_Instruction[25:21]),
    .Rt(IF_ID_Instruction[20:16]),
    .Rd(IF_ID_Instruction[15:11]),
    .funct(IF_ID_Instruction[5:0]),
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
wire [31:0] rt_or_signExtended;
MUX_2x1_32 alu_src(
    .input0(forwarded_RD2),  // استفاده از RD2 فوروارد شده
    .input1(ID_EX_SignExtended),
    .sel(ID_EX_ALUSrc),
    .result(rt_or_signExtended)
);
wire [31:0] inputA;
MUX_3x1_32 A(
    .maininput(ID_EX_RD1),
    .fw1(EX_MEM_ALUResult),
    .fw2(WriteData),  // مقدار از مرحله WB
    .sel(ForwardA),
    .result(inputA)
);
wire [31:0] forwarded_RD2;
MUX_3x1_32 B_forwarding (
    .maininput(ID_EX_RD2),
    .fw1(EX_MEM_ALUResult),
    .fw2(WriteData),  // مقدار از مرحله WB
    .sel(ForwardB),
    .result(forwarded_RD2)
);
// ALU Control
wire [3:0] ALUControl;
ALUControl alu_control (
    .ALUOp(ID_EX_ALUOp),
    .Funct(ID_EX_func),
    .ALUControl(ALUControl)
);

// Forwarding Unit
wire [1:0] ForwardA, ForwardB;
ForwardingUnit forwarding_unit (
    .ID_EX_Rs(ID_EX_Rs),
    .ID_EX_Rt(ID_EX_Rt),
    .EX_MEM_Rd(EX_MEM_Rd),
    .MEM_WB_Rd(MEM_WB_Rd),
    .ID_EX_RegWrite(ID_EX_RegWrite),
    .EX_MEM_RegWrite(EX_MEM_RegWrite),
    .MEM_WB_RegWrite(MEM_WB_RegWrite),
    .ForwardA(ForwardA),
    .ForwardB(ForwardB)
);
wire [31:0] ALUResult;
wire zero, overflow;
ALU alu (
    .A(inputA),
    .B(rt_or_signExtended),  // حالا inputB شامل RD2 فوروارد شده یا Immediate است
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
    .MemToReg(ID_EX_MemtoReg),
    .RegWrite(ID_EX_RegWrite),
    .ALUResult(ALUResult),
    .RD2(ID_EX_RD2),
    .Rd(writeadr),

    .MemRead_out(EX_MEM_MemRead),
    .MemWrite_out(EX_MEM_MemWrite),
    .MemToReg_out(EX_MEM_MemtoReg),
    .RegWrite_out(EX_MEM_RegWrite),
    .ALUResult_out(EX_MEM_ALUResult),
    .RD2_out(EX_MEM_RD2),
    .Rd_out(EX_MEM_Rd)
);

// MEM stage
wire [31:0] DataMemoryOutput;
DataMemory data_memory (
    .clk(clk),
    .Address(EX_MEM_ALUResult),
    .WriteData(EX_MEM_RD2),
    .MemRead(EX_MEM_MemRead),
    .MemWrite(EX_MEM_MemWrite),
    .ReadData(DataMemoryOutput)
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
    .input0(MEM_WB_ALUResult),
    .input1(MEM_WB_ReadData),
    .sel(MEM_WB_MemtoReg),
    .result(WriteData)
);
endmodule
