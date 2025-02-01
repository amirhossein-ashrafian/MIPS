module DataMemoryRead (
    input wire clk,
    input wire [31:0] Address,
    output reg [31:0] ReadData
);

    reg [31:0] memory [0:255];

    always @(posedge clk) ReadData = memory[Address[31:2]];
    
endmodule