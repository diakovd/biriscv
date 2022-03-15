set SRC     "vlog -O0 +acc ../src"
set TB		"vlog -O0 +acc ../tb/tb_core_icarus"
set PRF		"vlog -O0 +acc ../src/peripherial"
set VIVpr   "vlog -O0 +acc ../Viv_pr"
set QUApr   "vlog -O0 +acc ../example_tb/fpga_sys/qua_pr"

alias c "

#tb source 
	$TB/tb_top.v
	#$TB/tcm_mem.v
	#$TB/tcm_mem_ram.v

#AXI4_lib

#Peripherial
	$PRF/BootLoader/BootLoader.sv +define+Sim
	$PRF/BootLoader/BootLoader_tb.sv +define+Sim
	$PRF/uart_module/UART.sv +define+Sim
	$PRF/uart_module/asinhFIFOa_sim.sv
	$PRF/uart_module/UART_wb.sv +define+Sim
	
#Core source 
	$SRC/core/biriscv_alu.v
	$SRC/core/biriscv_csr.v
	$SRC/core/biriscv_csr_regfile.v
	$SRC/core/biriscv_decode.v
	$SRC/core/biriscv_decoder.v
	$SRC/core/biriscv_divider.v
	$SRC/core/biriscv_exec.v
	$SRC/core/biriscv_fetch.v +incdir+../src/core
	$SRC/core/biriscv_frontend.v
	$SRC/core/biriscv_issue.v 
	#+define+verilators
	$SRC/core/biriscv_lsu.v 
	$SRC/core/biriscv_mmu.v
	$SRC/core/biriscv_multiplier.v
	$SRC/core/biriscv_npc.v
	$SRC/core/biriscv_pipe_ctrl.v 
	#+define+verilator
	$SRC/core/biriscv_regfile.v
	$SRC/core/biriscv_trace_sim.v
	$SRC/core/biriscv_xilinx_2r1w.v
	$SRC/core/riscv_core.v
	
	$SRC/dcache/dcache.v
	$SRC/dcache/dcache_axi.v
	$SRC/dcache/dcache_axi_axi.v
	$SRC/dcache/dcache_core.v
	$SRC/dcache/dcache_core_data_ram.v
	$SRC/dcache/dcache_core_tag_ram.v
	$SRC/dcache/dcache_if_pmem.v
	$SRC/dcache/dcache_mux.v
	$SRC/dcache/dcache_pmem_mux.v


	$SRC/icache/icache.v
	$SRC/icache/icache_data_ram.v
	$SRC/icache/icache_tag_ram.v

	$SRC/tcm/dport_axi.sv
	$SRC/tcm/dport_mux.sv +define+Sim
	$SRC/tcm/tcm_mem.sv
	$SRC/tcm/tcm_mem_ram.sv
	$SRC/tcm/tcm_mem_pmem.sv
	
	$SRC/mtimer/mtimer.sv
	
	$SRC/top/riscv_tcm_top.sv  +define+Sim
	$SRC/top/riscv_top.v
	
	$SRC/tb/UART_emu.sv +define+Sim
	$SRC/tb/biriscv_sys_tb.sv


	
#FPGA base system
	#$PRF/ram/ram_1p.sv
	#$PRF/ram/rom_1p.sv 
	#$PRF/bus_mux/bus_mux.sv
	
	#$PRF/peripherial/IOmodule/IOmodule.sv
	#$PRF/peripherial/uart_module/UART.sv +define+Sim
	#$PRF/peripherial/uart_module/asinhFIFOa_sim.sv
	#$PRF/peripherial/Timer/Timer.sv
	#$PRF/peripherial/BootLoader/BootLoader.sv
	#$PRF/peripherial/BootLoader/BootLoader_tb.sv
	#$PRF/peripherial/LED8x4/LED8x8.sv
	#$PRF/peripherial/LED8x4/LED8x4.sv
	
	#$PRF/cv32e40p_sys.sv 
	#$PRF/tb/cv32e40p_sys_tb.sv 
	
	$VIVpr/biriscv_sys_atrix7.sv +define+Sim
	
	#$QUApr/cv32e40p_sys_cycloneIV.sv
	
#XILINX simulation lib
	$VIVpr/biriscv-master.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0_stub.v
	#$VIVpr/biriscv-master.srcs/sources_1/ip/FIFOa/FIFOa_stub.v
	$VIVpr/biriscv-master.ip_user_files/ipstatic/simulation/blk_mem_gen_v8_4.v
	$VIVpr/biriscv-master.ip_user_files/ipstatic/simulation/fifo_generator_vlog_beh.v	
	
	#vcom -O0 +acc ../Viv_pr/biriscv-master.srcs/sources_1/ip/blk_mem_gen_0/synth/blk_mem_gen_0.vhd	
	#vcom -O0 +acc ../Viv_pr/biriscv-master.srcs/sources_1/ip/FIFOa/synth/FIFOa.vhd
	
"

alias s "
	#vopt +acc -novopt -O0 work.biriscv_sys_atrix7	-o biriscv_sys_atrix7_opt
	#vsim  work.biriscv_sys_atrix7_opt -t 1ps 
	
	vopt +acc -novopt -O0 work.biriscv_sys_tb -o biriscv_sys_tb_opt
	vsim  work.biriscv_sys_tb_opt -t 1ps 
	
	do wave.do
	
	run 1 us
	wave zoom full
"

