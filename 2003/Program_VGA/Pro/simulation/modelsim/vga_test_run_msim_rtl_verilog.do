transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/DE1-SOC/class16-VGA/RTL {E:/DE1-SOC/class16-VGA/RTL/vga_top.v}
vlog -vlog01compat -work work +incdir+E:/DE1-SOC/class16-VGA/RTL {E:/DE1-SOC/class16-VGA/RTL/vga_control.v}
vlog -vlog01compat -work work +incdir+E:/DE1-SOC/class16-VGA/RTL {E:/DE1-SOC/class16-VGA/RTL/vga_drive.v}
vlog -vlog01compat -work work +incdir+E:/DE1-SOC/class16-VGA/Pro {E:/DE1-SOC/class16-VGA/Pro/rom_word.v}

vlog -vlog01compat -work work +incdir+E:/DE1-SOC/class16-VGA/Pro {E:/DE1-SOC/class16-VGA/Pro/vga_test_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  vga_test_tb

add wave *
view structure
view signals
run -all
