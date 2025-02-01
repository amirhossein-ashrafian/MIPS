`include "MIPS5.v"
`timescale 1ns/1ps

module tb_MIPS5;

    // سیگنال‌های تست
    reg clk;
    reg reset;

    // نمونه‌سازی ماژول MIPS5
    MIPS5 uut (
        .clk(clk),
        .reset(reset)
    );

    // ژنراتور ساعت: دوره 10 ns (چرخه 10 ns)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // بلوک تست
    initial begin
        // ابتدا سیگنال reset فعال می‌شود
        reset = 1;
        #12;           // نگه داشتن reset به مدت 12 ns (حدود یک-دو چرخه)
        reset = 0;      // غیر فعال کردن reset
        
        // اجازه می‌دهیم شبیه‌سازی برای زمان کافی اجرا شود تا تمام مراحل pipeline به اتمام برسند
        #2000;
        
        // دسترسی به حافظه داده (DataMemory) به‌صورت سلسله‌مراتبی؛
        // انتظار می‌رود که دستور sw $t0, 0($0) مقدار 6 (32'h00000006) را در خانه 0 بنویسد.
        $display("At time %t, DataMemory[0] = %h (Expected: 00000006)", $time, uut.data_memory.memory[0]);
        
        #20;
        $finish;
    end

endmodule
