//-----------------------------------------------------------------
//                         biRISC-V CPU
//                            V0.6.0
//                     Ultra-Embedded.com
//                     Copyright 2019-2020
//
//                   admin@ultra-embedded.com
//
//                     License: Apache 2.0
//-----------------------------------------------------------------
// Copyright 2020 Ultra-Embedded.com
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//-----------------------------------------------------------------

`ifdef Sim
	`include "../src/peripherial/defines.sv"
`else 
 `include "defines.sv"
`endif
  
module dport_mux
//-----------------------------------------------------------------
// Params
//-----------------------------------------------------------------
#(
     parameter TCM_MEM_BASE    = 0,
     parameter TCM_MEM_DEPTH   = 16 // KByte
)
//-----------------------------------------------------------------
// Ports
//-----------------------------------------------------------------
(
    // Inputs
    input           clk_i,
    input           rst_i,
    input  [ 31:0]  mem_addr_i,
    input  [ 31:0]  mem_data_wr_i,
    input           mem_rd_i,
    input  [  3:0]  mem_wr_i,
    input           mem_cacheable_i,
    input  [ 10:0]  mem_req_tag_i,
    input           mem_invalidate_i,
    input           mem_writeback_i,
    input           mem_flush_i,
    input  [ 31:0]  mem_tcm_data_rd_i,
    input           mem_tcm_accept_i,
    input           mem_tcm_ack_i,
    input           mem_tcm_error_i,
    input  [ 10:0]  mem_tcm_resp_tag_i,

    // Outputs
    output [ 31:0]  mem_data_rd_o,
    output          mem_accept_o,
    output          mem_ack_o,
    output          mem_error_o,
    output [ 10:0]  mem_resp_tag_o,
    output [ 31:0]  mem_tcm_addr_o,
    output [ 31:0]  mem_tcm_data_wr_o,
    output          mem_tcm_rd_o,
    output [  3:0]  mem_tcm_wr_o,
    output          mem_tcm_cacheable_o,
    output [ 10:0]  mem_tcm_req_tag_o,
    output          mem_tcm_invalidate_o,
    output          mem_tcm_writeback_o,
    output          mem_tcm_flush_o,

	AXI4bus.Master 	axiBus_UART,  
	AXI4bus.Master 	axiBus_TM,  
	AXI4bus.Master 	axiBus_TM1,
	AXI4bus.Master 	axiBus_mtimer	

    // ,input  [ 31:0]  mem_ext_data_rd_i
    // ,input           mem_ext_accept_i
    // ,input           mem_ext_ack_i
    // ,input           mem_ext_error_i
    // ,input  [ 10:0]  mem_ext_resp_tag_i
    // ,output [ 31:0]  mem_ext_addr_o
    // ,output [ 31:0]  mem_ext_data_wr_o
    // ,output          mem_ext_rd_o
    // ,output [  3:0]  mem_ext_wr_o
    // ,output          mem_ext_cacheable_o
    // ,output [ 10:0]  mem_ext_req_tag_o
    // ,output          mem_ext_invalidate_o
    // ,output          mem_ext_writeback_o
    // ,output          mem_ext_flush_o
);



//-----------------------------------------------------------------
// Dcache_if mux
//-----------------------------------------------------------------
wire hold_w;
reg [5:0] sel_vec;
wire IOsel;
wire UARTsel;
wire TMsel;
wire TM1sel;
reg UART_access_q;
reg TM_access_q;   
reg TM1_access_q;  
reg mtimer_access_q; 


/* verilator lint_off UNSIGNED */
wire tcm_access_w = (mem_addr_i >= TCM_MEM_BASE && mem_addr_i < (TCM_MEM_BASE + (TCM_MEM_DEPTH*1024)));

assign sel_vec	= (mem_addr_i >= `addrBASE_mtimer)?   6'b100000 :
				  (mem_addr_i >= `addrBASE_Timer1)?   6'b010000 :
				  (mem_addr_i >= `addrBASE_Timer)?    6'b001000 :
				  (mem_addr_i >= `addrBASE_UART0)?    6'b000100 :
				  (mem_addr_i >= `addrBASE_IOmodule)? 6'b000010 :
				  (mem_addr_i >= `addrBASE_RAM)?      6'b000001 : 6'b000001;
				  
assign IOsel   = sel_vec[1];					
assign UARTsel = sel_vec[2];					
assign TMsel   = sel_vec[3];					
assign TM1sel     = sel_vec[4];
assign mtimersel  = sel_vec[5];
	
/* verilator lint_on UNSIGNED */

reg       tcm_access_q;
reg [4:0] pending_q;


//memory interface
assign mem_tcm_addr_o       = mem_addr_i;
assign mem_tcm_data_wr_o    = mem_data_wr_i;
// assign mem_tcm_rd_o         = (tcm_access_w & ~hold_w) ? mem_rd_i : 1'b0;
// assign mem_tcm_wr_o         = (tcm_access_w & ~hold_w) ? mem_wr_i : 4'b0;
assign mem_tcm_rd_o         = (tcm_access_w) ? mem_rd_i : 1'b0;
assign mem_tcm_wr_o         = (tcm_access_w) ? mem_wr_i : 4'b0;
assign mem_tcm_cacheable_o  = mem_cacheable_i;
assign mem_tcm_req_tag_o    = mem_req_tag_i;
// assign mem_tcm_invalidate_o = (tcm_access_w & ~hold_w) ? mem_invalidate_i : 1'b0;
// assign mem_tcm_writeback_o  = (tcm_access_w & ~hold_w) ? mem_writeback_i : 1'b0;
// assign mem_tcm_flush_o      = (tcm_access_w & ~hold_w) ? mem_flush_i : 1'b0;
assign mem_tcm_invalidate_o = (tcm_access_w) ? mem_invalidate_i : 1'b0;
assign mem_tcm_writeback_o  = (tcm_access_w) ? mem_writeback_i : 1'b0;
assign mem_tcm_flush_o      = (tcm_access_w) ? mem_flush_i : 1'b0;

//peripherial interface
// assign mem_ext_addr_o       = mem_addr_i;
// assign mem_ext_data_wr_o    = mem_data_wr_i;
// assign mem_ext_rd_o         = (~tcm_access_w) ? mem_rd_i : 1'b0;
// assign mem_ext_wr_o         = (~tcm_access_w) ? mem_wr_i : 4'b0;
// assign mem_ext_cacheable_o  = mem_cacheable_i;
// assign mem_ext_req_tag_o    = mem_req_tag_i;
// assign mem_ext_invalidate_o = (~tcm_access_w) ? mem_invalidate_i : 1'b0;
// assign mem_ext_writeback_o  = (~tcm_access_w) ? mem_writeback_i : 1'b0;
// assign mem_ext_flush_o      = (~tcm_access_w) ? mem_flush_i : 1'b0;

//UART bus
assign axiBus_UART.awaddr  = mem_addr_i;
assign axiBus_UART.awvalid = UARTsel & (mem_wr_i[3] | mem_wr_i[2] | mem_wr_i[1] | mem_wr_i[0]);

assign axiBus_UART.wvalid  = UARTsel & (mem_wr_i[3] | mem_wr_i[2] | mem_wr_i[1] | mem_wr_i[0]);
assign axiBus_UART.wdata = mem_data_wr_i;
assign axiBus_UART.wstrb = mem_wr_i;

assign axiBus_UART.araddr = mem_addr_i;
assign axiBus_UART.arvalid = UARTsel & mem_rd_i;

assign axiBus_UART.rready = 1;

//Timer bus
assign axiBus_TM.awaddr = mem_addr_i;
assign axiBus_TM.awvalid = TMsel & (mem_wr_i[3] | mem_wr_i[2] | mem_wr_i[1] | mem_wr_i[0]);

assign axiBus_TM.wvalid = TMsel & (mem_wr_i[3] | mem_wr_i[2] | mem_wr_i[1] | mem_wr_i[0]);
assign axiBus_TM.wdata = mem_data_wr_i;
assign axiBus_TM.wstrb = mem_wr_i;

assign axiBus_TM.araddr = mem_addr_i;
assign axiBus_TM.arvalid = TMsel & mem_rd_i;

assign axiBus_TM.rready = 1;

//Timer1 bus
assign axiBus_TM1.awaddr = mem_addr_i;
assign axiBus_TM1.awvalid = TM1sel & (mem_wr_i[3] | mem_wr_i[2] | mem_wr_i[1] | mem_wr_i[0]);

assign axiBus_TM1.wvalid = TM1sel & (mem_wr_i[3] | mem_wr_i[2] | mem_wr_i[1] | mem_wr_i[0]);
assign axiBus_TM1.wdata = mem_data_wr_i;
assign axiBus_TM1.wstrb = mem_wr_i;

assign axiBus_TM1.araddr = mem_addr_i;
assign axiBus_TM1.arvalid = TM1sel & mem_rd_i;

assign axiBus_TM1.rready = 1;

//mtimer bus
assign axiBus_mtimer.awaddr = mem_addr_i;
assign axiBus_mtimer.awvalid = mtimersel & (mem_wr_i[3] | mem_wr_i[2] | mem_wr_i[1] | mem_wr_i[0]);

assign axiBus_mtimer.wvalid = mtimersel & (mem_wr_i[3] | mem_wr_i[2] | mem_wr_i[1] | mem_wr_i[0]);
assign axiBus_mtimer.wdata = mem_data_wr_i;
assign axiBus_mtimer.wstrb = mem_wr_i;

assign axiBus_mtimer.araddr = mem_addr_i;
assign axiBus_mtimer.arvalid = mtimersel & mem_rd_i;

assign axiBus_mtimer.rready = 1;


//accept's to master 
assign mem_accept_o         = (tcm_access_w ?  mem_tcm_accept_i   : 1'b1);// & !hold_w;
assign mem_data_rd_o        = (tcm_access_q)?  mem_tcm_data_rd_i  : 
							  (UART_access_q)? axiBus_UART.rdata  :
							  (TM_access_q)?   axiBus_TM.rdata    : 
							  (TM1_access_q)?  axiBus_TM1.rdata   :
							  (mtimer_access_q)? axiBus_mtimer.rdata : 0;
							  
assign mem_ack_o            = (tcm_access_q)?  mem_tcm_ack_i :
							  (UART_access_q)? axiBus_UART.wready | axiBus_UART.rvalid :
							  (TM_access_q)?   axiBus_TM.wready   | axiBus_TM.rvalid   : 
							  (TM1_access_q)?  axiBus_TM1.wready  | axiBus_TM1.rvalid  : 
							  (mtimer_access_q)?  axiBus_mtimer.wready  | axiBus_mtimer.rvalid  : 0;
							  
assign mem_error_o          = tcm_access_q ? mem_tcm_error_i    : 1'b0;
assign mem_resp_tag_o       = tcm_access_q ? mem_tcm_resp_tag_i : 11'h0;



wire   request_w            = mem_rd_i || mem_wr_i != 4'b0 || mem_flush_i || mem_invalidate_i || mem_writeback_i;

// reg [4:0] pending_r;
// always @ *
// begin
    // pending_r = pending_q;

    // if ((request_w && mem_accept_o) && !mem_ack_o)
        // pending_r = pending_r + 5'd1;
    // else if (!(request_w && mem_accept_o) && mem_ack_o)
        // pending_r = pending_r - 5'd1;
// end

// always @ (posedge clk_i or posedge rst_i)
// if (rst_i)
    // pending_q <= 5'b0;
// else
    // pending_q <= pending_r;

always @ (posedge clk_i or posedge rst_i)
if (rst_i) begin
    tcm_access_q  <= 1'b0;
	UART_access_q <= 1'b0;
	TM_access_q   <= 1'b0;
	TM1_access_q  <= 1'b0;
	mtimer_access_q <= 1'b0;
end
else if (request_w && mem_accept_o) begin
    tcm_access_q  <= tcm_access_w;
	UART_access_q <= UARTsel;
	TM_access_q   <= TMsel;
	TM1_access_q  <= TM1sel;
	mtimer_access_q  <= mtimersel;
end

// //assign hold_w = (|pending_q) && (tcm_access_q != tcm_access_w);
// assign hold_w = 0;//(|pending_q) && (tcm_access_q != tcm_access_w);



endmodule
