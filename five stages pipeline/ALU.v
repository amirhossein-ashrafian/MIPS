module ALU (
    input wire [31:0] A, B,       // دو ورودی 32 بیتی
    input wire [3:0] ALUControl,  // سیگنال کنترلی ALU
    output reg [31:0] Result,     // خروجی 32 بیتی ALU
    output reg Zero,              // پرچم Zero
    output reg Overflow           // پرچم Overflow برای ADD/SUB
);

    reg signed [31:0] signed_A, signed_B, signed_Result;

    always @(*) begin
        Overflow = 0;
        signed_A = A;
        signed_B = B;
        
        case (ALUControl)
            4'b0000: Result = A & B; // AND
            4'b0001: Result = A | B; // OR
            4'b0010: begin // ADD
                signed_Result = signed_A + signed_B;
                Result = signed_Result;
                Overflow = ((signed_A[31] == signed_B[31]) && (signed_A[31] != signed_Result[31]));
            end
            4'b0110: begin // SUB
                signed_Result = signed_A - signed_B;
                Result = signed_Result;
                Overflow = ((signed_A[31] != signed_B[31]) && (signed_A[31] != signed_Result[31]));
            end
            4'b0111: Result = (signed_A < signed_B) ? 32'b1 : 32'b0; // SLT (signed)
            4'b1100: Result = ~(A | B); // NOR
            default: Result = 32'b0;
        endcase

        // مقدار پرچم Zero اگر خروجی صفر باشد، 1 می‌شود.
        Zero = (Result == 32'b0) ? 1 : 0;
    end

endmodule
