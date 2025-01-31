module DataMemory (
    input wire clk, MemRead, MemWrite,
    input wire [31:0] Address, WriteData,
    output reg [31:0] ReadData
);

    reg [31:0] memory [0:255]; // 256 words (1024 bytes)

    always @(posedge clk) begin
        if (MemWrite) 
            memory[Address[31:2]] <= WriteData; // Writing data to memory
    end

    always @(*) begin
        if (MemRead) 
            ReadData = memory[Address[31:2]]; // Reading data from memory
        else
            ReadData = 32'b0;
    end

endmodule
