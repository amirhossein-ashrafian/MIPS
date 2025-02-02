module IF_PR_Register (
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

module PR_ID_Register (
    input wire [31:0] PC_Plus4_in, Read_Data_1, Read_Data_2, 
    input wire clk, reset, flush, stall,
    input wire [4:0] opcode_in,
    output reg [31:0] PC_Plus4_out, register_out
    output wire [4:0] opcode_out,
);

    always @(posedge clk or posedge reset) begin
        if(reset || flush) begin 
            PC_Plus4_out <= 32'd0;
            register_out <= 32'd0;
            opcode_out <= 5'd0;
        end else if (!stall) begin
            PC_Plus4_out <= PC_Plus4_in;
            register_out <= register_in;
            opcode_out <= opcode_in;
        end
    end

endmodule

module ID_EX_Register (
    input wire [31:0] PC_Plus4_in, Read_Data_1_in, Read_Data_2_in,
    input wire clk, reset, flush, stall,
    input wire RegDst_in, ALUSrc_in, MemToReg_in, RegWrite_in, MemRead_in, MemWrite_in, Branch_in,
    output reg [31:0] PC_Plus4_out, Read_Data_1_out, Read_Data_2_out,
    output reg RegDst_out, ALUSrc_out, MemToReg_out, RegWrite_out, MemRead_out, MemWrite_out, Branch_out
);

    always @(posedge clk or posedge reset) begin
        if(reset || flush) begin 
            PC_Plus4_out <= 32'd0;
            Read_Data_1_out <= 32'd0;
            Read_Data_2_out <= 32'd0;

            RegDst_out <= 0;
            ALUSrc_out <= 0;
            MemtoReg_out <= 0;
            RegWrite_out <= 0;
            MemRead_out <= 0;
            MemWrite_out <= 0;
            Branch_out <= 0;

        end else if (!stall) begin
            
            PC_Plus4_out <= PC_Plus4_in;
            Read_Data_1_out <= Read_Data_1_in;
            Read_Data_2_out <= Read_Data_1_in;

            RegDst_out <= RegDst_in;
            ALUSrc_out <= ALUSrc_in;
            MemtoReg_out <= MemToReg_in;
            RegWrite_out <= RegWrite_in;
            MemRead_out <= MemRead_out;
            MemWrite_out <= MemWrite_in;
            Branch_out <= Branch_in;
        end
    end

endmodule