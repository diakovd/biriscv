`define MTIMER_MTIME        32'h00
`define MTIMER_MTIME_LO     32'h00
`define MTIMER_MTIME_HI     32'h04
`define MTIMER_MTIMECMP     32'h08
`define MTIMER_MTIMECMP_LO  32'h08
`define MTIMER_MTIMECMP_HO  32'h0c


 module mtimer(
 
 	AXI4bus.Slave axiBus,
	
	output logic Int,
	input  Rst,
	input  Clk
 );

 parameter int addrBase = 0;

 logic [63:0]  mtime;
 logic [63:0]  mtimecmp;
 
 logic [31:0] addrH;
 logic [31:0] addrHreg;
 logic [31:0] addrH_rd;
 logic [31:0] addrHreg_rd;
 logic [31:0] wrdata;
 logic [31:0] addr;
 logic [31:0] addr_rd;
 logic [31:0] RDdata;
 logic rd, wr;
 
//Registers write/read
//Address write
 always @(posedge Clk) 
	if(axiBus.awvalid) addrHreg <= axiBus.awaddr;

 assign addrH    = (axiBus.awvalid)? axiBus.awaddr: addrHreg;
			
 assign addr = addrH - addrBase;
 assign wrdata = axiBus.wdata;

 assign wr = axiBus.wvalid;
 always @(posedge Clk) axiBus.wready <= wr;

//Address read
 always @(posedge Clk) 
	if(axiBus.arvalid) addrHreg_rd <= axiBus.araddr;

 assign addrH_rd    = (axiBus.arvalid)? axiBus.araddr: addrHreg_rd;

 assign addr_rd = addrH_rd - addrBase;
 always @(posedge Clk) rd <= axiBus.arvalid;
 assign axiBus.rvalid = rd;
 
 assign axiBus.rdata = RDdata; 
 
 
 //write registers
 always @(posedge Clk) begin
	if(Rst) begin
		mtime	 <= 0;
		mtimecmp <= 0;
	end
	else begin 
		if 		(wr & addr == `MTIMER_MTIME_HI)    mtime[63:32]  	<= wrdata;
		else if (wr & addr == `MTIMER_MTIME_LO)    mtime[31:0]   	<= wrdata;
		else mtime <= mtime + 1;
		
		if (wr & addr == `MTIMER_MTIMECMP_HO) mtimecmp[63:32]		<= wrdata;
		else if (wr & addr == `MTIMER_MTIMECMP_LO) mtimecmp[31:0] 	<= wrdata;

		if(mtimecmp > 0) begin
			if(mtime >= mtimecmp) 	Int <= 1'b1;
			else 					Int <= 1'b0;
		end
	end
  end
  
 //Read registers
 always_comb begin
 
 	if     (addr_rd == `MTIMER_MTIME_HI) 	RDdata <= mtime[63:32];	
 	else if(addr_rd == `MTIMER_MTIME_LO)  	RDdata <= mtime[31:0];	
	else if(addr_rd == `MTIMER_MTIMECMP_HO) RDdata <= mtimecmp[63:32];	
	else if(addr_rd == `MTIMER_MTIMECMP_LO) RDdata <= mtimecmp[31:0];	
	else RDdata <= 0;
 
 end
 
 endmodule