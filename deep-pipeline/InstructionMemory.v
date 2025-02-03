module InstructionMemory (
    input wire clk,                   
    input wire [31:0] PC,       
    output reg [31:0] instruction    
);
    reg [31:0] mem [255:0];          

    initial begin
        mem[0] = 32'h8C000000 ; //lw 
        mem[4] = 32'h8C010001 ; //lw 
        mem[8] = 32'h03FEF020 ; // i++
        mem[12] = 32'h00011020 ; // add 2
        mem[16] = 32'h00221820 ; // add 3 
        mem[20] = 32'h03FEF020 ; // i++
        mem[24] = 32'h00622020; // add 4
        mem[28] = 32'h03FEF020 ; // i++
        mem[32] = 32'h00832820; // add 5
        mem[36] = 32'h03FEF020 ; // i++
        mem[40] = 32'h28AA0006 ; //lsti
        // 0010 1000 1010 1010 0000 0000 0000 0110
        mem[44] = 32'h13C50002 ; // beq
        mem[48] = 32'hAC210000 ; // sw
        // 1010 1100 0010 0001 0000 0000 0000 0000
    end

    always @(posedge clk) begin
        instruction <= mem[PC[31:2]];
        $display("inst: %b", mem[PC[31:2]]);
        $display("pc: %b", PC);
    end


endmodule
