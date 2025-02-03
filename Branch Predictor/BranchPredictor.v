module BranchPredictor (
    input         clk,      
    input         reset,   
    input  [31:0] PC,        
    input         update,    
    input         actual,    
    output        predict   
);

    reg [1:0] predictor_table [0:511]; // جدول 1024 سطری ، هر سطر شامل 2 بیت
    reg [6:0] GBHR // یک نوع شیفت رجیستر برای ذخیره سازی نتیجه آخرین برنچ

    wire [8:0] index;
    // انتخاب سطر مورد نظر براساس ۲ بیت کم ارزش پی سی و ایکس اور ۸ بیت پرارزشتر و گلوبال برنچ هیستوری رجیستر
    assign index = {PC[8:2] ^ GBHR, PC[1:0]}; 

    assign predict = (predictor_table[index] >= 2) ? 1'b1 : 1'b0; // خروجی پیشبینی به این صورت که اگر مقدار سطر از 2 بیشتر بود تیکن است

    integer i;
    // به‌روزرسانی جدول پیش‌بینی و مقداردهی اولیه
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            GBHR <= 7'd0;
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
            GBHR <= {GBHR[5:0], actual};
        end
    end

endmodule
