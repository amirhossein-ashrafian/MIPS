module BranchControl (
    input wire Branch,    // سیگنال Branch از کنترلر
    input wire equal,     // خروجی مقایسه‌کننده
    output wire PCSrc     // مشخص‌کننده‌ی تغییر PC
);
    assign PCSrc = Branch & equal;
endmodule
