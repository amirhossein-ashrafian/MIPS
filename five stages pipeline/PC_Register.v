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
