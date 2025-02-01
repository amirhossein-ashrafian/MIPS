module BranchPredictor (
    input         clk,      
    input         reset,   
    input  [31:0] PC,        
    input         update,    
    input         actual,    
    output        predict   
);

    reg [1:0] predictor_table [0:1023]; // جدول 1024 سطری ، هر سطر شامل 2 بیت

    wire [9:0] index;
    assign index = PC[9:0]; // انتخاب سطر مورد نظر برای بررسی بر اساس 10 بیت کم ارزش پی سی

    assign predict = (predictor_table[index] >= 2) ? 1'b1 : 1'b0; // خروجی پیشبینی به این صورت که اگر مقدار سطر از 2 بیشتر بود تیکن است

    integer i;
    // به‌روزرسانی جدول پیش‌بینی و مقداردهی اولیه
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // مقداردهی اولیه تمامی سطرها به حالت 01 (ضعیف غیرتیرش)
            for (i = 0; i < 1024; i = i + 1) begin
                predictor_table[i] <= 2'b01;
            end
        end else if (update) begin
            if (actual) begin
                // تا رسیدن به 11 افزایش میدهیم
                if (predictor_table[index] != 2'b11)
                    predictor_table[index] <= predictor_table[index] + 1;
            end else begin
                // تا رسیدن به 00 کاهش میدهیم
                if (predictor_table[index] != 2'b00)
                    predictor_table[index] <= predictor_table[index] - 1;
            end
        end
    end

endmodule
