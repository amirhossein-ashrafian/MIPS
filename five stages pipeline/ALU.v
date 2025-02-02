module ALU (
    input wire [31:0] A, B,       
    input wire [3:0] ALUControl,  
    output reg [31:0] Result,    
    output reg Zero,            // zero flag 
    output reg Overflow         // overflow flag 
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

        // if result==0 then zero = 1 
        Zero = (Result == 32'b0) ? 1 : 0;
    end

endmodule
