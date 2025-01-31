module ControlMux (
    input wire stall,
    input wire [8:0] control_in,  // سیگنال‌های کنترلی از کنترلر
    output wire [8:0] control_out 
);

    assign control_out = (stall) ? {8{1'b0}} : control_in;

endmodule
