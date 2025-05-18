`timescale 1ns/1ps

module tb_top();
    logic valid_i;
    logic [15:0] data_1;
    logic [15:0] data_2;
    logic [16:0] data_out;
    logic valid_o;
    logic clk;
    logic rst_n;
  
  parameter clk_period=10;
  
  always #(clk_period/2) clk=~clk;
  
  five_stage_adder dut(
    .valid_i(valid_i),
    .data_1(data_1),
    .data_2(data_2),
    .data_out(data_out),
    .valid_o(valid_o),
    .clk(clk),
    .rst_n(rst_n)
  );
  
  
  initial begin
    $dumpfile("wave.vcd");
    $dumpvars;
    clk=1;rst_n=0;
    #clk_period rst_n=1;valid_i=1;data_1=16'h02;data_2=16'h03;
    #clk_period data_1=16'h04;data_2=16'h05;
    #clk_period data_1=16'h07;data_2=16'h08;
    repeat(10) begin
      #clk_period $finish;
    end
  end
  
endmodule
