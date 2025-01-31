module ForwardingUnit (
    input wire [4:0] ID_EX_Rs, ID_EX_Rt, EX_MEM_Rd, MEM_WB_Rd,
    input wire ID_EX_RegWrite, EX_MEM_RegWrite, MEM_WB_RegWrite,
    output reg [1:0] ForwardA, ForwardB
);

    always @(*) begin
        // ForwardA
        if (ID_EX_RegWrite && (ID_EX_Rs != 0) && (ID_EX_Rs == EX_MEM_Rd)) 
            ForwardA = 2'b10; // Forward from EX/MEM
        else if (ID_EX_RegWrite && (ID_EX_Rs != 0) && (ID_EX_Rs == MEM_WB_Rd)) 
            ForwardA = 2'b01; // Forward from MEM/WB
        else 
            ForwardA = 2'b00; // No forwarding
        
        // ForwardB
        if (ID_EX_RegWrite && (ID_EX_Rt != 0) && (ID_EX_Rt == EX_MEM_Rd)) 
            ForwardB = 2'b10; // Forward from EX/MEM
        else if (ID_EX_RegWrite && (ID_EX_Rt != 0) && (ID_EX_Rt == MEM_WB_Rd)) 
            ForwardB = 2'b01; // Forward from MEM/WB
        else 
            ForwardB = 2'b00; // No forwarding
    end

endmodule
