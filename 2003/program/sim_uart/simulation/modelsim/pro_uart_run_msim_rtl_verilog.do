transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/2017diansai/2003/program/sim_uart {E:/2017diansai/2003/program/sim_uart/div_32_32.v}
vlog -vlog01compat -work work +incdir+E:/2017diansai/2003/program/sim_uart {E:/2017diansai/2003/program/sim_uart/pro_uart.v}

vlog -vlog01compat -work work +incdir+E:/2017diansai/2003/program/sim_uart {E:/2017diansai/2003/program/sim_uart/tb_uart.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb_uart

add wave *
view structure
view signals
run -all
