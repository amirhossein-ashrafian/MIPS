module MUX_3x1_32(
    input wire [31:0] maininput,
    input wire [31:0] fw1, 
    input wire [31:0] fw2,
    input wire [1:0] sel,
    output reg [31:0] result  
);

always @(*) begin
    case(sel)
        2'b00: result = maininput;
        2'b01: result = fw2;
        2'b10: result = fw1;
        default: result = maininput; // حالت نامعتبر
    endcase
end
endmodule
