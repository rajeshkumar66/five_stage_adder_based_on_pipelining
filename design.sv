module five_stage_adder(
	input valid_i,
    input [15:0] data_1,
    input [15:0] data_2,
    output [16:0] data_out,
    output valid_o,
    input clk,
    input rst_n
);
  
  reg [11:0] data1_1d_r,data2_1d_r;
  reg [7:0] data1_2d_r,data2_2d_r;
  reg [3:0] data1_3d_r,data2_3d_r;
  reg [15:0] data_1_i,data_2_i;
  reg valid_i_r,valid_i_1d_r,valid_i_2d_r,valid_i_3d_r,valid_o_r;
  reg [4:0] sum_lsb_s;
  reg [8:0] sum_lsb_1r; 
  reg [12:0] sum_lsb_2r;
  reg [16:0] sum_lsb_3r;
  reg [16:0] out_r;
  
  always @(posedge clk or negedge rst_n) begin
    
    if(!rst_n) begin
      data_1_i<=0;
      data_2_i<=0;
      valid_i_r<=0;
      sum_lsb_s<=0;
    end
    
    else begin
      
      if(valid_i) begin
        data_1_i<=data_1;
        data_2_i<=data_2;
      end
      
      valid_i_r<=valid_i;
      
    end
  end
    
  always @(data_1_i or data_2_i) begin
    sum_lsb_s={1'b0,data_1_i[3:0]}+{1'b0,data_2_i[3:0]};
  end
  
  always @(posedge clk or negedge rst_n) begin
    
    if(!rst_n) begin
      valid_i_1d_r<=0;
      data1_1d_r<=0;
      data2_1d_r<=0;
      sum_lsb_1r<=0;
    end
    
    else begin
      
      if(valid_i_r) begin
        data1_1d_r<=data_1_i[15:4];
        data2_1d_r<=data_2_i[15:4];
        sum_lsb_1r[4:0]<=sum_lsb_s;
      end
      valid_i_1d_r<=valid_i_r;
    end
    
  end
  
  always @(data1_1d_r or data2_1d_r) begin
    sum_lsb_1r={{1'b0,data1_1d_r}+{1'b0,data2_1d_r}+{sum_lsb_1r[4]},sum_lsb_1r[3:0]};
  end
  
  always @(posedge clk or negedge rst_n) begin
    
    if(!rst_n) begin
      valid_i_2d_r<=0;
      data1_2d_r<=0;
      data2_2d_r<=0;
      sum_lsb_2r<=0;
    end
    
    else begin
      
      if(valid_i_1d_r) begin
        data1_2d_r<=data1_1d_r[11:4];
        data2_2d_r<=data2_1d_r[11:4];
        sum_lsb_2r[8:0]<=sum_lsb_1r;
      end
      
      valid_i_2d_r<=valid_i_1d_r;
      
    end
    
  end
  
  always @(data1_2d_r or data2_2d_r) begin
    sum_lsb_2r={{1'b0,data1_2d_r}+{1'b0,data1_2d_r}+{sum_lsb_2r[8]},sum_lsb_2r[7:0]};
  end
  
  always @(posedge clk or negedge rst_n) begin
    
    if(!rst_n) begin
      valid_i_3d_r<=0;
      data1_3d_r<=0;
      data2_3d_r<=0;
      sum_lsb_3r<=0;
    end
    
    else begin
      
      if(valid_i_1d_r) begin
        data1_3d_r<=data1_2d_r[7:4];
        data2_3d_r<=data2_2d_r[7:4];
        sum_lsb_3r[12:0]<=sum_lsb_2r;
      end
      
      valid_i_3d_r<=valid_i_2d_r;
      
    end
    
  end
  
  always @(data1_3d_r or data2_3d_r) begin
    sum_lsb_3r={1'b0,data1_3d_r}+{1'b0,data1_3d_r}+{sum_lsb_3r[12],sum_lsb_3r[11:0]};
  end
  
  always @(posedge clk or negedge rst_n) begin
    
    if(!rst_n) begin
      out_r<=0;
      valid_o_r<=0;
    end
    
    else begin
      
      if(valid_i_3d_r) begin
        out_r<=sum_lsb_3r;
        valid_o_r<=1;
      end
      
      else begin
        out_r<=0;
        valid_o_r<=0;
      end
      
    end
    
  end
  
  assign vaild_o=valid_o_r;
  assign data_out=out_r;
  
endmodule
