module ALU_InputA_Mux (
    input wire [31:0] Rs, EX_MEM_ALUResult, MEM_WB_ALUResult,
    input wire [1:0] ForwardA,
    output reg [31:0] ALUInputA
);

    always @(*) begin
        case(ForwardA)
            2'b00: ALUInputA = Rs; // انتخاب Rs از رجیستر
            2'b01: ALUInputA = MEM_WB_ALUResult; // انتخاب ALUResult از MEM/WB
            2'b10: ALUInputA = EX_MEM_ALUResult; // انتخاب ALUResult از EX/MEM
            default: ALUInputA = Rs;
        endcase
    end

endmodule