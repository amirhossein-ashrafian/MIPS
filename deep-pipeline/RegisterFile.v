module RegisterFile(
    input wire clk,
    input wire reset,
    input wire [4:0] adr1, 
    input wire [4:0] adr2, 
    input wire [4:0] writeadr, 
    input wire [31:0] WriteData,
    input wire RegWrite, 
    output reg [31:0] ReadData1, 
    output reg [31:0] ReadData2
);
    reg [31:0] registers[31:0];
    
    // در صورت نیاز به مقداردهی اولیه می‌توانید از بلوک initial استفاده کنید.
    
    always @(*) begin
        ReadData1 = registers[adr1];
        ReadData2 = registers[adr2];
    end
    
    always @(negedge clk) begin
        if (RegWrite)
            registers[writeadr] <= WriteData;
    end
endmodule
