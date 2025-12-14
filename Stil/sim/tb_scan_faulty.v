`timescale 1ns/1ps

module tb_scan_faulty;

    localparam integer CHAIN_LEN = 8;

    // -------------------------
    // Scan signals
    // -------------------------
    reg  se;
    reg  sclk;
    reg  si;
    wire so;

    // -------------------------
    // Fault controls
    // -------------------------
    reg  fault_en;
    reg  [$clog2(CHAIN_LEN)-1:0] fault_idx;
    reg  fault_sa_value;

    integer FAULT_IDX;
    integer FAULT_SA;

    // -------------------------
    // DUT
    // -------------------------
    dut_scan_faulty #(.CHAIN_LEN(CHAIN_LEN)) dut (
        .se(se),
        .sclk(sclk),
        .si(si),
        .so(so),
        .fault_en(fault_en),
        .fault_idx(fault_idx),
        .fault_sa_value(fault_sa_value)
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
                $display("SO=%b", so);   // Python parses this
            end
            se = 1'b0;
            si = 1'b0;
            #10;
        end
    endtask

    // -------------------------
    // Fault configuration
    // -------------------------
    initial begin
        // Defaults = GOLDEN
        fault_en = 1'b0;
        fault_idx = '0;
        fault_sa_value = 1'b0;

        if ($value$plusargs("FAULT_IDX=%d", FAULT_IDX)) begin
            fault_idx = FAULT_IDX[$clog2(CHAIN_LEN)-1:0];
            fault_en  = 1'b1;   // ENABLE FAULT
        end

        if ($value$plusargs("FAULT_SA=%d", FAULT_SA)) begin
            fault_sa_value = FAULT_SA[0];
        end
    end

    // -------------------------
    // Test sequence
    // -------------------------
    initial begin
        se = 0;
        sclk = 0;
        si = 0;

        // Pattern 1: detect SA0
        scan_shift(8'b1111_1111);

        // Pattern 2: detect SA1
        scan_shift(8'b0000_0000);

        $finish;
    end

endmodule
