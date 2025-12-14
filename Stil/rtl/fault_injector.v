`timescale 1ns/1ps

module fault_injector #(
    parameter integer WIDTH = 8
)(
    input  wire [WIDTH-1:0] in_vec,
    input  wire             fault_en,
    input  wire [$clog2(WIDTH)-1:0] fault_idx,
    input  wire             fault_sa_value,   // 0 = SA0, 1 = SA1
    output wire [WIDTH-1:0] out_vec
);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : G
            assign out_vec[i] = (fault_en && (fault_idx == i[$clog2(WIDTH)-1:0]))
                                ? fault_sa_value
                                : in_vec[i];
        end
    endgenerate
endmodule
