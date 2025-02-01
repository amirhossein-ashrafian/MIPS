module DataMemoryWrite (
    input wire clk,
    input reg [31:0] 
    input wire [31:0] WriteData, Address, ReadDataAddress,
    output [31:0] ReadDataOutput,
);

    reg [31:0] memory [0:255];

    always @(posedge clk) begin
        memory[Address[31:2]] <= WriteData;
        if(Address == ReadDataAddress) ReadDataOutput <= WriteData;
    end
    
endmodule