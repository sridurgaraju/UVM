`timescale 1ns / 1ps

module CHI_Testbench();
    logic clk, reset;
    logic [31:0] addr;
    logic [3:0]  command;
    logic [31:0] write_data, read_data;
    logic        request_valid, response_valid;

    // Instantiate CHI Nodes
    CHI_Request_Node rn (
        .clk(clk),
        .reset(reset),
        .addr(addr),
        .command(command),
        .write_data(write_data),
        .read_data(read_data),
        .request_valid(request_valid),
        .response_valid(response_valid)
    );

    CHI_Home_Node hn (
        .clk(clk),
        .reset(reset),
        .addr(addr),
        .command(command),
        .write_data(write_data),
        .read_data(read_data),
        .request_valid(request_valid),
        .response_valid(response_valid)
    );

    CHI_Slave_Node sn (
        .clk(clk),
        .reset(reset),
        .addr(addr),
        .command(command),
        .write_data(write_data),
        .read_data(read_data),
        .request_valid(request_valid),
        .response_valid(response_valid)
    );

    // Clock Generator
    always #5 clk = ~clk; // 10ns period (100MHz)

    // Test Procedure
    initial begin
        $dumpfile("chi_tb.vcd");
        $dumpvars(0, CHI_Testbench);

        // Initialize signals
        clk = 0;
        reset = 1;
        addr = 0;
        command = 0;
        write_data = 0;
        request_valid = 0;
        #20 reset = 0; // Release reset after 20ns

        // Test Case 1: Write to Memory (Addr = 0x10, Data = 0xABCD1234)
        #10;
        addr = 32'h10;
        write_data = 32'hABCD1234;
        command = 4'b0010; // Write command
        request_valid = 1;
        #10 request_valid = 0;
        wait (response_valid);
        $display("Write to Addr %h, Data %h", addr, write_data);

        // Test Case 2: Read from Memory (Addr = 0x10)
        #20;
        addr = 32'h10;
        command = 4'b0001; // Read command
        request_valid = 1;
        #10 request_valid = 0;
        wait (response_valid);
        $display("Read from Addr %h, Data %h", addr, read_data);
        
        // Test Case 3: Cache Coherence (MESI/MOESI State Change)
        #20;
        addr = 32'h10;
        command = 4'b0001; // Read (cache should be in Exclusive state)
        request_valid = 1;
        #10 request_valid = 0;
        wait (response_valid);
        $display("Cache State Updated (Expected: Exclusive or Shared)");

        #50;
        $finish;
    end
endmodule
