
//`timescale 1 ps / 1 ps

`define riscv_tcm_top
`include "../src/peripherial/defines.sv"
 
 module biriscv_sys_atrix7(

	output TX,
	input  RX,
	
//	output [31:0] LED,

    input   Clk_50MHz,
	input   Clk_14_7456MHz,
	
    input   sys_rst_n	 
 );
 
`ifdef Sim
	localparam VENDOR = "Simulation"; //optional "IntelFPGA"
`else
	localparam VENDOR = "Xilinx"; //optional "IntelFPGA"
`endif  
  
 logic      Clk;
 logic Clk_UART;

`ifdef Sim

logic rst;

initial
begin
	Clk = 0;
    forever Clk = #12 ~Clk;
end

initial
begin
	Clk_UART = 0;
    forever Clk_UART = #34 ~Clk_UART;
end


initial begin
    // Reset
    rst = 1;
    repeat (5) @(posedge Clk);
    rst = 0;	
end

`else
 // PLL PLL_inst
 // (
  // // Clock out ports
  // .clk_out1(Clk),
  // .clk_out2(Clk_UART),
  // .reset(1'b0),
  // .clk_in1(Clk_33_333MHz)
  // );
  assign Clk 	  = Clk_50MHz;
  assign Clk_UART = Clk_14_7456MHz;
  
  assign rst = !sys_rst_n;
`endif

