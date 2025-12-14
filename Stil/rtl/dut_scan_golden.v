`timescale 1ns/1ps

module dut_scan_golden #(
    parameter integer CHAIN_LEN = 8
)(
    input  wire se,     // scan enable (1 = scan shift mode)
    input  wire sclk,   // scan clock
    input  wire si,     // scan in
    output wire so      // scan out
);

    reg [CHAIN_LEN-1:0] q;

    // Shift on rising edge of sclk when scan enabled
    always @(posedge sclk) begin
        if (se) begin
            // shift toward MSB, MSB goes out as so
            q <= {q[CHAIN_LEN-2:0], si};
        end
    end

    // scan out = MSB of chain
    assign so = q[CHAIN_LEN-1];

endmodule
