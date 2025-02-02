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