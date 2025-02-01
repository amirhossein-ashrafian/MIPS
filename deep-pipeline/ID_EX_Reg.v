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
