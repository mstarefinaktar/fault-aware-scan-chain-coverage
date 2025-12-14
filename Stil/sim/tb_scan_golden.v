`timescale 1ns/1ps

module tb_scan_golden;

    localparam integer CHAIN_LEN = 8;

    // -------------------------
    // Scan signals
    // -------------------------
    reg  se;
    reg  sclk;
    reg  si;
    wire so;

    // -------------------------
    // GOLDEN DUT (no fault ports!)
    // -------------------------
    dut_scan_golden #(.CHAIN_LEN(CHAIN_LEN)) dut (
        .se(se),
        .sclk(sclk),
        .si(si),
        .so(so)
    );

    // -------------------------
    // Clock pulse
    // -------------------------
    task pulse_sclk;
        begin
            sclk = 1'b0; #5;
            sclk = 1'b1; #5;
            sclk = 1'b0; #5;
        end
    endtask

    // -------------------------
    // Scan shift task
    // -------------------------
    task scan_shift;
        input [CHAIN_LEN-1:0] vec;
        integer i;
        begin
            se = 1'b1;
            for (i = CHAIN_LEN-1; i >= 0; i = i - 1) begin
                si = vec[i];
                pulse_sclk();
                $display("SO=%b", so);   // must match faulty TB
            end
            se = 1'b0;
            si = 1'b0;
            #10;
        end
    endtask

    // -------------------------
    // Test sequence
    // -------------------------
    initial begin
        se   = 1'b0;
        sclk = 1'b0;
        si   = 1'b0;

        // Same patterns as faulty TB
        scan_shift(8'b1111_1111);
        scan_shift(8'b0000_0000);

        $finish;
    end

endmodule
