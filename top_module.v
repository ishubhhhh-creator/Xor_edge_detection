`timescale 1ns/1ps

module top_module #(
    parameter pixelbits = 24,
    parameter inputfile = "universal_8x8.mem",
    parameter outputfile = "edge_output.mem"
)(
    input wire clk,
    input wire reset,
    input wire [1:0] mode,
    input wire [15:0] imgwidth,
    input wire [15:0] imgheight,
    output reg done
);
    reg [15:0] addr;

    wire [pixelbits-1:0] p0, pL, pR, pU, pD;
    wire [15:0] aL, aR, aU, aD;
    wire vL, vR, vU, vD; 
    wire raweL, raweR, raweU, raweD;
    wire eL, eR, eU, eD;

    wire [pixelbits-1:0] pUL, pUR, pDL, pDR;
    wire [15:0] aUL, aUR, aDL, aDR;
    wire vUL, vUR, vDL, vDR;
    wire raweUL, raweUR, raweDL, raweDR;
    wire eUL, eUR, eDL, eDR;
    wire finaledge;
    
    reg write_en, firstcycle; 
    
    // image wale ch parameter pass kite
    image_memory #(.pixelbits(pixelbits), .filename(inputfile)) img (.addr(addr), .pixelout(p0));

    shift_unit sL (.addr(addr), .offx(-1), .offy(0),  .imgw(imgwidth), .imgh(imgheight), .shifted_addr(aL), .valid(vL));
    shift_unit sR (.addr(addr), .offx(1),  .offy(0),  .imgw(imgwidth), .imgh(imgheight), .shifted_addr(aR), .valid(vR));
    shift_unit sU (.addr(addr), .offx(0),  .offy(-1), .imgw(imgwidth), .imgh(imgheight), .shifted_addr(aU), .valid(vU));
    shift_unit sD (.addr(addr), .offx(0),  .offy(1),  .imgw(imgwidth), .imgh(imgheight), .shifted_addr(aD), .valid(vD));

    diagonal_shifter diag_shifter (
        .addr(addr), .imgw(imgwidth), .imgh(imgheight),
        .aUL(aUL), .aUR(aUR), .aDL(aDL), .aDR(aDR),
        .vUL(vUL), .vUR(vUR), .vDL(vDL), .vDR(vDR)
    );
  
    assign pL = img.mem[aL];
    assign pR = img.mem[aR];
    assign pU = img.mem[aU];
    assign pD = img.mem[aD];

    assign pUL = img.mem[aUL];
    assign pUR = img.mem[aUR];
    assign pDL = img.mem[aDL];
    assign pDR = img.mem[aDR];


    xor_edge_detector #(.pixelbits(pixelbits)) xL (p0, pL, mode, raweL);
    xor_edge_detector #(.pixelbits(pixelbits)) xR (p0, pR, mode, raweR);
    xor_edge_detector #(.pixelbits(pixelbits)) xU (p0, pU, mode, raweU);
    xor_edge_detector #(.pixelbits(pixelbits)) xD (p0, pD, mode, raweD);

    diagonal_detector #(.pixelbits(pixelbits)) diag_detector (
        .p0(p0), .pUL(pUL), .pUR(pUR), .pDL(pDL), .pDR(pDR),
        .mode(mode),
        .raweUL(raweUL), .raweUR(raweUR), .raweDL(raweDL), .raweDR(raweDR)
    );

    assign eL = raweL & vL;
    assign eR = raweR & vR;
    assign eU = raweU & vU;
    assign eD = raweD & vD;
    assign eUL = raweUL & vUL;
    assign eUR = raweUR & vUR;
    assign eDL = raweDL & vDL;
    assign eDR = raweDR & vDR;

    // charo edge combine kite
    edge_combiner ec (eL, eR, eU, eD, eUL, eUR, eDL, eDR, finaledge);

    // output den lyyi
    output_memory #(.filename(outputfile)) out_mem (
        .clk(clk), .write_enable(write_en), .addr(addr), .edge_pixel(finaledge),
        .imgw(imgwidth), .imgh(imgheight), .save(done)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            addr <= 0;
            done <= 0; write_en <= 0; firstcycle <= 1;
        end else if (!done && imgwidth > 0) begin
            write_en <= 1;
            if (firstcycle) begin
                firstcycle <= 0;
            end else begin
                if (addr == (imgwidth * imgheight) - 1) begin
                    write_en <= 0;
                    done <= 1;
                end else begin
                    addr <= addr + 1;
                end
            end
        end
    end
endmodule