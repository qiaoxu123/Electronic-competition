transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/2017diansai/2003/program {E:/2017diansai/2003/program/sin_rom.v}
vlog -vlog01compat -work work +incdir+E:/2017diansai/2003/program {E:/2017diansai/2003/program/iss_1.v}
vlog -vlog01compat -work work +incdir+E:/2017diansai/2003/program {E:/2017diansai/2003/program/div_48_32.v}
vlog -vlog01compat -work work +incdir+E:/2017diansai/2003/program {E:/2017diansai/2003/program/div_28_9.v}
vlog -vlog01compat -work work +incdir+E:/2017diansai/2003/program {E:/2017diansai/2003/program/pro_2003.v}
vlog -vlog01compat -work work +incdir+E:/2017diansai/2003/program {E:/2017diansai/2003/program/dds.v}
vlog -vlog01compat -work work +incdir+E:/2017diansai/2003/program {E:/2017diansai/2003/program/key_control.v}
vlog -vlog01compat -work work +incdir+E:/2017diansai/2003/program {E:/2017diansai/2003/program/tx.v}
vlog -vlog01compat -work work +incdir+E:/2017diansai/2003/program {E:/2017diansai/2003/program/rx.v}

vlog -vlog01compat -work work +incdir+E:/2017diansai/2003/program {E:/2017diansai/2003/program/tb_2003.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb_2003

add wave *
view structure
view signals
run -all
