`timescale 1ns/1ps

module dut_scan_faulty #(
    parameter integer CHAIN_LEN = 8
)(
    input  wire se,       // scan enable
    input  wire sclk,     // scan clock
    input  wire si,       // scan in
    output wire so,       // scan out

    // Fault controls (stuck-at on scan FF output bit)
    input  wire fault_en,
    input  wire [$clog2(CHAIN_LEN)-1:0] fault_idx,
    input  wire fault_sa_value          // 0=SA0, 1=SA1
);

    // -------------------------
    // Scan register chain
    // -------------------------
    reg [CHAIN_LEN-1:0] q;

    // -------------------------
    // Shift register (REAL state only)
    // -------------------------
    always @(posedge sclk) begin
        if (se) begin
            q <= { q[CHAIN_LEN-2:0], si };
        end
    end

    // -------------------------
    // Fault affects OBSERVATION only
    // -------------------------
    assign so = (fault_en && (fault_idx == (CHAIN_LEN-1)))
                ? fault_sa_value
                : q[CHAIN_LEN-1];

endmodule