`ifdef riscv_tcm_top

    // Inputs
    logic           clk_i;
    logic           rst_i;
    logic           rst_cpu_i;
    logic           axi_i_awready_i;
    logic           axi_i_wready_i;
    logic           axi_i_bvalid_i;
    logic  [  1:0]  axi_i_bresp_i;
    logic           axi_i_arready_i;
    logic           axi_i_rvalid_i;
    logic  [ 31:0]  axi_i_rdata_i;
    logic  [  1:0]  axi_i_rresp_i;
    logic           axi_t_awvalid_i;
    logic  [ 31:0]  axi_t_awaddr_i;
    logic  [  3:0]  axi_t_awid_i;
    logic  [  7:0]  axi_t_awlen_i;
    logic  [  1:0]  axi_t_awburst_i;
    logic           axi_t_wvalid_i;
    logic  [ 31:0]  axi_t_wdata_i;
    logic  [  3:0]  axi_t_wstrb_i;
    logic           axi_t_wlast_i;
    logic           axi_t_bready_i;
    logic           axi_t_arvalid_i;
    logic  [ 31:0]  axi_t_araddr_i;
    logic  [  3:0]  axi_t_arid_i;
    logic  [  7:0]  axi_t_arlen_i;
    logic  [  1:0]  axi_t_arburst_i;
    logic           axi_t_rready_i;
    logic  [ 31:0]  intr_i;

    // Outputs
    logic          axi_i_awvalid_o;
    logic [ 31:0]  axi_i_awaddr_o;
    logic          axi_i_wvalid_o;
    logic [ 31:0]  axi_i_wdata_o;
    logic [  3:0]  axi_i_wstrb_o;
    logic          axi_i_bready_o;
    logic          axi_i_arvalid_o;
    logic [ 31:0]  axi_i_araddr_o;
    logic          axi_i_rready_o;
    logic          axi_t_awready_o;
    logic          axi_t_wready_o;
    logic          axi_t_bvalid_o;
    logic [  1:0]  axi_t_bresp_o;
    logic [  3:0]  axi_t_bid_o;
    logic          axi_t_arready_o;
    logic          axi_t_rvalid_o;
    logic [ 31:0]  axi_t_rdata_o;
    logic [  1:0]  axi_t_rresp_o;
    logic [  3:0]  axi_t_rid_o;
    logic          axi_t_rlast_o;
	
 logic 		  irq_external = 0;
 logic [15:0] irq_fast = 0;
 logic Int_Timer;
 logic Int_Timer1;
 logic Int_UART;

	AXI4bus #(.dw (32),	.aw (32), .sw (4))	axiBus_UART();
	AXI4bus #(.dw (32),	.aw (32), .sw (4))	axiBus_TM();
	AXI4bus #(.dw (32),	.aw (32), .sw (4))	axiBus_TM1();
	
riscv_tcm_top
#(
    .BOOT_VECTOR      (32'h00000000),
    .CORE_ID          (0),
    .TCM_MEM_BASE     (32'h00000000),
	.VENDOR			  (VENDOR),
	.TCM_MEM_DEPTH    (16), 
    .SUPPORT_BRANCH_PREDICTION (0),
    .SUPPORT_MULDIV   (0),
    .SUPPORT_SUPER    (0),
    .SUPPORT_MMU      (0),
    .SUPPORT_DUAL_ISSUE  (0),
    .SUPPORT_LOAD_BYPASS (0),
    .SUPPORT_MUL_BYPASS  (0),
    .SUPPORT_REGFILE_XILINX (0),
    .EXTRA_DECODE_STAGE  (0),
    .MEM_CACHE_ADDR_MIN  (32'h80000000),
    .MEM_CACHE_ADDR_MAX  (32'h8fffffff),
    .NUM_BTB_ENTRIES     (32),
    .NUM_BTB_ENTRIES_W   (5),
    .NUM_BHT_ENTRIES     (512),
    .NUM_BHT_ENTRIES_W   (9),
    .RAS_ENABLE          (1),
    .GSHARE_ENABLE       (0),
    .BHT_ENABLE          (1),
    .NUM_RAS_ENTRIES     (8),
    .NUM_RAS_ENTRIES_W   (3)
)
riscv_tcm_top_inst
(
    // Inputs
    .clk_i(Clk),
    .rst_i(rst),
    .rst_cpu_i(rst),

	//instr/data memory interface
    .axi_t_awvalid_i(axi_t_awvalid_i),
    .axi_t_awaddr_i(axi_t_awaddr_i),
    .axi_t_awid_i(axi_t_awid_i),
    .axi_t_awlen_i(axi_t_awlen_i),
    .axi_t_awburst_i(axi_t_awburst_i),
    .axi_t_wvalid_i(axi_t_wvalid_i),
    .axi_t_wdata_i(axi_t_wdata_i),
    .axi_t_wstrb_i(axi_t_wstrb_i),
    .axi_t_wlast_i(axi_t_wlast_i),
    .axi_t_bready_i(axi_t_bready_i),
    .axi_t_arvalid_i(axi_t_arvalid_i),
    .axi_t_araddr_i(axi_t_araddr_i),
    .axi_t_arid_i(axi_t_arid_i),
    .axi_t_arlen_i(axi_t_arlen_i),
    .axi_t_arburst_i(axi_t_arburst_i),
    .axi_t_rready_i(axi_t_rready_i),
    .axi_t_awready_o(axi_t_awready_o),
    .axi_t_wready_o(axi_t_wready_o),
    .axi_t_bvalid_o(axi_t_bvalid_o),
    .axi_t_bresp_o(axi_t_bresp_o),
    .axi_t_bid_o(axi_t_bid_o),
    .axi_t_arready_o(axi_t_arready_o),
    .axi_t_rvalid_o(axi_t_rvalid_o),
    .axi_t_rdata_o(axi_t_rdata_o),
    .axi_t_rresp_o(axi_t_rresp_o),
    .axi_t_rid_o(axi_t_rid_o),
    .axi_t_rlast_o(axi_t_rlast_o),

	//
	.axiBus_UART(axiBus_UART.Master),
	.axiBus_TM(axiBus_TM.Master),
	.axiBus_TM1(axiBus_TM1.Master),
	
    // .axi_i_awvalid_o(AXI4s.awvalid),
    // .axi_i_awready_i(AXI4s.awready),
    // .axi_i_awaddr_o(AXI4s.awaddr),
		
    // .axi_i_wvalid_o(AXI4s.wvalid),
    // .axi_i_wready_i(AXI4s.wready),    
	// .axi_i_wdata_o(AXI4s.wdata),
    // .axi_i_wstrb_o(AXI4s.wstrb),

    // .axi_i_bvalid_i(AXI4s.bvalid),
    // .axi_i_bready_o(AXI4s.bready),	
    // .axi_i_bresp_i(AXI4s.bresp),

    // .axi_i_arvalid_o(AXI4s.arvalid),
    // .axi_i_arready_i(AXI4s.arready),	
    // .axi_i_araddr_o(AXI4s.araddr),
	
    // .axi_i_rvalid_i(AXI4s.rvalid),	
    // .axi_i_rready_o(AXI4s.rready),
    // .axi_i_rdata_i(AXI4s.rdata),
    // .axi_i_rresp_i(AXI4s.rresp),
	
    .intr_i({irq_fast, 4'b0, irq_external, 3'b0, Int_Timer, 3'b0, Int_UART, 3'b0})
);


	
UART #(
		.VENDOR(VENDOR),
		.addrBase(`addrBASE_UART0)
		)
