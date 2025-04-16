module CHI_Request_Node (
    input  logic        clk,    // Clock Signal
    input  logic        reset,  // Reset Signal
    output logic [31:0] addr,   // Address to read/write
    output logic [3:0]  command, // Command: 0001 = Read, 0010 = Write
    output logic [31:0] write_data, // Data to write
    input  logic [31:0] read_data,  // Data received from Home Node
    output logic        request_valid, // Indicates request is active
    input  logic        response_valid // Response received
);

    typedef enum logic [1:0] { IDLE, REQUEST, WAIT, DONE } state_t;
    state_t state;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state          <= IDLE;
            addr           <= 32'b0;
            command        <= 4'b0;
            request_valid  <= 1'b0;
            write_data     <= 32'b0;
        end else begin
            case (state)
                IDLE: begin
                    addr          <= 32'h1000; // Example memory address
                    command       <= 4'b0001;  // Read command
                    request_valid <= 1'b1;
                    state         <= REQUEST;
                end
                
                REQUEST: begin
                    if (response_valid) begin
                        request_valid <= 1'b0;
                        state         <= WAIT;
                    end
                end
                
                WAIT: begin
                    if (response_valid) begin
                        state <= DONE;
                    end
                end

                DONE: begin
                    // Data has been received, transaction complete
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
