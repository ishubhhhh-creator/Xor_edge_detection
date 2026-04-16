`timescale 1ns/1ps

module xor_edge_detector #(
    parameter pixelbits = 24,
    parameter threshold_val = 8'd15   
)(
    input wire [pixelbits-1:0] p1,
    input wire [pixelbits-1:0] p2,
    input wire [1:0] mode,
    output reg edge_out
);
    wire [7:0] r1 = p1[23:16], g1 = p1[15:8], b1 = p1[7:0];
    wire [7:0] r2 = p2[23:16], g2 = p2[15:8], b2 = p2[7:0];

    wire [15:0] gray1_fixed = 77*r1 + 151*g1 + 28*b1;
    wire [15:0] gray2_fixed = 77*r2 + 151*g2 + 28*b2;
    wire [7:0] gray1 = gray1_fixed >> 8;
    wire [7:0] gray2 = gray2_fixed >> 8;

    wire [7:0] gray_diff = (gray1 > gray2) ? (gray1 - gray2) : (gray2 - gray1);

    wire gray_edge = (gray_diff > threshold_val);

    always @(*) begin
        case (mode)
            2'b00: edge_out = (|p1) ^ (|p2);      
            2'b01: edge_out = gray_edge;            
            2'b10: edge_out = |(p1 ^ p2);           
            default: edge_out = 0;
        endcase
    end
endmodule
