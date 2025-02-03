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
    input wire [31:0] PC_Plus4_in, Read_Data_1, Read_Data_2, Sign_extended,
    input wire clk, reset, flush, stall,
    input wire [4:0] opcode_in,
    output reg [31:0] PC_Plus4_out, Read_Data_1_out, Read_Data_2_out, Sign_Extended_out,
    output reg [4:0] opcode_out
);

    always @(posedge clk or posedge reset) begin
        if(reset || flush) begin 
            PC_Plus4_out <= 32'd0;
            Read_Data_1_out <= 32'd0;
            Read_Data_2_out <= 32'd0;
            Sign_Extended_out <= 32'd0;
            opcode_out <= 5'd0;
        end else if (!stall) begin
            PC_Plus4_out <= PC_Plus4_in;
            Read_Data_1_out <= Read_Data_1;
            Read_Data_2_out <= Read_Data_2;
            Sign_Extended_out <= Sign_extended;
            opcode_out <= opcode_in;
        end
    end

endmodule

/*
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
*/

module MR_MW_Register(
    input clk, reset,
    input wire RegWrite, MemToReg, MemWrite,
    input wire [4:0] Rd,
    input wire [31:0] Write_Data, Write_Address, Read_Data,

    output reg RegWrite_out, MemToReg_out, MemWrite_out,
    output reg [4:0] Rd_out,
    output reg [31:0] Write_Data_out, Write_Address_out, Read_Data_out
);

    always @(posedge clk or posedge reset) begin 
        if(reset) begin
            RegWrite_out <= 0;
            MemToReg_out <= 0;
            MemWrite_out <= 0;
            Rd_out <= 5'd0;
            Write_Data_out <= 32'd0;
            Write_Address_out <= 32'd0;
            Read_Data_out <= 32'd0;
        end else begin
            RegWrite_out <= RegWrite;
            MemToReg_out <= MemToReg;
            MemWrite_out <= MemWrite;
            Rd_out <= Rd;
            Write_Data_out <= Write_Data;
            Write_Address_out <= Write_Address;
            Read_Data_out <= Read_Data;
        end
    end
endmodule

module AC_MR_Register(
    input clk, reset,
    // From Address Calculation (AC)
    input [31:0] addr_in,
    input [31:0] write_data_in,
    input mem_write_in,
    // To Memory Request (MR)
    output reg [31:0] addr_out,
    output reg [31:0] write_data_out,
    output reg mem_write_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            addr_out <= 0;
            write_data_out <= 0;
            mem_write_out <= 0;
        end else begin
            addr_out <= addr_in;
            write_data_out <= write_data_in;
            mem_write_out <= mem_write_in;
        end
    end
endmodule