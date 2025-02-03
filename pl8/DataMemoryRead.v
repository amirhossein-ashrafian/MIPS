// Memory is not synced between memory read and write
// possible fix is to use another module to handle read and write
// or use memseth and memsetb and write to a file

module DataMemoryRead (
    input wire clk,
    input wire [31:0] Address,
    output reg [31:0] ReadData
);

    reg [31:0] memory [0:255];

    always @(posedge clk) ReadData = memory[Address[31:2]];
    
endmodule