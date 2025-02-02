module Controller (
    input wire [5:0] opcode,     // Opcode از دستورالعمل
    output reg RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch,ZeroExtend,
    output reg [1:0] ALUOp       // سیگنال کنترلی برای ALU
);

    always @(*) begin
        case (opcode)
            6'b000000: begin // R-type
                ZeroExtend = 1'b0; 
                RegDst   = 1;
                ALUSrc   = 0;
                MemToReg = 0;
                RegWrite = 1;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 0;
                ALUOp    = 2'b10;
            end
            6'b100011: begin // lw
                ZeroExtend = 1'b0;
                RegDst   = 0;
                ALUSrc   = 1;
                MemToReg = 1;
                RegWrite = 1;
                MemRead  = 1;
                MemWrite = 0;
                Branch   = 0;
                ALUOp    = 2'b00;
            end
            6'b101011: begin // sw
                ZeroExtend = 1'b0;
                RegDst   = 0; // X (بی‌اثر)
                ALUSrc   = 1;
                MemToReg = 0; // X (بی‌اثر)
                RegWrite = 0;
                MemRead  = 0;
                MemWrite = 1;
                Branch   = 0;
                ALUOp    = 2'b00;
            end
            6'b000100: begin // beq
                ZeroExtend = 1'b0;
                RegDst   = 0; // X (بی‌اثر)
                ALUSrc   = 0;
                MemToReg = 0; // X (بی‌اثر)
                RegWrite = 0;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 1;
                ALUOp    = 2'b01;
            end
            6'b001101: begin // ori
                ZeroExtend = 1'b1; 
                RegDst   = 0;
                ALUSrc   = 1;
                MemToReg = 0;
                RegWrite = 1;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 0;
                ALUOp    = 2'b11;  // کد جدید برای ORI
            end
            default: begin // دستورالعمل نامعتبر
                ZeroExtend = 1'b0;
                RegDst   = 0;
                ALUSrc   = 0;
                MemToReg = 0;
                RegWrite = 0;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 0;
                ALUOp    = 2'b00;
            end
        endcase
    end
endmodule
