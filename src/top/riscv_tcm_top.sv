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

module riscv_tcm_top
//-----------------------------------------------------------------
// Params
//-----------------------------------------------------------------
#(
     parameter BOOT_VECTOR      = 32'h00000000
    ,parameter CORE_ID          = 0
    ,parameter TCM_MEM_BASE     = 32'h00000000
	,parameter VENDOR 			= "Xilinx"
	,parameter TCM_MEM_DEPTH    = 16 
    ,parameter SUPPORT_BRANCH_PREDICTION = 1
    ,parameter SUPPORT_MULDIV   = 1
    ,parameter SUPPORT_SUPER    = 0
    ,parameter SUPPORT_MMU      = 0
    ,parameter SUPPORT_DUAL_ISSUE = 1
    ,parameter SUPPORT_LOAD_BYPASS = 1
    ,parameter SUPPORT_MUL_BYPASS = 1
    ,parameter SUPPORT_REGFILE_XILINX = 0
    ,parameter EXTRA_DECODE_STAGE = 0
    ,parameter MEM_CACHE_ADDR_MIN = 32'h80000000
    ,parameter MEM_CACHE_ADDR_MAX = 32'h8fffffff
    ,parameter NUM_BTB_ENTRIES  = 32
    ,parameter NUM_BTB_ENTRIES_W = 5
    ,parameter NUM_BHT_ENTRIES  = 512
    ,parameter NUM_BHT_ENTRIES_W = 9
    ,parameter RAS_ENABLE       = 1
    ,parameter GSHARE_ENABLE    = 0
    ,parameter BHT_ENABLE       = 1
    ,parameter NUM_RAS_ENTRIES  = 8
    ,parameter NUM_RAS_ENTRIES_W = 3
)
//-----------------------------------------------------------------
// Ports
//-----------------------------------------------------------------
(
    // Inputs
    input           clk_i,
    input           rst_i,
    input           rst_cpu_i,

    output          axi_t_awready_o,
    output          axi_t_wready_o,
    output          axi_t_bvalid_o,
    output [  1:0]  axi_t_bresp_o,
    output [  3:0]  axi_t_bid_o,
    output          axi_t_arready_o,
    output          axi_t_rvalid_o,
    output [ 31:0]  axi_t_rdata_o,
    output [  1:0]  axi_t_rresp_o,
    output [  3:0]  axi_t_rid_o,
    output          axi_t_rlast_o,
    input           axi_t_awvalid_i,
    input  [ 31:0]  axi_t_awaddr_i,
    input  [  3:0]  axi_t_awid_i,
    input  [  7:0]  axi_t_awlen_i,
    input  [  1:0]  axi_t_awburst_i,
    input           axi_t_wvalid_i,
    input  [ 31:0]  axi_t_wdata_i,
    input  [  3:0]  axi_t_wstrb_i,
    input           axi_t_wlast_i,
    input           axi_t_bready_i,
    input           axi_t_arvalid_i,
    input  [ 31:0]  axi_t_araddr_i,
    input  [  3:0]  axi_t_arid_i,
    input  [  7:0]  axi_t_arlen_i,
    input  [  1:0]  axi_t_arburst_i,
    input           axi_t_rready_i,

    // input           axi_i_awready_i,
    // input           axi_i_wready_i,
    // input           axi_i_bvalid_i,
    // input  [  1:0]  axi_i_bresp_i,
    // input           axi_i_arready_i,
    // input           axi_i_rvalid_i,
    // input  [ 31:0]  axi_i_rdata_i,
    // input  [  1:0]  axi_i_rresp_i,

    // // Outputs
    // output          axi_i_awvalid_o,
    // output [ 31:0]  axi_i_awaddr_o,
    // output          axi_i_wvalid_o,
    // output [ 31:0]  axi_i_wdata_o,
    // output [  3:0]  axi_i_wstrb_o,
    // output          axi_i_bready_o,
    // output          axi_i_arvalid_o,
    // output [ 31:0]  axi_i_araddr_o,
    // output          axi_i_rready_o,
	
	AXI4bus.Master axiBus_UART,  
	AXI4bus.Master axiBus_TM,  
	AXI4bus.Master axiBus_TM1,  
	AXI4bus.Master axiBus_mtimer,
	AXI4bus.Slave  axiBus_BootLoader,

    input  [ 31:0]  intr_i
);

