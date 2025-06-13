module testbench;

    parameter N = 2;
    logic clk, rst;
    logic [N-1:0] read_req, write_req;
    logic [31:0] addr [N];
    logic [N-1:0] mem_read, mem_write;
    logic [1:0] state [N];

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // DUT instance
    top_system #(N) dut (
        .clk(clk),
        .rst(rst),
        .read_req(read_req),
        .write_req(write_req),
        .addr(addr),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .state(state)
    );

    // Stimulus
    initial begin
        rst = 1;
        read_req = 0;
        write_req = 0;
        addr[0] = 32'h0;
        addr[1] = 32'h0;
        #15 rst = 0;

        // Cache 0 issues read to addr 0x1000
        addr[0] = 32'h1000;
        read_req[0] = 1;
        #20 read_req[0] = 0;

        // Cache 1 issues write to addr 0x1000
        addr[1] = 32'h1000;
        write_req[1] = 1;
        #20 write_req[1] = 0;

        // Observe MESI state transitions
        #50 $finish;
    end
  
     initial begin
$dumpfile("dump.vcd");
$dumpvars;
end
  
function string state_to_str(input logic [1:0] state);
    case (state)
        2'b00: return "I";
        2'b01: return "S";
        2'b10: return "E";
        2'b11: return "M";
        default: return "U"; // undefined
    endcase
endfunction

initial begin
    $monitor("Time: %0t | Cache0=%s | Cache1=%s | MemRead0=%b | MemWrite1=%b",
        $time, state_to_str(state[0]), state_to_str(state[1]),
        mem_read[0], mem_write[1]);
end


endmodule
