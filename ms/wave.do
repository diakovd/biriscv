onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider AXI-bus
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/Clk
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/rst
add wave -noupdate -divider {mem_d rd}
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/mem_d_data_rd_i
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/mem_d_ack_i
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/mem_d_rd_o
add wave -noupdate -divider {mem_d wr}
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/mem_d_addr_o
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/mem_d_data_wr_o
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/mem_d_wr_o
add wave -noupdate -divider {mem_d ctr}
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/mem_d_accept_i
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/mem_d_error_i
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/mem_d_resp_tag_i
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/mem_d_cacheable_o
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/u_lsu/mem_cacheable_o
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/u_lsu/mem_cacheable_q
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/u_lsu/dcache_invalidate_w
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/u_lsu/dcache_writeback_w
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/u_lsu/dcache_flush_w
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/u_lsu/opcode_valid_i
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/u_lsu/mem_accept_i
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/u_lsu/mem_flush_o
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/u_lsu/mem_rd_o
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/u_lsu/mem_writeback_o
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/u_lsu/mem_wr_o
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/u_lsu/mem_rd_q
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/u_lsu/mem_wr_q
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/u_lsu/mem_unaligned_e1_q
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/u_lsu/mem_invalidate_o
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/u_lsu/delay_lsu_e2_w
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/mem_d_req_tag_o
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/mem_d_invalidate_o
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/mem_d_writeback_o
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/mem_d_flush_o
add wave -noupdate -divider mem_i
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/mem_i_accept_i
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/mem_i_valid_i
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/mem_i_error_i
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/mem_i_inst_i
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/mem_i_rd_o
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/mem_i_flush_o
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/mem_i_invalidate_o
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/mem_i_pc_o
add wave -noupdate -divider Mem
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_tcm/u_ram/addr0_i
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_tcm/u_ram/data0_i
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_tcm/u_ram/wr0_i
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_tcm/u_ram/clk1_i
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_tcm/u_ram/rst1_i
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_tcm/u_ram/addr1_i
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_tcm/u_ram/data1_i
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_tcm/u_ram/wr1_i
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_tcm/u_ram/data0_o
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_tcm/u_ram/data1_o
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_tcm/u_ram/ram_read0_q
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_tcm/u_ram/ram_read1_q
add wave -noupdate -divider {New Divider}
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/u_csr/u_csrfile/csr_branch_o
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/u_csr/u_csrfile/csr_target_o
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/u_csr/u_csrfile/csr_mip_q
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/u_csr/u_csrfile/csr_mtvec_r
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/u_csr/u_csrfile/csr_mideleg_q
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/u_csr/u_csrfile/csr_medeleg_q
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/u_csr/u_csrfile/csr_mip_next_r
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/u_csr/u_csrfile/irq_pending_r
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/u_csr/u_csrfile/csr_mip_r
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/u_csr/u_csrfile/csr_mie_q
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/Int_Timer
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/Int_UART
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/intr_i
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/u_csr/timer_irq_w
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_core/u_csr/u_csrfile/timer_intr_i
add wave -noupdate -divider AXI-bus
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_dmux/sel_vec
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_dmux/IOsel
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_dmux/UARTsel
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_dmux/TMsel
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_dmux/TM1sel
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_dmux/mem_ack_o
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_dmux/mem_tcm_accept_i
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_dmux/request_w
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_dmux/mem_accept_o
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_dmux/hold_w
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_dmux/tcm_access_w
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_dmux/tcm_access_q
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_dmux/pending_q
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_dmux/axiBus_TM/wready
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/u_dmux/axiBus_TM/rvalid
add wave -noupdate -divider UART
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/UART_inst/Clk_14MHz
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/UART_inst/TX
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/UART_inst/RX
add wave -noupdate -radix unsigned /biriscv_sys_tb/biriscv_sys_atrix7_inst/UART_inst/addr
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/UART_inst/wrdata
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/UART_inst/wr
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/UART_inst/addr_rd
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/UART_inst/axiBus/rdata
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/UART_inst/rd
add wave -noupdate -radix unsigned /biriscv_sys_tb/biriscv_sys_atrix7_inst/UART_inst/DLR
add wave -noupdate -radix hexadecimal /biriscv_sys_tb/biriscv_sys_atrix7_inst/riscv_tcm_top_inst/axiBus_UART/wdata
add wave -noupdate -expand /biriscv_sys_tb/biriscv_sys_atrix7_inst/UART_inst/FCR
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/UART_inst/RDdata
add wave -noupdate -divider UART_emu
add wave -noupdate /biriscv_sys_tb/UART_emu_inst/UART_insts/TX
add wave -noupdate /biriscv_sys_tb/UART_emu_inst/UART_insts/RX
add wave -noupdate /biriscv_sys_tb/UART_emu_inst/UART_insts/shiftIN
add wave -noupdate /biriscv_sys_tb/UART_emu_inst/UART_insts/wr_rx
add wave -noupdate /biriscv_sys_tb/UART_emu_inst/UART_insts/Int
add wave -noupdate /biriscv_sys_tb/UART_emu_inst/UART_insts/genblk2/fifo_rx_inst/rd_data_count
add wave -noupdate /biriscv_sys_tb/UART_emu_inst/UART_insts/genblk2/fifo_rx_inst/wr_data_count
add wave -noupdate /biriscv_sys_tb/UART_emu_inst/UART_insts/genblk2/fifo_rx_inst/rd_en
add wave -noupdate /biriscv_sys_tb/UART_emu_inst/UART_insts/genblk2/fifo_rx_inst/empty
add wave -noupdate /biriscv_sys_tb/UART_emu_inst/UART_insts/CPUdat/addr
add wave -noupdate /biriscv_sys_tb/UART_emu_inst/UART_insts/CPUdat/wdata
add wave -noupdate /biriscv_sys_tb/UART_emu_inst/UART_insts/CPUdat/be
add wave -noupdate /biriscv_sys_tb/UART_emu_inst/UART_insts/CPUctr/rdata
add wave -noupdate /biriscv_sys_tb/UART_emu_inst/UART_insts/CPUctr/we
add wave -noupdate /biriscv_sys_tb/UART_emu_inst/UART_insts/CPUctr/req
add wave -noupdate /biriscv_sys_tb/UART_emu_inst/UART_insts/CPUctr/rvalid
add wave -noupdate /biriscv_sys_tb/UART_emu_inst/UART_insts/CPUctr/gnt
add wave -noupdate /biriscv_sys_tb/UART_emu_inst/UART_insts/CPUctr/err
add wave -noupdate -divider mtimer
add wave -noupdate -radix hexadecimal /biriscv_sys_tb/biriscv_sys_atrix7_inst/mtimer_inst/mtime
add wave -noupdate -radix hexadecimal /biriscv_sys_tb/biriscv_sys_atrix7_inst/mtimer_inst/mtimecmp
add wave -noupdate -radix hexadecimal /biriscv_sys_tb/biriscv_sys_atrix7_inst/mtimer_inst/addr
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/mtimer_inst/addr_rd
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/mtimer_inst/rd
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/mtimer_inst/wr
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/mtimer_inst/axiBus/awaddr
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/mtimer_inst/axiBus/wdata
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/mtimer_inst/axiBus/wstrb
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/mtimer_inst/axiBus/wvalid
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/mtimer_inst/axiBus/awvalid
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/mtimer_inst/axiBus/bvalid
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/mtimer_inst/axiBus/bresp
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/mtimer_inst/axiBus/wready
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/mtimer_inst/axiBus/awready
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/mtimer_inst/axiBus/araddr
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/mtimer_inst/axiBus/arvalid
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/mtimer_inst/axiBus/bready
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/mtimer_inst/axiBus/rready
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/mtimer_inst/axiBus/rvalid
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/mtimer_inst/axiBus/rresp
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/mtimer_inst/axiBus/rdata
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/mtimer_inst/axiBus/arready
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/mtimer_inst/addrH
add wave -noupdate /biriscv_sys_tb/biriscv_sys_atrix7_inst/mtimer_inst/axiBus/IO
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {121959189 ps} 0} {{Cursor 2} {5764667953 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {107385873 ps} {246817055 ps}
