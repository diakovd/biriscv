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

module tcm_mem_ram
#(
	 parameter VENDOR = "Xilinx",
     parameter TCM_MEM_DEPTH   = 32 // KByte
)
(
    // Inputs
     input           clk0_i
    ,input           rst0_i
    ,input  [ $clog2(((TCM_MEM_DEPTH*1024)/8)) - 1:0]  addr0_i
    ,input  [ 63:0]  data0_i
    ,input  [  7:0]  wr0_i
    ,input           clk1_i
    ,input           rst1_i
    ,input  [ $clog2(((TCM_MEM_DEPTH*1024)/8)) - 1:0]  addr1_i
    ,input  [ 63:0]  data1_i
    ,input  [  7:0]  wr1_i

    // Outputs
    ,output [ 63:0]  data0_o
    ,output [ 63:0]  data1_o
);



//-----------------------------------------------------------------
// Dual Port RAM 64KB
// Mode: Read First
//-----------------------------------------------------------------

reg [63:0] ram_read0_q;
reg [63:0] ram_read1_q;

generate
if(VENDOR == "Xilinx") begin

blk_mem_gen_0 blk_mem_gen_0_inst(
  .clka(clk0_i),
  // .ena(|wr0_i),
  .wea(wr0_i),
  .addra(addr0_i), // 10:0
  .dina(data0_i),
  .douta(ram_read0_q),

  .clkb(clk0_i),
  // .enb(|wr1_i),
  .web(wr1_i),
  .addrb(addr1_i),
  .dinb(data1_i),
  .doutb(ram_read1_q)
);

assign data0_o = ram_read0_q;
assign data1_o = ram_read1_q;

end
else begin

/* verilator lint_off MULTIDRIVEN */
reg [63:0]   ram [((TCM_MEM_DEPTH*1024)/8) - 1:0] /*verilator public*/;
/* verilator lint_on MULTIDRIVEN */

// Synchronous write
always @ (posedge clk0_i)
begin
    if (wr0_i[0])
        ram[addr0_i][7:0] <= data0_i[7:0];
    if (wr0_i[1])
        ram[addr0_i][15:8] <= data0_i[15:8];
    if (wr0_i[2])
        ram[addr0_i][23:16] <= data0_i[23:16];
    if (wr0_i[3])
        ram[addr0_i][31:24] <= data0_i[31:24];
    if (wr0_i[4])
        ram[addr0_i][39:32] <= data0_i[39:32];
    if (wr0_i[5])
        ram[addr0_i][47:40] <= data0_i[47:40];
    if (wr0_i[6])
        ram[addr0_i][55:48] <= data0_i[55:48];
    if (wr0_i[7])
        ram[addr0_i][63:56] <= data0_i[63:56];

    ram_read0_q <= ram[addr0_i];
end

always @ (posedge clk1_i)
begin
    if (wr1_i[0])
        ram[addr1_i][7:0] <= data1_i[7:0];
    if (wr1_i[1])
        ram[addr1_i][15:8] <= data1_i[15:8];
    if (wr1_i[2])
        ram[addr1_i][23:16] <= data1_i[23:16];
    if (wr1_i[3])
        ram[addr1_i][31:24] <= data1_i[31:24];
    if (wr1_i[4])
        ram[addr1_i][39:32] <= data1_i[39:32];
    if (wr1_i[5])
        ram[addr1_i][47:40] <= data1_i[47:40];
    if (wr1_i[6])
        ram[addr1_i][55:48] <= data1_i[55:48];
    if (wr1_i[7])
        ram[addr1_i][63:56] <= data1_i[63:56];

    ram_read1_q <= ram[addr1_i];
end

assign data0_o = ram_read0_q;
assign data1_o = ram_read1_q;


task write; /*verilator public*/
    input [31:0] addr;
    input [7:0]  data;
begin
    case (addr[2:0])
    3'd0: ram[addr/8][7:0]   = data;
    3'd1: ram[addr/8][15:8]  = data;
    3'd2: ram[addr/8][23:16] = data;
    3'd3: ram[addr/8][31:24] = data;
    3'd4: ram[addr/8][39:32] = data;
    3'd5: ram[addr/8][47:40] = data;
    3'd6: ram[addr/8][55:48] = data;
    3'd7: ram[addr/8][63:56] = data;
    endcase
end
endtask

reg [7:0] mem[131072:0];
integer i;
integer f;

initial
begin
    // Load TCM memory
    for (i=0;i<131072;i=i+1)
        mem[i] = 0;

    // f = $fopen("program8.hex","r");
    // i = $fread(mem, f);
	$readmemh("../Dhry/PyTools/program8.hex", mem);
	
    for (i=0;i<131072;i=i+1)
        write(i, mem[i]);
		
end

end
endgenerate

endmodule