wire  [ 31:0]  ifetch_pc_w;
wire  [ 31:0]  dport_tcm_data_rd_w;
wire           dport_tcm_cacheable_w;
wire           dport_flush_w;
wire  [  3:0]  dport_tcm_wr_w;
wire           ifetch_rd_w;
wire           dport_axi_accept_w;
wire           dport_cacheable_w;
wire           dport_tcm_flush_w;
wire  [ 10:0]  dport_resp_tag_w;
wire  [ 10:0]  dport_axi_resp_tag_w;
wire           ifetch_accept_w;
wire  [ 31:0]  dport_data_rd_w;
wire           dport_tcm_invalidate_w;
wire           dport_ack_w;
wire  [ 10:0]  dport_axi_req_tag_w;
wire  [ 31:0]  dport_data_wr_w;
wire           dport_invalidate_w;
wire  [ 10:0]  dport_tcm_req_tag_w;
wire  [ 31:0]  dport_tcm_addr_w;
wire           dport_axi_error_w;
wire           dport_tcm_ack_w;
wire           dport_tcm_rd_w;
wire  [ 10:0]  dport_tcm_resp_tag_w;
wire           dport_writeback_w;
wire  [ 31:0]  cpu_id_w = CORE_ID;
wire           dport_rd_w;
wire           dport_axi_ack_w;
wire           dport_axi_rd_w;
wire  [ 31:0]  dport_axi_data_rd_w;
wire           dport_axi_invalidate_w;
wire  [ 31:0]  boot_vector_w = BOOT_VECTOR;
wire  [ 31:0]  dport_addr_w;
wire           ifetch_error_w;
wire  [ 31:0]  dport_tcm_data_wr_w;
wire           ifetch_flush_w;
wire  [ 31:0]  dport_axi_addr_w;
wire           dport_error_w;
wire           dport_tcm_accept_w;
wire           ifetch_invalidate_w;
wire           dport_axi_writeback_w;
wire  [  3:0]  dport_wr_w;
wire           ifetch_valid_w;
wire  [ 31:0]  dport_axi_data_wr_w;
wire  [ 10:0]  dport_req_tag_w;
wire  [ 63:0]  ifetch_inst_w;
wire           dport_axi_cacheable_w;
wire           dport_tcm_writeback_w;
wire  [  3:0]  dport_axi_wr_w;
wire           dport_axi_flush_w;
wire           dport_tcm_error_w;
wire           dport_accept_w;

 
wire  [ 31:0]  mem_d_addr_i;
wire  [ 31:0]  mem_d_data_wr_i;
wire           mem_d_rd_i;
wire  [  3:0]  mem_d_wr_i;
wire           mem_d_cacheable_i;
wire  [ 10:0]  mem_d_req_tag_i;
wire           mem_d_invalidate_i;
wire           mem_d_writeback_i;
wire           mem_d_flush_i;
	
riscv_core
#(
     .MEM_CACHE_ADDR_MIN(MEM_CACHE_ADDR_MIN)
    ,.MEM_CACHE_ADDR_MAX(MEM_CACHE_ADDR_MAX)
    ,.SUPPORT_BRANCH_PREDICTION(SUPPORT_BRANCH_PREDICTION)
    ,.SUPPORT_MULDIV(SUPPORT_MULDIV)
    ,.SUPPORT_SUPER(SUPPORT_SUPER)
    ,.SUPPORT_MMU(SUPPORT_MMU)
    ,.SUPPORT_DUAL_ISSUE(SUPPORT_DUAL_ISSUE)
    ,.SUPPORT_LOAD_BYPASS(SUPPORT_LOAD_BYPASS)
    ,.SUPPORT_MUL_BYPASS(SUPPORT_MUL_BYPASS)
    ,.SUPPORT_REGFILE_XILINX(SUPPORT_REGFILE_XILINX)
    ,.EXTRA_DECODE_STAGE(EXTRA_DECODE_STAGE)
    ,.NUM_BTB_ENTRIES(NUM_BTB_ENTRIES)
    ,.NUM_BTB_ENTRIES_W(NUM_BTB_ENTRIES_W)
    ,.NUM_BHT_ENTRIES(NUM_BHT_ENTRIES)
    ,.NUM_BHT_ENTRIES_W(NUM_BHT_ENTRIES_W)
    ,.RAS_ENABLE(RAS_ENABLE)
    ,.GSHARE_ENABLE(GSHARE_ENABLE)
    ,.BHT_ENABLE(BHT_ENABLE)
    ,.NUM_RAS_ENTRIES(NUM_RAS_ENTRIES)
    ,.NUM_RAS_ENTRIES_W(NUM_RAS_ENTRIES_W)
)
u_core
(
    // Inputs
    .clk_i(clk_i),
	.rst_i(rst_cpu_i),
    
	.mem_d_addr_o(dport_addr_w),
	.mem_d_data_wr_o(dport_data_wr_w),
	.mem_d_wr_o(dport_wr_w),

	
	.mem_d_data_rd_i(dport_data_rd_w),
	.mem_d_rd_o(dport_rd_w),
    
	.mem_d_accept_i(dport_accept_w),
	.mem_d_ack_i(dport_ack_w),
	.mem_d_error_i(dport_error_w),
	.mem_d_resp_tag_i(dport_resp_tag_w),

    .mem_d_cacheable_o(dport_cacheable_w),
    .mem_d_req_tag_o(dport_req_tag_w),
	.mem_d_invalidate_o(dport_invalidate_w),
	.mem_d_writeback_o(dport_writeback_w),
	.mem_d_flush_o(dport_flush_w),

    .mem_i_rd_o(ifetch_rd_w),
	.mem_i_flush_o(ifetch_flush_w),
	.mem_i_invalidate_o(ifetch_invalidate_w),
	.mem_i_pc_o(ifetch_pc_w),
	
    .mem_i_accept_i(ifetch_accept_w),
	.mem_i_valid_i(ifetch_valid_w),
	.mem_i_error_i(ifetch_error_w),
	.mem_i_inst_i(ifetch_inst_w),
	
	.intr_i(intr_i),
	.reset_vector_i(boot_vector_w),
	.cpu_id_i(cpu_id_w)


);


