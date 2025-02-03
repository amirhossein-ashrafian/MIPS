module DataMemoryWrite (
    input wire clk,
    input wire MemRead,
    input wire [31:0] WriteData, Address, ReadDataAddress,
    output reg [31:0] ReadDataOutput
);

    reg [31:0] memory [0:255];

    always @(posedge clk) begin
        $display("Write data: %b", WriteData);
        memory[Address[31:2]] <= WriteData;
        if(Address == ReadDataAddress && MemRead) ReadDataOutput <= WriteData;
    end
    
endmodule