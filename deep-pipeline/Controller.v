module Controller (
    input wire [5:0] opcode,     // Opcode از دستورالعمل
    output reg RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch,
    output reg [1:0] ALUOp       // سیگنال کنترلی برای ALU
);

    always @(*) begin
        case (opcode)
            6'b000000: begin // R-type
                RegDst   = 1;
                ALUSrc   = 0;
                MemtoReg = 0;
                RegWrite = 1;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 0;
                ALUOp    = 2'b10;
            end
            6'b100011: begin // lw
                RegDst   = 0;
                ALUSrc   = 1;
                MemtoReg = 1;
                RegWrite = 1;
                MemRead  = 1;
                MemWrite = 0;
                Branch   = 0;
                ALUOp    = 2'b00;
            end
            6'b101011: begin // sw
                RegDst   = 0; // X (بی‌اثر)
                ALUSrc   = 1;
                MemtoReg = 0; // X (بی‌اثر)
                RegWrite = 0;
                MemRead  = 0;
                MemWrite = 1;
                Branch   = 0;
                ALUOp    = 2'b00;
            end
            6'b000100: begin // beq
                RegDst   = 0; // X (بی‌اثر)
                ALUSrc   = 0;
                MemtoReg = 0; // X (بی‌اثر)
                RegWrite = 0;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 1;
                ALUOp    = 2'b01;
            end
            6'b001101: begin // ori
                RegDst   = 0;
                ALUSrc   = 1;
                MemtoReg = 0;
                RegWrite = 1;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 0;
                ALUOp    = 2'b11;  // کد جدید برای ORI
            end
            default: begin // دستورالعمل نامعتبر
                RegDst   = 0;
                ALUSrc   = 0;
                MemtoReg = 0;
                RegWrite = 0;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 0;
                ALUOp    = 2'b00;
            end
        endcase
    end
endmodule
