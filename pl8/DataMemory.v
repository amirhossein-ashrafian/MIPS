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

module StagedMemory(
    input clk, reset,
    // Stage 1: Address Calculation (AC)
    input [31:0] addr_in,
    input [31:0] write_data_in,
    input mem_write_in,
    // Stage 2: Memory Request (MR)
    output reg [31:0] read_data_out,
    output reg mem_ready,
    // Stage 3: Memory Completion (MC)
    output reg [31:0] write_data_out,
    output reg write_done
);
    reg [31:0] mem [0:1023];  // Memory array
    reg [31:0] addr_reg;
    reg [31:0] write_data_reg;
    reg mem_write_reg;

    initial begin
        mem[0] = 32'd0;
        mem[4] = 32'd1;
        for (integer i = 2 ; i < 255 ; i++)
        begin
            mem[i] = 32'h0 ; 
        end
    end

    // Stage 1: Capture address/data
    always @(posedge clk) begin
        if (reset) begin
            addr_reg <= 0;
            write_data_reg <= 0;
            mem_write_reg <= 0;
        end else begin
            addr_reg <= addr_in;
            write_data_reg <= write_data_in;
            mem_write_reg <= mem_write_in;
        end
    end

    // Stage 2: Perform memory operation
    always @(posedge clk) begin
        if (mem_write_reg) begin
            mem[addr_reg] <= write_data_reg;  // Write
            write_done <= 1;
        end else begin
            read_data_out <= mem[addr_reg];   // Read
            mem_ready <= 1;
        end
    end

    // Stage 3: Reset flags for next cycle
    always @(posedge clk) begin
        write_done <= 0;
        mem_ready <= 0;
    end
endmodule