dport_mux
#(
     .TCM_MEM_BASE(TCM_MEM_BASE),
	 .TCM_MEM_DEPTH(TCM_MEM_DEPTH)
)
u_dmux
(
    // Inputs
    .clk_i(clk_i),
    .rst_i(rst_cpu_i),
    .mem_addr_i(dport_addr_w),
    .mem_data_wr_i(dport_data_wr_w),
    .mem_rd_i(dport_rd_w),
    .mem_wr_i(dport_wr_w),
    .mem_cacheable_i(dport_cacheable_w),
    .mem_req_tag_i(dport_req_tag_w),
    .mem_invalidate_i(dport_invalidate_w),
    .mem_writeback_i(dport_writeback_w),
    .mem_flush_i(dport_flush_w),
    .mem_tcm_data_rd_i(dport_tcm_data_rd_w),
    .mem_tcm_accept_i(dport_tcm_accept_w),
    .mem_tcm_ack_i(dport_tcm_ack_w),
    .mem_tcm_error_i(dport_tcm_error_w),
    .mem_tcm_resp_tag_i(dport_tcm_resp_tag_w),


    // Outputs
    .mem_data_rd_o(dport_data_rd_w),
    .mem_accept_o(dport_accept_w),
    .mem_ack_o(dport_ack_w),
    .mem_error_o(dport_error_w),
    .mem_resp_tag_o(dport_resp_tag_w),
    .mem_tcm_addr_o(dport_tcm_addr_w),
    .mem_tcm_data_wr_o(dport_tcm_data_wr_w),
    .mem_tcm_rd_o(dport_tcm_rd_w),
    .mem_tcm_wr_o(dport_tcm_wr_w),
    .mem_tcm_cacheable_o(dport_tcm_cacheable_w),
    .mem_tcm_req_tag_o(dport_tcm_req_tag_w),
    .mem_tcm_invalidate_o(dport_tcm_invalidate_w),
    .mem_tcm_writeback_o(dport_tcm_writeback_w),
    .mem_tcm_flush_o(dport_tcm_flush_w),
	
    // ,.mem_ext_data_rd_i(dport_axi_data_rd_w)
    // ,.mem_ext_accept_i(dport_axi_accept_w)
    // ,.mem_ext_ack_i(dport_axi_ack_w)
    // ,.mem_ext_error_i(dport_axi_error_w)
    // ,.mem_ext_resp_tag_i(dport_axi_resp_tag_w)
    // ,.mem_ext_addr_o(dport_axi_addr_w)
    // ,.mem_ext_data_wr_o(dport_axi_data_wr_w)
    // ,.mem_ext_rd_o(dport_axi_rd_w)
    // ,.mem_ext_wr_o(dport_axi_wr_w)
    // ,.mem_ext_cacheable_o(dport_axi_cacheable_w)
    // ,.mem_ext_req_tag_o(dport_axi_req_tag_w)
    // ,.mem_ext_invalidate_o(dport_axi_invalidate_w)
    // ,.mem_ext_writeback_o(dport_axi_writeback_w)
    // ,.mem_ext_flush_o(dport_axi_flush_w)
	
	.axiBus_UART(axiBus_UART),
	.axiBus_TM(axiBus_TM),
	.axiBus_TM1(axiBus_TM1),
	.axiBus_mtimer(axiBus_mtimer)
);


