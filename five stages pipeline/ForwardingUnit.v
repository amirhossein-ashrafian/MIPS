module ForwardingUnit (
    input wire [4:0] ID_EX_Rs, ID_EX_Rt, EX_MEM_Rd, MEM_WB_Rd,
    input wire ID_EX_RegWrite, EX_MEM_RegWrite, MEM_WB_RegWrite,
    output reg [1:0] ForwardA, ForwardB
);

    always @(*) begin
        // برای ForwardA:
if (EX_MEM_RegWrite && (ID_EX_Rs != 0) && (ID_EX_Rs == EX_MEM_Rd))
    ForwardA = 2'b10;
else if (MEM_WB_RegWrite && (ID_EX_Rs != 0) && (ID_EX_Rs == MEM_WB_Rd))
    ForwardA = 2'b01;
else 
    ForwardA = 2'b00;

// برای ForwardB:
if (EX_MEM_RegWrite && (ID_EX_Rt != 0) && (ID_EX_Rt == EX_MEM_Rd))
    ForwardB = 2'b10;
else if (MEM_WB_RegWrite && (ID_EX_Rt != 0) && (ID_EX_Rt == MEM_WB_Rd))
    ForwardB = 2'b01;
else 
    ForwardB = 2'b00;

    end

endmodule

