module ControlMux (
    input wire stall,
    input wire [7:0] control_in,  // سیگنال‌های کنترلی از کنترلر
    output wire [7:0] control_out 
);

    assign control_out = (stall) ? {7{1'b0}} : control_in;

endmodule
