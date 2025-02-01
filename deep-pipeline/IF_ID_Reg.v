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
