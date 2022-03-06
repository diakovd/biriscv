
//`timescale 1 ps / 1 ps

 
 module biriscv_sys(

	output TX,
	input  RX,
	
//	output [31:0] LED,

  inout [53:0]FIXED_IO_mio,
  inout FIXED_IO_ps_clk,
  inout FIXED_IO_ps_porb,
  inout FIXED_IO_ps_srstb

 );

 logic   Clk_50MHz;
 logic   Clk_14_7456MHz;
 logic   sys_rst_n;	 

 
 biriscv_sys_atrix7 biriscv_sys_atrix7_inst(

	.TX(TX),
	.RX(RX),
	
//	output [31:0] LED,

    .Clk_50MHz(Clk_50MHz),
	.Clk_14_7456MHz(Clk_14_7456MHz),
    .sys_rst_n(sys_rst_n)	 
 );

design_1_wrapper design_1_wrapper_inst
   (.CLK50(Clk_50MHz),
    .Clk14(Clk_14_7456MHz),
    .FIXED_IO_mio(FIXED_IO_mio),
    .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
    .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
    .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
    .RSTn(sys_rst_n));

 endmodule