tcm_mem
#(
	.VENDOR(VENDOR),
	.TCM_MEM_DEPTH(TCM_MEM_DEPTH)
)	
u_tcm
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.mem_i_rd_i(ifetch_rd_w)
    ,.mem_i_flush_i(ifetch_flush_w)
    ,.mem_i_invalidate_i(ifetch_invalidate_w)
    ,.mem_i_pc_i(ifetch_pc_w)
    ,.mem_d_addr_i(mem_d_addr_i)
    ,.mem_d_data_wr_i(mem_d_data_wr_i)
    ,.mem_d_rd_i(mem_d_rd_i)
    ,.mem_d_wr_i(mem_d_wr_i)
    ,.mem_d_cacheable_i(mem_d_cacheable_i)
    ,.mem_d_req_tag_i(mem_d_req_tag_i)
    ,.mem_d_invalidate_i(mem_d_invalidate_i)
    ,.mem_d_writeback_i(mem_d_writeback_i)
    ,.mem_d_flush_i(mem_d_flush_i)
    ,.axi_awvalid_i(axi_t_awvalid_i)
    ,.axi_awaddr_i(axi_t_awaddr_i)
    ,.axi_awid_i(axi_t_awid_i)
    ,.axi_awlen_i(axi_t_awlen_i)
    ,.axi_awburst_i(axi_t_awburst_i)
    ,.axi_wvalid_i(axi_t_wvalid_i)
    ,.axi_wdata_i(axi_t_wdata_i)
    ,.axi_wstrb_i(axi_t_wstrb_i)
    ,.axi_wlast_i(axi_t_wlast_i)
    ,.axi_bready_i(axi_t_bready_i)
    ,.axi_arvalid_i(axi_t_arvalid_i)
    ,.axi_araddr_i(axi_t_araddr_i)
    ,.axi_arid_i(axi_t_arid_i)
    ,.axi_arlen_i(axi_t_arlen_i)
    ,.axi_arburst_i(axi_t_arburst_i)
    ,.axi_rready_i(axi_t_rready_i)

    // Outputs
    ,.mem_i_accept_o(ifetch_accept_w)
    ,.mem_i_valid_o(ifetch_valid_w)
    ,.mem_i_error_o(ifetch_error_w)
    ,.mem_i_inst_o(ifetch_inst_w)
    ,.mem_d_data_rd_o(dport_tcm_data_rd_w)
    ,.mem_d_accept_o(dport_tcm_accept_w)
    ,.mem_d_ack_o(dport_tcm_ack_w)
    ,.mem_d_error_o(dport_tcm_error_w)
    ,.mem_d_resp_tag_o(dport_tcm_resp_tag_w)
    ,.axi_awready_o(axi_t_awready_o)
    ,.axi_wready_o(axi_t_wready_o)
    ,.axi_bvalid_o(axi_t_bvalid_o)
    ,.axi_bresp_o(axi_t_bresp_o)
    ,.axi_bid_o(axi_t_bid_o)
    ,.axi_arready_o(axi_t_arready_o)
    ,.axi_rvalid_o(axi_t_rvalid_o)
    ,.axi_rdata_o(axi_t_rdata_o)
    ,.axi_rresp_o(axi_t_rresp_o)
    ,.axi_rid_o(axi_t_rid_o)
    ,.axi_rlast_o(axi_t_rlast_o)
);
 
 assign mem_d_addr_i 		= (rst_cpu_i)? axiBus_BootLoader.awaddr : dport_tcm_addr_w;
 assign mem_d_data_wr_i 	= (rst_cpu_i)? axiBus_BootLoader.wdata : dport_tcm_data_wr_w;
 assign mem_d_rd_i 			= (rst_cpu_i)? 1'b0 : dport_tcm_rd_w;
 assign mem_d_wr_i 			= (rst_cpu_i)? ((axiBus_BootLoader.wvalid)? axiBus_BootLoader.wstrb : 0): dport_tcm_wr_w;
 assign mem_d_cacheable_i 	= (rst_cpu_i)? 1'b0 : dport_tcm_cacheable_w;
 assign mem_d_req_tag_i 	= (rst_cpu_i)? 0    : dport_tcm_req_tag_w;
 assign mem_d_invalidate_i	= (rst_cpu_i)? 1'b0 : dport_tcm_invalidate_w;
 assign mem_d_writeback_i 	= (rst_cpu_i)? 1'b0 : dport_tcm_writeback_w;
 assign mem_d_flush_i 		= (rst_cpu_i)? 1'b0 : dport_tcm_flush_w;

 assign axiBus_BootLoader.awready	= dport_tcm_ack_w;
 assign axiBus_BootLoader.wready	= dport_tcm_ack_w;
 
