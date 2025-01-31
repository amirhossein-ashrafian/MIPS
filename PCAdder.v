module PCAdder (
    input wire [31:0] PC_in,     // مقدار فعلی PC
    output wire [31:0] PC_out    // مقدار جدید PC (PC + 4)
);
    assign PC_out = PC_in + 32'd4;
endmodule
