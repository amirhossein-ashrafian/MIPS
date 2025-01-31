module InstructionMemory (
    input wire clk,                   
    input wire [31:0] PC,       
    output reg [31:0] instruction    
);
    reg [31:0] mem [255:0];          

    initial begin
        $readmemh("instructions.mem", mem);
    end

    always @(posedge clk) begin
        instruction <= mem[PC]; 
    end

endmodule
