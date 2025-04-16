module CHI_Slave_Node (
    input  logic        clk,     
    input  logic        reset,   
    input  logic [31:0] addr,    
    input  logic [3:0]  command, 
    input  logic [31:0] write_data,
    output logic [31:0] read_data,
    input  logic        request_valid, 
    output logic        response_valid
);

    logic [31:0] memory [0:255]; // Simple memory array
    logic        busy;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            response_valid <= 1'b0;
            busy           <= 1'b0;
        end else begin
            if (request_valid && !busy) begin
                busy <= 1'b1;
                case (command)
                    4'b0001: begin // Read Command
                        read_data      <= memory[addr >> 2];
                        response_valid <= 1'b1;
                    end
                    4'b0010: begin // Write Command
                        memory[addr >> 2] <= write_data;
                        response_valid    <= 1'b1;
                    end
                endcase
                busy <= 1'b0;
            end else begin
                response_valid <= 1'b0;
            end
        end
    end
endmodule