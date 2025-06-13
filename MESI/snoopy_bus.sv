module snoopy_bus #(
    parameter N = 2  // Number of cache controllers
)(
    input  logic clk,
    input  logic rst,

    // Request inputs from each cache
    input  logic [N-1:0] req_read,
    input  logic [N-1:0] req_write,
    input  logic [31:0] addr     [N],
    
    // Snoop signals to each cache
    output logic [N-1:0] snoop_read,
    output logic [N-1:0] snoop_read_excl,
    output logic [N-1:0] snoop_invalidate
);

    integer i, j;

    always_comb begin
        // Default all snoop signals to 0
        snoop_read        = '0;
        snoop_read_excl   = '0;
        snoop_invalidate  = '0;

        // For every cache i, check others j
        for (i = 0; i < N; i++) begin
            for (j = 0; j < N; j++) begin
                if (i != j && addr[i] == addr[j]) begin
                    if (req_read[i])
                        snoop_read[j] = 1;
                    if (req_write[i]) begin
                        snoop_read_excl[j] = 1;
                        snoop_invalidate[j] = 1;
                    end
                end
            end
        end
    end

    // Debug logging on clock edge
    always_ff @(posedge clk) begin
        if (!rst) begin
            $display("SNOOPY_BUS: Time=%0t", $time);
            for (int k = 0; k < N; k++) begin
                $display("  Cache%0d -> snoop_read=%b, snoop_read_excl=%b, snoop_invalidate=%b | addr=0x%08h | req_read=%b req_write=%b",
                         k, snoop_read[k], snoop_read_excl[k], snoop_invalidate[k], addr[k], req_read[k], req_write[k]);
            end
        end
    end

endmodule
