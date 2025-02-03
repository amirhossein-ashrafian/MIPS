module ForwardingUnit (
    input wire [4:0] ID_EX_Rs, ID_EX_Rt, EX_MEM_Rd, MEM_WB_Rd,
    input wire ID_EX_RegWrite, EX_MEM_RegWrite, MEM_WB_RegWrite,
    input wire [4:0] EX_MR_Rd, PR_ID_Rs, PR_ID_Rt,
    input EX_MR_MemRead,
    output reg [1:0] ForwardA, ForwardB,
    // new inputs
    output reg Forward_MR_to_EX_1, Forward_MR_to_EX_2, Forward_MR_to_ID_1, Forward_MR_to_ID_2
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

    // Forward from MR -> EX
    Forward_MR_to_EX_1 = 0;
    Forward_MR_to_EX_2 = 0;
    Forward_MR_to_ID_1 = 0;
    Forward_MR_to_ID_2 = 0;

    if(EX_MR_MemRead && (EX_MR_Rd != 0) && (ID_EX_Rs == EX_MR_Rd)) Forward_MR_to_EX_1 = 1;
    if(EX_MR_MemRead && (EX_MR_Rd != 0) && (ID_EX_Rt == EX_MR_Rd)) Forward_MR_to_EX_2 = 1;
    if(EX_MR_MemRead && (EX_MR_Rd != 0) && (PR_ID_Rs == EX_MR_Rd)) Forward_MR_to_ID_1 = 1;
    if(EX_MR_MemRead && (EX_MR_Rd != 0) && (PR_ID_Rt == EX_MR_Rd)) Forward_MR_to_ID_2 = 1;

    end

endmodule
