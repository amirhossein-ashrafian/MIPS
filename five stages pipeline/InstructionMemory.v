module InstructionMemory (
    input wire clk,                   
    input wire [31:0] PC,       
    output reg [31:0] instruction    
);
    reg [31:0] mem [0:1];

    initial begin
        // دستور 1: ori $t0, $0, 6
        //  - opcode: 001101 (ori)
        //  - rs: $0 (00000)
        //  - rt: $t0 (01000)
        //  - immediate: 16-bit مقدار 6 (0000_0000_0000_0110)
        // کد نهایی: 32'h34080006
        mem[0] = 32'h34080006;
        
        // دستور 2: sw $t0, 0($0)
        //  - opcode: 101011 (sw)
        //  - base: $0 (00000)
        //  - rt: $t0 (01000)
        //  - offset: 0 (0000_0000_0000_0000)
        // کد نهایی: 32'hAC080000
        mem[1] = 32'hAC080000;
        
        // بقیه خانه‌های حافظه می‌توانند مقدار 0 داشته باشند یا به صورت دلخواه مقداردهی شوند.
        // در اینجا به صورت پیش‌فرض مقداردهی نمی‌شوند.
    end

    always @(posedge clk) begin
        instruction <= mem[PC[31:2]];
    end

endmodule
