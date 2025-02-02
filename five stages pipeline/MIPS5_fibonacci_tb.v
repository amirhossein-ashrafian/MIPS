`include "MIPS5.v"
module MIPS5_tb;

    reg clk;
    reg reset;
    
    MIPS5 dut ( .clk(clk), .reset(reset) );
    
    always #5 clk = ~clk; // کلاک 50MHz
    
    initial begin
        $dumpfile("mips5_wave3.vcd");
        $dumpvars(0, MIPS5_tb.dut);
        
        clk = 0;
        reset = 1;
        #20;
        reset = 0;
        #600; // زمان کافی برای اجرای تمام دستورات
        
        // چاپ مقادیر رجیسترها
        $display("\n📥 Registers:");
        for (integer i = 0; i < 12; i++) 
            $display("$%0d = %d", i, dut.register_file.registers[i]);
        
        // چاپ مقادیر حافظه
        $display("\n📦 Memory:");
        for (integer i = 0; i < 12; i++) 
            $display("Memory[%0d] = %d", i, dut.data_memory.memory[i]);
        
        $finish;
    end
endmodule