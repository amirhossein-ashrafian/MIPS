module HazardDetectionUnit(
    input ID_EX_MemRead,
    input [4:0] ID_EX_Rt,
    input [4:0] IF_ID_Rs,
    input [4:0] IF_ID_Rt,
    output reg PC_stall,
    output reg IF_ID_stall,
    output reg ControlMux
);

always @(*) begin
    if (ID_EX_MemRead && 
        ((IF_ID_Rs == ID_EX_Rt ) || 
         (IF_ID_Rt == ID_EX_Rt ))) begin
        // Stall the pipeline
        PC_stall     = 1'b1;
        IF_ID_stall   = 1'b1;
        ControlMux  = 1'b1; // Insert bubble
    end else begin
        // No stall
        PC_stall     = 1'b0;
        IF_ID_stall   = 1'b0;
        ControlMux  = 1'b0; // Normal operation
    end
end

endmodule