module ALUControl (
    input wire [1:0] ALUOp,
    input wire [5:0] Funct,
    output reg [3:0] ALUControl
);

    always @(*) begin
        case (ALUOp)
            2'b00: ALUControl = 4'b0010; // lw/sw (عملیات جمع)
            2'b01: ALUControl = 4'b0110; // beq (عملیات تفریق)
            2'b10: begin
                case (Funct) // دستورات R-type
                    6'b100000: ALUControl = 4'b0010; // ADD
                    6'b100010: ALUControl = 4'b0110; // SUB
                    6'b100100: ALUControl = 4'b0000; // AND
                    6'b100101: ALUControl = 4'b0001; // OR
                    6'b101010: ALUControl = 4'b0111; // SLT
                    default:   ALUControl = 4'b1111; // نامعتبر
                endcase
            end
            2'b11: ALUControl = 4'b0001; // ORI
            default: ALUControl = 4'b1111; // نامعتبر
        endcase
    end
endmodule
