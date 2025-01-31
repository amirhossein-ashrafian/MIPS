module EqualityComparator32 (
    input wire [31:0] A, B,
    output wire equal
);

assign equal = (A == B);

endmodule
