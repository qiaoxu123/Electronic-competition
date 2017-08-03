transcript on
if ![file isdirectory pro_nios_iputf_libs] {
	file mkdir pro_nios_iputf_libs
}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

###### Libraries for IPUTF cores 
###### End libraries for IPUTF cores 
###### MIF file copy and HDL compilation commands for IPUTF cores 


vlog "E:/DE1-SOC/class10-Digital_Freq/pll_100M_sim/pll_100M.vo"

vlog -vlog01compat -work work +incdir+E:/DE1-SOC/class10-Digital_Freq {E:/DE1-SOC/class10-Digital_Freq/Digital_Freq_top.v}
vlog -vlog01compat -work work +incdir+E:/DE1-SOC/class10-Digital_Freq {E:/DE1-SOC/class10-Digital_Freq/Duty_Cycle.v}
vlog -vlog01compat -work work +incdir+E:/DE1-SOC/class10-Digital_Freq {E:/DE1-SOC/class10-Digital_Freq/Freq_check.v}
vlog -vlog01compat -work work +incdir+E:/DE1-SOC/class10-Digital_Freq {E:/DE1-SOC/class10-Digital_Freq/Time_period_check.v}

vlog -vlog01compat -work work +incdir+E:/DE1-SOC/class10-Digital_Freq {E:/DE1-SOC/class10-Digital_Freq/Digital_Freq_top_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  Digital_Freq_top_tb

add wave *
view structure
view signals
run -all
