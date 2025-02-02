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
