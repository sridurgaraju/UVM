module CHI_Home_Node (
    input  logic        clk,     
    input  logic        reset,   
    input  logic [31:0] addr,    
    input  logic [3:0]  command, 
    input  logic [31:0] write_data,
    output logic [31:0] read_data,
    input  logic        request_valid, 
    output logic        response_valid
);

    typedef enum logic [2:0] { INVALID, SHARED, EXCLUSIVE, MODIFIED, OWNED } mesi_state_t;
    mesi_state_t cache_state;
    
    logic [31:0] memory [0:255];
    logic busy;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            response_valid <= 1'b0;
            cache_state    <= INVALID;
            busy           <= 1'b0;
        end else begin
            if (request_valid && !busy) begin
                busy <= 1'b1;
                case (command)
                    4'b0001: begin // Read Command
                        if (cache_state == MODIFIED || cache_state == EXCLUSIVE) begin
                            read_data      <= memory[addr >> 2];
                            cache_state    <= SHARED; // Change state to SHARED
                        end else begin
                            read_data      <= memory[addr >> 2];
                            cache_state    <= EXCLUSIVE; // Change state to EXCLUSIVE
                        end
                        response_valid <= 1'b1;
                    end
                    4'b0010: begin // Write Command
                        memory[addr >> 2] <= write_data;
                        cache_state        <= MODIFIED; // Data is now modified
                        response_valid     <= 1'b1;
                    end
                endcase
                busy <= 1'b0;
            end else begin
                response_valid <= 1'b0;
            end
        end
    end
endmodule
