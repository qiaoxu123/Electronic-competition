transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+H:/FPGA/Project1_2016/M_sequence_born {H:/FPGA/Project1_2016/M_sequence_born/M_sequence.v}

vlog -vlog01compat -work work +incdir+H:/FPGA/Project1_2016/M_sequence_born {H:/FPGA/Project1_2016/M_sequence_born/M_sequence_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  M_sequence_tb

add wave *
view structure
view signals
run -all
