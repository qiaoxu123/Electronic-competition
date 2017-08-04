transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+H:/FPGA/Project1_2016/Bit_sync/HDL {H:/FPGA/Project1_2016/Bit_sync/HDL/M_Receive.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/Project1_2016/Bit_sync/HDL {H:/FPGA/Project1_2016/Bit_sync/HDL/Bit_sync.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/Project1_2016/Bit_sync/HDL {H:/FPGA/Project1_2016/Bit_sync/HDL/sync_signal_collect.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/Project1_2016/Bit_sync/HDL {H:/FPGA/Project1_2016/Bit_sync/HDL/freq_smg.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/Project1_2016/Bit_sync/HDL {H:/FPGA/Project1_2016/Bit_sync/HDL/bin_2_bcd.v}

vlog -vlog01compat -work work +incdir+H:/FPGA/Project1_2016/Bit_sync/Pro/../Testbench {H:/FPGA/Project1_2016/Bit_sync/Pro/../Testbench/Bit_sync_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  Bit_sync_tb

add wave *
view structure
view signals
run -all
