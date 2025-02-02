module InstructionMemory (
    input wire clk,                   
    input wire [31:0] PC,       
    output reg [31:0] instruction    
);
    reg [31:0] mem [0:63];

    initial begin
        // دستورات اولیه
        mem[0]  = 32'h8C080000; // lw   $t0, 0($0)
        mem[1]  = 32'h8C090004; // lw   $t1, 4($0)
        mem[2]  = 32'h340C0008; // ori  $t4, $0, 8
        mem[3]  = 32'h340D0004; // ori  $t5, $0, 4

        // Iteration 1: محاسبه ترم سوم
        mem[4]  = 32'h01095020; // add  $t2, $t0, $t1
        mem[5]  = 32'hAD8A0000; // sw   $t2, 0($t4)
        mem[6]  = 32'h014D6020; // add  $t4, $t4, $t5
        mem[7]  = 32'h01004020; // add  $t0, $0, $t1
        mem[8]  = 32'h010A4820; // add  $t1, $0, $t2

        // Iteration 2: محاسبه ترم چهارم
        mem[9]  = 32'h01095020; // add  $t2, $t0, $t1
        mem[10] = 32'hAD8A0000; // sw   $t2, 0($t4)
        mem[11] = 32'h014D6020; // add  $t4, $t4, $t5
        mem[12] = 32'h01004020; // add  $t0, $0, $t1
        mem[13] = 32'h010A4820; // add  $t1, $0, $t2

        // Iteration 3: محاسبه ترم پنجم
        mem[14] = 32'h01095020; // add  $t2, $t0, $t1
        mem[15] = 32'hAD8A0000; // sw   $t2, 0($t4)
        mem[16] = 32'h014D6020; // add  $t4, $t4, $t5
        mem[17] = 32'h01004020; // add  $t0, $0, $t1
        mem[18] = 32'h010A4820; // add  $t1, $0, $t2

        // Iteration 4: محاسبه ترم ششم
        mem[19] = 32'h01095020; // add  $t2, $t0, $t1
        mem[20] = 32'hAD8A0000; // sw   $t2, 0($t4)
        mem[21] = 32'h014D6020; // add  $t4, $t4, $t5
        mem[22] = 32'h01004020; // add  $t0, $0, $t1
        mem[23] = 32'h010A4820; // add  $t1, $0, $t2

        // Iteration 5: محاسبه ترم هفتم
        mem[24] = 32'h01095020; // add  $t2, $t0, $t1
        mem[25] = 32'hAD8A0000; // sw   $t2, 0($t4)
        mem[26] = 32'h014D6020; // add  $t4, $t4, $t5
        mem[27] = 32'h01004020; // add  $t0, $0, $t1
        mem[28] = 32'h010A4820; // add  $t1, $0, $t2

        // Iteration 6: محاسبه ترم هشتم
        mem[29] = 32'h01095020; // add  $t2, $t0, $t1
        mem[30] = 32'hAD8A0000; // sw   $t2, 0($t4)
        mem[31] = 32'h014D6020; // add  $t4, $t4, $t5
        mem[32] = 32'h01004020; // add  $t0, $0, $t1
        mem[33] = 32'h010A4820; // add  $t1, $0, $t2

        // Iteration 7: محاسبه ترم نهم
        mem[34] = 32'h01095020; // add  $t2, $t0, $t1
        mem[35] = 32'hAD8A0000; // sw   $t2, 0($t4)
        mem[36] = 32'h014D6020; // add  $t4, $t4, $t5
        mem[37] = 32'h01004020; // add  $t0, $0, $t1
        mem[38] = 32'h010A4820; // add  $t1, $0, $t2

        // Iteration 8: محاسبه ترم دهم
        mem[39] = 32'h01095020; // add  $t2, $t0, $t1
        mem[40] = 32'hAD8A0000; // sw   $t2, 0($t4)
        mem[41] = 32'h014D6020; // add  $t4, $t4, $t5
        mem[42] = 32'h01004020; // add  $t0, $0, $t1
        mem[43] = 32'h010A4820; // add  $t1, $0, $t2

        // Iteration 9: محاسبه ترم یازدهم
        mem[44] = 32'h01095020; // add  $t2, $t0, $t1
        mem[45] = 32'hAD8A0000; // sw   $t2, 0($t4)
        mem[46] = 32'h014D6020; // add  $t4, $t4, $t5
        mem[47] = 32'h01004020; // add  $t0, $0, $t1
        mem[48] = 32'h010A4820; // add  $t1, $0, $t2

        // Iteration 10: محاسبه ترم دوازدهم
        mem[49] = 32'h01095020; // add  $t2, $t0, $t1
        mem[50] = 32'hAD8A0000; // sw   $t2, 0($t4)
        mem[51] = 32'h014D6020; // add  $t4, $t4, $t5
        mem[52] = 32'h01004020; // add  $t0, $0, $t1
        mem[53] = 32'h010A4820; // add  $t1, $0, $t2
    end
    always @(posedge clk) begin
    instruction <= mem[PC[31:2]];
end


endmodule