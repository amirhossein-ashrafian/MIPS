module SignExtend (
    input [15:0] in,
    output reg [31:0] out
);
always @(in) begin
    if (in[15] == 1)  begin     
        out = {16'hffff, in};
    end
    else if (in[15] == 0) begin
         out = {16'h0000, in};
    end
    else begin
        out = 32'hxxxx_xxxx;
    end
end
endmodule
