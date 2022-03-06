 `include "../peripherial/defines.sv"
 `include "../peripherial/uart_module/defUART.sv"
 
 `timescale 1 ps / 1 ps
   
module biriscv_sys_tb;

 logic   TX;
 logic   RX;
 
 logic      Clk;
 logic Clk_UART;

 logic rst;

 initial
 begin
	Clk = 0;
    forever Clk = #4000 ~Clk;
 end

 initial
 begin
	Clk_UART = 0;
    forever Clk_UART = #34000 ~Clk_UART;
 end

 initial begin
    // Reset
    rst = 1;
    repeat (5) @(posedge Clk);
    rst = 0;	
 end
 
 biriscv_sys_atrix7 biriscv_sys_atrix7_inst(

	.TX(TX),
	.RX(RX),

    .Clk_50MHz(Clk),
	.Clk_14_7456MHz(Clk_UART),
    .sys_rst_n(!rst)	 
 );

UART_emu   #(
	.BaudRate(`BR115200) //9600
 )
 UART_emu_inst(
	.TX(RX), //TX UART line
	.RX(TX) //RX UART line
 );
 

endmodule