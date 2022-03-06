`include "../example_tb/fpga_sys/source/defines.sv"
`include "../example_tb/fpga_sys/source/bus_mux/ahb3lite_bus/ahb3lite_bus.sv" 
 // `include "defines.sv"

 module bus_mux(
	DatBus.Slave  data_DatBus,
	CtrBus.Slave  data_CtrBus,
	CtrBus.Master RAM_CtrBus,
	CtrBus.Master IO_CtrBus,
	CtrBus.Master UART0_CtrBus,
	ahb3lite_bus.master tm0_Bus,
	ahb3lite_bus.master tm1_Bus,
	 
	input Rst,
	input Clk 
 );

 logic sel_RAM; // data memory section  
 logic sel_IO;  
 logic sel_UART0;
 logic sel_Timer;
 logic sel_Timer1;
 logic req_del;

 assign data_CtrBus.rdata = (RAM_CtrBus.rvalid)? RAM_CtrBus.rdata :
							(IO_CtrBus.rvalid)?  IO_CtrBus.rdata  :
							(UART0_CtrBus.rvalid)?  UART0_CtrBus.rdata :  
							(tm0_Bus.HREADY)?  tm0_Bus.HRDATA : 
							(tm1_Bus.HREADY)? tm1_Bus.HRDATA : 32'd0; 
 
 assign data_CtrBus.rvalid = RAM_CtrBus.rvalid | IO_CtrBus.rvalid | UART0_CtrBus.rvalid | (req_del & tm0_Bus.HREADY) | (req_del & tm1_Bus.HREADY);
							 // (sel_RAM)? RAM_CtrBus.rvalid :
							 // (sel_IO)?  IO_CtrBus.rvalid  :
							 // (sel_UART0)?  UART0_CtrBus.rvalid :  
							 // (sel_Timer)?  tm0_Bus.HREADY : 
							 // (sel_Timer1)? tm1_Bus.HREADY : 1'd0; 

 assign data_CtrBus.gnt = 1; //RAM_CtrBus.gnt | IO_CtrBus.gnt | UART0_CtrBus.gnt |  !tm0_Bus.HRESP | !tm1_Bus.HRESP;
						  // (sel_RAM)? RAM_CtrBus.gnt :
						  // (sel_IO)?  IO_CtrBus.gnt  : 
 						  // (sel_UART0)?  UART0_CtrBus.gnt : 
 						  // (sel_Timer)?  !tm0_Bus.HRESP : 
 						  // (sel_Timer1)? !tm1_Bus.HRESP : 1'd0; 

 assign data_CtrBus.err = (sel_RAM)? RAM_CtrBus.err :
						  (sel_IO)?  IO_CtrBus.err  :
						  (sel_UART0)?  UART0_CtrBus.err : 
 						  (sel_Timer)?  tm0_Bus.HRESP  : 
 						  (sel_Timer1)? tm1_Bus.HRESP : 32'd0;
 
 assign RAM_CtrBus.we  = data_CtrBus.we  & sel_RAM;
 assign RAM_CtrBus.req = data_CtrBus.req & sel_RAM;
 
 always_ff @(posedge Clk or posedge Rst) begin
	if (Rst) req_del <= 'b0;
    else 	 req_del <= data_CtrBus.req;
 end
  
 assign IO_CtrBus.we  = data_CtrBus.we  & sel_IO;
 assign IO_CtrBus.req = data_CtrBus.req & sel_IO;
 
 assign UART0_CtrBus.we  = data_CtrBus.we  & (sel_UART0);
 assign UART0_CtrBus.req = data_CtrBus.req & (sel_UART0);

 assign tm0_Bus.HWRITE  = data_CtrBus.we;
 assign tm0_Bus.HTRANS = {data_CtrBus.req & (sel_Timer), 1'b0};
 assign tm0_Bus.HSEL   = sel_Timer;
 always_ff @(posedge Clk) tm0_Bus.HWDATA <= data_DatBus.wdata;
 assign tm0_Bus.HADDR  = data_DatBus.addr;

 assign tm1_Bus.HWRITE  = data_CtrBus.we;
 assign tm1_Bus.HTRANS = {data_CtrBus.req & (sel_Timer1), 1'b0};
 assign tm1_Bus.HSEL   = sel_Timer1;
 always_ff @(posedge Clk) tm1_Bus.HWDATA <= data_DatBus.wdata;
 assign tm1_Bus.HADDR  = data_DatBus.addr;
 
 always_comb begin
	// CPU address MUX
	if(data_DatBus.addr  >= (`addrBASE_Timer1)) begin 
		sel_IO  <= 0;
		sel_RAM <= 0;
		sel_UART0  <= 0;
		sel_Timer  <= 0;
		sel_Timer1 <= 1;
	end		
	else if(data_DatBus.addr  >= (`addrBASE_Timer)) begin 
		sel_IO  <= 0;
		sel_RAM <= 0;
		sel_UART0  <= 0;
		sel_Timer  <= 1;
		sel_Timer1 <= 0;
	end	
	else if(data_DatBus.addr  >= `addrBASE_UART0) begin 
		sel_IO  <= 0;
		sel_RAM <= 0;
		sel_UART0  <= 1;
		sel_Timer  <= 0;
		sel_Timer1 <= 0;
	end
	else if(data_DatBus.addr  >= `addrBASE_IOmodule) begin 
		sel_IO  <= 1;
		sel_RAM <= 0;
		sel_UART0  <= 0;
		sel_Timer  <= 0;
		sel_Timer1 <= 0;
	end	
	else if(data_DatBus.addr  >= `addrBASE_RAM) begin 
		sel_IO  <= 0;
		sel_RAM <= 1;
		sel_UART0  <= 0;
		sel_Timer  <= 0;
		sel_Timer1 <= 0;
	end	
	else begin
		sel_IO  <= 0;
		sel_RAM <= 1; //read rom from data request
		sel_UART0  <= 0;
		sel_Timer  <= 0;
		sel_Timer1 <= 0;
	end
 end
   
 endmodule