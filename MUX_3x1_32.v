module MUX_3x1_32(
    input wire [31:0] maininput,
    input wire [31:0] fw1, 
    input wire [31:0] fw2
    input wire sel[1:0] ,
    output reg [31:0] result  
);

always @(maininput , fw1 ,fw2 , sel)begin
    case(sel)
    2'b00:
    begin
        result <= maininput;
    end
    2'b01:
    begin
        result <= fw1 ;
    end
    2'b10:
    begin
        result <= fw2 ; 
    end
    default: // invalid !!
    begin
        result <= maininput;
    end


endcase
end
endmodule