module ALU_InputB_Mux (
    input wire [31:0] Rt, EX_MEM_ALUResult, MEM_WB_ALUResult,
    input wire [1:0] ForwardB,
    output reg [31:0] ALUInputB
);

    always @(*) begin
        case(ForwardB)
            2'b00: ALUInputB = Rt; // انتخاب Rt از رجیستر
            2'b01: ALUInputB = MEM_WB_ALUResult; // انتخاب ALUResult از MEM/WB
            2'b10: ALUInputB = EX_MEM_ALUResult; // انتخاب ALUResult از EX/MEM
            default: ALUInputB = Rt;
        endcase
    end

endmodule