UART_inst(
 
	.axiBus(axiBus_UART.Slave),
 
	.TX(TX),
	.RX(RX),

	.Int(Int_UART),
	.Rst(rst),
	.Clk(Clk),
	.Clk_14MHz(Clk_UART) 
 );	
	
 Timer #(
			.TM_SIZE(32),    		   
			.PWM_SIZE(1), 		     
			.BASE(`addrBASE_Timer),
			.HADDR_SIZE(32),     
			.HDATA_SIZE(32)      
		) 
 Timer_inst (
	.axiBus(axiBus_TM.Slave),

	.Evnt0(),
	.Evnt1(),
	.Evnt2(),
	.PWM(),
	
	.Int(Int_Timer),
	.Rst(rst),
	.Clk(Clk)
 );

 Timer #(
			.TM_SIZE(32),    		   
			.PWM_SIZE(1), 		     
			.BASE(`addrBASE_Timer1),
			.HADDR_SIZE(32),     
			.HDATA_SIZE(32)      
		) 
 Timer1_inst (
	.axiBus(axiBus_TM1.Slave),

	.Evnt0(),
	.Evnt1(),
	.Evnt2(),
	.PWM(),
	
	.Int(Int_Timer1),
	.Rst(rst),
	.Clk(Clk)
 );

wire [7 : 0] probe0;

`ifndef Sim  
/*
ila_1 ila_1_inst(
    .clk(Clk_UART),
    .probe0(probe0)
);

 assign probe0[0] = TX; 
 assign probe0[1] = RX; 
 assign probe0[2] = Int_Timer; 
 assign probe0[3] = Int_Timer1; 
 assign probe0[4] = 0; 
 assign probe0[5] = 0; 
 assign probe0[6] = 0; 
 assign probe0[7] = 0; 
 */
`endif

