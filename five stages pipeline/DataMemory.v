module DataMemory (
    input wire clk, MemRead, MemWrite,
    input wire [31:0] Address, WriteData,
    output reg [31:0] ReadData
);

    reg [31:0] memory [0:1023]; // 1024 words

    initial begin
        memory[0] = 32'h0 ;
        memory[1] = 32'h00000001 ;
        for (integer i = 2 ; i < 255 ; i++)
        begin
            memory[i] = 32'h0 ; 
        end
    end
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
