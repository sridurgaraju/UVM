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