// dport_axi
// u_axi
// (
    // // Inputs
     // .clk_i(clk_i)
    // ,.rst_i(rst_i)
    // ,.mem_addr_i(dport_axi_addr_w)
    // ,.mem_data_wr_i(dport_axi_data_wr_w)
    // ,.mem_rd_i(dport_axi_rd_w)
    // ,.mem_wr_i(dport_axi_wr_w)
    // ,.mem_cacheable_i(dport_axi_cacheable_w)
    // ,.mem_req_tag_i(dport_axi_req_tag_w)
    // ,.mem_invalidate_i(dport_axi_invalidate_w)
    // ,.mem_writeback_i(dport_axi_writeback_w)
    // ,.mem_flush_i(dport_axi_flush_w)
    // ,.axi_awready_i(axi_i_awready_i)
    // ,.axi_wready_i(axi_i_wready_i)
    // ,.axi_bvalid_i(axi_i_bvalid_i)
    // ,.axi_bresp_i(axi_i_bresp_i)
    // ,.axi_arready_i(axi_i_arready_i)
    // ,.axi_rvalid_i(axi_i_rvalid_i)
    // ,.axi_rdata_i(axi_i_rdata_i)
    // ,.axi_rresp_i(axi_i_rresp_i)

    // // Outputs
    // ,.mem_data_rd_o(dport_axi_data_rd_w)
    // ,.mem_accept_o(dport_axi_accept_w)
    // ,.mem_ack_o(dport_axi_ack_w)
    // ,.mem_error_o(dport_axi_error_w)
    // ,.mem_resp_tag_o(dport_axi_resp_tag_w)
    // ,.axi_awvalid_o(axi_i_awvalid_o)
    // ,.axi_awaddr_o(axi_i_awaddr_o)
    // ,.axi_wvalid_o(axi_i_wvalid_o)
    // ,.axi_wdata_o(axi_i_wdata_o)
    // ,.axi_wstrb_o(axi_i_wstrb_o)
    // ,.axi_bready_o(axi_i_bready_o)
    // ,.axi_arvalid_o(axi_i_arvalid_o)
    // ,.axi_araddr_o(axi_i_araddr_o)
    // ,.axi_rready_o(axi_i_rready_o)
// );

`ifndef Sim

wire [31 : 0] probe0;
wire [31 : 0] probe1;
wire [31 : 0] probe2;
wire [31 : 0] probe3;
wire [63 : 0] probe4;
wire [10 : 0] probe5;
wire [10 : 0] probe6;
wire [3 : 0] probe7;
wire [13 : 0] probe8;

 ila_0 ila_0_inst(
	.clk(clk_i),
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

 assign probe0 = ifetch_pc_w;
 assign probe1 = dport_addr_w;
 assign probe2 = dport_data_wr_w;
 assign probe3 = dport_tcm_data_rd_w;
 assign probe4 = ifetch_inst_w;
 assign probe5 = 0;
 assign probe6 = 0;
 assign probe7 = dport_wr_w;
 
 assign probe8[0] = ifetch_rd_w;
 assign probe8[1] = ifetch_flush_w;
 assign probe8[2] = dport_invalidate_w;
 assign probe8[3] = dport_rd_w;
 assign probe8[4] = dport_cacheable_w;
 assign probe8[5] = ifetch_invalidate_w;
 assign probe8[6] = dport_writeback_w;
 assign probe8[7] = ifetch_flush_w;
 assign probe8[8] = ifetch_accept_w;
 assign probe8[9] = ifetch_valid_w;
 assign probe8[10] = ifetch_error_w;
 assign probe8[11] = dport_accept_w;
 assign probe8[12] = dport_ack_w;
 assign probe8[13] = dport_error_w;
 
`endif 

endmodule
