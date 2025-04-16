module CHI_Top (
    input logic clk, 
    input logic reset
);
    logic [31:0] addr;
    logic [3:0]  command;
    logic [31:0] write_data, read_data;
    logic        request_valid, response_valid;

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

endmodule


interface CHI_Interface (input logic clk, reset);
  // Request Channel Signals (RN -> HN/SN)
  logic req_valid;
  logic req_ready;
  logic [31:0] req_addr;
  logic [2:0] req_type; // Read, Write, Cache maintenance, etc.
  logic [127:0] req_data;

  // Snoop Channel Signals (HN -> RN/SN)
  logic snoop_valid;
  logic snoop_ready;
  logic [31:0] snoop_addr;
  logic [2:0] snoop_type; // Invalidate, Shared, Exclusive, etc.

  // Response Channel Signals (HN/SN -> RN)
  logic resp_valid;
  logic resp_ready;
  logic [127:0] resp_data;
  logic [2:0] resp_status; // OK, Retry, Fail, etc.

  // Handshake Signals
  logic handshake_req;
  logic handshake_ack;

  // Clocking Blocks for Testbench Synchronization
  clocking cb_driver @(posedge clk);
    output req_valid, req_addr, req_type, req_data;
    input req_ready;
    output snoop_ready;
    input snoop_valid, snoop_addr, snoop_type;
  endclocking

  clocking cb_monitor @(posedge clk);
    input req_valid, req_addr, req_type, req_data, req_ready;
    input snoop_valid, snoop_addr, snoop_type, snoop_ready;
    input resp_valid, resp_ready, resp_data, resp_status;
  endclocking

  modport Master (input clk, reset, output req_valid, req_addr, req_type, req_data, input req_ready);
  modport Slave (input clk, reset, input req_valid, req_addr, req_type, req_data, output req_ready);
  modport Monitor (input clk, reset, input req_valid, req_addr, req_type, req_data, input snoop_valid, snoop_addr, snoop_type, input resp_valid, resp_data, resp_status);

endinterface
