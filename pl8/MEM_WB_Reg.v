module MEM_WB_Register (
    input         clk,         
    input         reset,          
    // inputs from MEM stage
    input          RegWrite,   
    input          MemtoReg,   
    input  [31:0]  ALUResult, 
    input  [31:0]  ReadData, 
    input  [4:0]   Rd,   
    input ready,
    // outputs to WB stage
    output reg    RegWrite_out,    
    output reg    MemtoReg_out,  
    output reg [31:0] ALUResult_out, 
    output reg [31:0] ReadData_out,  
    output reg [4:0]  Rd_out 
);


always @(posedge clk or posedge reset) begin
    if (reset) 
    begin
        // Reset all outputs to default values
        RegWrite_out  <= 1'b0;
        MemtoReg_out  <= 1'b0;
        ALUResult_out <= 32'h0;
        ReadData_out  <= 32'h0;
        Rd_out  <= 5'h0;
    end
    else 
    begin
        // Pass MEM stage signals to WB stage
        RegWrite_out  <= RegWrite;
        MemtoReg_out  <= MemtoReg;
        ALUResult_out <= ALUResult;
        ReadData_out  <= ReadData;
        Rd_out  <= Rd;
    end
end

endmodule