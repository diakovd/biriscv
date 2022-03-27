
//`timescale 1 ps / 1 ps

 
 module biriscv_sys(

	output TX,
	input  RX,
	output Clk14,
	input  Clk125M,
	input  Rst_n,
//	output [31:0] LED,

  inout [53:0]FIXED_IO_mio,
  inout FIXED_IO_ps_clk,
  inout FIXED_IO_ps_porb,
  inout FIXED_IO_ps_srstb

 );

 logic   Clk_50MHz;
 logic   Clk_14_7456MHz;
 logic   sys_rst_n;	 

 PLL1 PLL1_Inst(
  // Clock out ports
   .clk_out1(Clk_50MHz),
   .clk_out2(Clk_14_7456MHz),
   .reset(1'b0),
   .clk_in1(Clk125M)
  );
  
 biriscv_sys_atrix7 biriscv_sys_atrix7_inst(

	.TX(TX),
	.RX(RX),
	
//	output [31:0] LED,

    .Clk_50MHz(Clk_50MHz),
	.Clk_14_7456MHz(Clk_14_7456MHz),
    .sys_rst_n(Rst_n)	 
 );
assign Clk14 = Clk_14_7456MHz;

design_1_wrapper design_1_wrapper_inst
   (.Clk(),
        .Clk14M(),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .RSTn(Rst_n));

 endmodule