`else

wire          mem_i_rd_w;
wire          mem_i_flush_w;
wire          mem_i_invalidate_w;
wire [ 31:0]  mem_i_pc_w;
wire [ 31:0]  mem_d_addr_w;
wire [ 31:0]  mem_d_data_wr_w;
wire          mem_d_rd_w;
wire [  3:0]  mem_d_wr_w;
wire          mem_d_cacheable_w;
wire [ 10:0]  mem_d_req_tag_w;
wire          mem_d_invalidate_w;
wire          mem_d_writeback_w;
wire          mem_d_flush_w;
wire          mem_i_accept_w;
wire          mem_i_valid_w;
wire          mem_i_error_w;
wire [ 63:0]  mem_i_inst_w;
wire [ 31:0]  mem_d_data_rd_w;
wire          mem_d_accept_w;
wire          mem_d_ack_w;
wire          mem_d_error_w;
wire [ 10:0]  mem_d_resp_tag_w;

wire [31 : 0] probe0;
wire [31 : 0] probe1;
wire [31 : 0] probe2;
wire [31 : 0] probe3;
wire [63 : 0] probe4;
wire [10 : 0] probe5;
wire [10 : 0] probe6;
wire [3 : 0] probe7;
wire [13 : 0] probe8;

riscv_core
u_dut
//-----------------------------------------------------------------
// Ports
//-----------------------------------------------------------------
(
    // Inputs
     .clk_i(Clk)
    ,.rst_i(!sys_rst_n)
    ,.mem_d_data_rd_i(mem_d_data_rd_w)
    ,.mem_d_accept_i(mem_d_accept_w)
    ,.mem_d_ack_i(mem_d_ack_w)
    ,.mem_d_error_i(mem_d_error_w)
    ,.mem_d_resp_tag_i(mem_d_resp_tag_w)
    ,.mem_i_accept_i(mem_i_accept_w)
    ,.mem_i_valid_i(mem_i_valid_w)
    ,.mem_i_error_i(mem_i_error_w)
    ,.mem_i_inst_i(mem_i_inst_w)
    ,.intr_i(1'b0)
    ,.reset_vector_i(32'h80000000)
    ,.cpu_id_i('b0)

    // Outputs
    ,.mem_d_addr_o(mem_d_addr_w)
    ,.mem_d_data_wr_o(mem_d_data_wr_w)
    ,.mem_d_rd_o(mem_d_rd_w)
    ,.mem_d_wr_o(mem_d_wr_w)
    ,.mem_d_cacheable_o(mem_d_cacheable_w)
    ,.mem_d_req_tag_o(mem_d_req_tag_w)
    ,.mem_d_invalidate_o(mem_d_invalidate_w)
    ,.mem_d_writeback_o(mem_d_writeback_w)
    ,.mem_d_flush_o(mem_d_flush_w)
    ,.mem_i_rd_o(mem_i_rd_w)
    ,.mem_i_flush_o(mem_i_flush_w)
    ,.mem_i_invalidate_o(mem_i_invalidate_w)
    ,.mem_i_pc_o(mem_i_pc_w)
);

tcm_mem
u_mem
(
    // Inputs
     .clk_i(Clk)
    ,.rst_i(!sys_rst_n)
    ,.mem_i_rd_i(mem_i_rd_w)
    ,.mem_i_flush_i(mem_i_flush_w)
    ,.mem_i_invalidate_i(mem_i_invalidate_w)
    ,.mem_i_pc_i(mem_i_pc_w)
    ,.mem_d_addr_i(mem_d_addr_w)
    ,.mem_d_data_wr_i(mem_d_data_wr_w)
    ,.mem_d_rd_i(mem_d_rd_w)
    ,.mem_d_wr_i(mem_d_wr_w)
    ,.mem_d_cacheable_i(mem_d_cacheable_w)
    ,.mem_d_req_tag_i(mem_d_req_tag_w)
    ,.mem_d_invalidate_i(mem_d_invalidate_w)
    ,.mem_d_writeback_i(mem_d_writeback_w)
    ,.mem_d_flush_i(mem_d_flush_w)

    // Outputs
    ,.mem_i_accept_o(mem_i_accept_w)
    ,.mem_i_valid_o(mem_i_valid_w)
    ,.mem_i_error_o(mem_i_error_w)
    ,.mem_i_inst_o(mem_i_inst_w)
    ,.mem_d_data_rd_o(mem_d_data_rd_w)
    ,.mem_d_accept_o(mem_d_accept_w)
    ,.mem_d_ack_o(mem_d_ack_w)
    ,.mem_d_error_o(mem_d_error_w)
    ,.mem_d_resp_tag_o(mem_d_resp_tag_w)
);

 ila_0 ila_0_inst(
	.clk(Clk),
	.probe0(probe0),
	.probe1(probe1),
	.probe2(probe2),
	.probe3(probe3),
	.probe4(probe4),
	.probe5(probe5),
	.probe6(probe6),
	.probe7(probe7),
	.probe8(probe8)
);

 assign probe0 = mem_i_pc_w;
 assign probe1 = mem_d_addr_w;
 assign probe2 = mem_d_data_wr_w;
 assign probe3 = mem_d_data_rd_w;
 assign probe4 = mem_i_inst_w;
 assign probe5 = mem_d_req_tag_w;
 assign probe6 = mem_d_resp_tag_w;
 assign probe7 = mem_d_wr_w;
 
 assign probe8[0] = mem_i_rd_w;
 assign probe8[1] = mem_i_flush_w;
 assign probe8[2] = mem_i_invalidate_w;
 assign probe8[3] = mem_d_rd_w;
 assign probe8[4] = mem_d_cacheable_w;
 assign probe8[5] = mem_d_invalidate_w;
 assign probe8[6] = mem_d_writeback_w;
 assign probe8[7] = mem_d_flush_w;
 assign probe8[8] = mem_i_accept_w;
 assign probe8[9] = mem_i_valid_w;
 assign probe8[10] = mem_i_error_w;
 assign probe8[11] = mem_d_accept_w;
 assign probe8[12] = mem_d_ack_w;
 assign probe8[13] = mem_d_error_w;

`endif






 endmodule