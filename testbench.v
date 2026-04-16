`timescale 1ns/1ps
module testbench;
    reg clk, reset;
    reg [1:0] mode;
    integer infile, c;
    reg [31:0] detected_w=0, detected_h=0, rowpix=0;
    reg indigit=0;
    reg [15:0] imgw, imgh;
    wire done;
    integer mode_arg;
    top_module DUT (.clk(clk), .reset(reset), .mode(mode), .imgwidth(imgw), .imgheight(imgh), .done(done));

    initial begin
        infile = $fopen("universal_8x8.mem", "r");
        if(!infile) begin 
            $display("ERROR: Input file missing."); 
            $finish; 
        end
        while (!$feof(infile)) begin
            c = $fgetc(infile);
            if (c >= "0" && c <= "9") begin 
                if (!indigit) begin 
                    rowpix = rowpix + 1; 
                    indigit = 1;
                end 
            end
            else if (c == "\n") begin 
                indigit = 0;
                if (rowpix > 0) begin 
                    if (detected_w == 0) detected_w = rowpix; 
                    detected_h = detected_h + 1; 
                    rowpix = 0;
                end 
            end
            else if (c == " " || c == "\t" || c == "\r") indigit = 0;
        end
        $fclose(infile);
        if (rowpix > 0) begin 
            if (detected_w == 0) detected_w = rowpix; 
            detected_h = detected_h + 1;
        end
        imgw = detected_w; 
        imgh = detected_h;
        $display("DETECTED: %0dx%0d", imgw, imgh);
    end

    initial begin 
        clk = 0; 
        forever #5 clk = ~clk; 
    end

    initial begin
        $dumpfile("edge_waveforms.vcd"); 
        $dumpvars(0, testbench);

        mode = 2'b10;    
        if ($value$plusargs("MODE=%d", mode_arg)) begin
            if (mode_arg < 0 || mode_arg > 2) begin
                $display("ERROR: Invalid MODE = %0d (valid range: 0-2)", mode_arg);
                $finish;
            end else begin
                mode = mode_arg[1:0];
            end
        end

        $display("--- Simulation running with MODE = %d ---", mode);

        reset = 1;
        #15 reset = 0; 
        wait(done); 
        #20; 
        $display("Finished."); 
        $finish;
    end
endmodule
