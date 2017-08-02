transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/2017diansai/2003_luojifenxiyi/program/program2 {E:/2017diansai/2003_luojifenxiyi/program/program2/key_control.v}
vlog -vlog01compat -work work +incdir+E:/2017diansai/2003_luojifenxiyi/program/program2 {E:/2017diansai/2003_luojifenxiyi/program/program2/three_chufa.v}
vlog -vlog01compat -work work +incdir+E:/2017diansai/2003_luojifenxiyi/program/program2 {E:/2017diansai/2003_luojifenxiyi/program/program2/key_board.v}
vlog -vlog01compat -work work +incdir+E:/2017diansai/2003_luojifenxiyi/program/program2 {E:/2017diansai/2003_luojifenxiyi/program/program2/single_chufa.v}
vlog -vlog01compat -work work +incdir+E:/2017diansai/2003_luojifenxiyi/program/program2 {E:/2017diansai/2003_luojifenxiyi/program/program2/shift_sig.v}
vlog -vlog01compat -work work +incdir+E:/2017diansai/2003_luojifenxiyi/program/program2 {E:/2017diansai/2003_luojifenxiyi/program/program2/pro_2003.v}
vlog -vlog01compat -work work +incdir+E:/2017diansai/2003_luojifenxiyi/program/program2 {E:/2017diansai/2003_luojifenxiyi/program/program2/ram_logic.v}

vlog -vlog01compat -work work +incdir+E:/2017diansai/2003_luojifenxiyi/program/program2 {E:/2017diansai/2003_luojifenxiyi/program/program2/tb_2003.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb_2003

add wave *
view structure
view signals
run -all
