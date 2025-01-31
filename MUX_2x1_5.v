module MUX_2x1_5(
    input wire [4:0] input0 ,
    input wire [4:0] input1 , 
    input wire sel ,
    output reg [4:0] result  
);

always @(input0 , input1 , sel)begin
    case(sel)
        1'b0:
            begin
                result <= input0;
            end
        1'b1:
            begin
                result <= input1 ; 
            end
    endcase
end
endmodule