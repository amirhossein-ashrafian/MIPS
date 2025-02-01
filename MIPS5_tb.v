`include "MIPS5.v"
module MIPS5_tb;

    reg clk;
    reg reset;
    
    // Instantiate the MIPS5 processor
    MIPS5 uut (
        .clk(clk),
        .reset(reset)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Simulation control
    initial begin
        reset = 1;
        #20;
        reset = 0;
        #1000; // Allow time for execution
        
        $display("ERROR: Memory[%0d] = %h", 0, uut.data_memory.memory[8]);
        // Check computed Fibonacci terms in data memory
        // $display("\nChecking Fibonacci sequence in data memory:");
        // check_term(2, 32'h00000001); // Fib[2] = 1
        // check_term(3, 32'h00000002); // Fib[3] = 2
        // check_term(4, 32'h00000003); // Fib[4] = 3
        // check_term(5, 32'h00000005); // Fib[5] = 5
        // check_term(6, 32'h00000008); // Fib[6] = 8
        // check_term(7, 32'h0000000D); // Fib[7] = 13
        // check_term(8, 32'h00000015); // Fib[8] = 21
        // check_term(9, 32'h00000022); // Fib[9] = 34
        // check_term(10, 32'h00000037); // Fib[10] = 55
        // check_term(11, 32'h00000059); // Fib[11] = 89
        
        $display("\nTest completed.");
        $finish;
    end
    
    // Helper task to check memory terms
    task check_term;
        input integer index;
        input [31:0] expected;
        begin
            if (uut.data_memory.memory[index] !== expected) begin
                $display("ERROR: Memory[%0d] = %h, Expected = %h", 
                    index*4, uut.data_memory.memory[index], expected);
            end else begin
                $display("SUCCESS: Memory[%0d] = %h", 
                    index*4, expected);
            end
        end
    endtask

endmodule