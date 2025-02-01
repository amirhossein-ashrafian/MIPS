module DataMemoryWrite (
    input wire clk,
    input wire [31:0] WriteData, Address
);

    reg [31:0] memory [0:255];

    always @(posedge clk) memory[Address[31:2]] <= WriteData;
    
endmodule