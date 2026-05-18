module sync_fifo #(
    parameter DEPTH  = 8,
    parameter DWIDTH = 32
)(
    input                   clk,
    input                   rstn,

    input                   wr_en,
    input                   rd_en,

    input  [DWIDTH-1:0]     din,

    output reg [DWIDTH-1:0] dout,

    output                  full,
    output                  empty
);

    // ---------------------------------------------------------
    // Local parameter for pointer width
    // ---------------------------------------------------------
    localparam ADDR_W = $clog2(DEPTH);

    // ---------------------------------------------------------
    // FIFO memory
    // ---------------------------------------------------------
    reg [DWIDTH-1:0] fifo [0:DEPTH-1];

    // ---------------------------------------------------------
    // Read / Write pointers
    // ---------------------------------------------------------
    reg [ADDR_W-1:0] wptr;
    reg [ADDR_W-1:0] rptr;

    // ---------------------------------------------------------
    // FIFO occupancy counter
    // ---------------------------------------------------------
    reg [ADDR_W:0] count;

    // ---------------------------------------------------------
    // Status flags
    // ---------------------------------------------------------
    assign empty = (count == 0);
    assign full  = (count == DEPTH);

    // ---------------------------------------------------------
    // Main FIFO logic
    // ---------------------------------------------------------
    always @(posedge clk) begin
        if (!rstn) begin
            wptr  <= 0;
            rptr  <= 0;
            count <= 0;
            dout  <= 0;
        end
        else begin

            // -------------------------------------------------
            // WRITE ONLY
            // -------------------------------------------------
            if (wr_en && !full && !(rd_en && !empty)) begin
                fifo[wptr] <= din;

                if (wptr == DEPTH-1)
                    wptr <= 0;
                else
                    wptr <= wptr + 1;

                count <= count + 1;
            end

            // -------------------------------------------------
            // READ ONLY
            // -------------------------------------------------
            else if (rd_en && !empty && !(wr_en && !full)) begin
                dout <= fifo[rptr];

                if (rptr == DEPTH-1)
                    rptr <= 0;
                else
                    rptr <= rptr + 1;

                count <= count - 1;
            end

            // -------------------------------------------------
            // SIMULTANEOUS READ + WRITE
            // -------------------------------------------------
            else if (wr_en && !full && rd_en && !empty) begin

                // Write new data
                fifo[wptr] <= din;

                // Read old data
                dout <= fifo[rptr];

                // Advance write pointer
                if (wptr == DEPTH-1)
                    wptr <= 0;
                else
                    wptr <= wptr + 1;

                // Advance read pointer
                if (rptr == DEPTH-1)
                    rptr <= 0;
                else
                    rptr <= rptr + 1;

                // Count unchanged
                count <= count;
            end
        end
    end

endmodule
