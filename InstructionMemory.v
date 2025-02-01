module InstructionMemory (
    input wire clk,                   
    input wire [31:0] PC,       
    output reg [31:0] instruction    
);
    reg [31:0] mem [255:0];          

    initial begin
        mem[0] = 32'h8C080000 ; //lw 
	    mem[4] = 32'h8C090004 ; //lw 
	    mem[8] = 32'h340B0002 ; // i++
	    mem[12] = 32'h340C0008 ; // add 2
	    mem[16] = 32'h340D0004 ; // add 3 
	    mem[20] = 32'h340E0001 ; // i++
	    mem[24] = 32'h340F000C; // add 4
	    mem[28] = 32'h01095020 ; // i++
	    mem[32] = 32'h8D4A0000; // add 5
	    mem[36] = 32'h014D6020 ; // i++
	    mem[40] = 32'h01004020 ; //lsti
	    mem[44] = 32'h010A4820 ; // beq
	    mem[48] = 32'h016E5820 ; // sw
	    mem[52] = 32'h116F0002 ; // sw
	    mem[56] = 32'h08000007 ; // sw
	    mem[60] = 32'h0800000F ; // sw
	    mem[64] = 32'h08000007 ; // sw



    end

    always @(posedge clk) begin
    instruction <= mem[PC[31:2]];
end


endmodule
