onerror {exit -code 1}
vlib work
vlog -work work hmc830.vo
vlog -work work Waveform.vwf.vt
vsim -novopt -c -t 1ps -L cyclonev_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.hmc830_vlg_vec_tst -voptargs="+acc"
vcd file -direction hmc830.msim.vcd
vcd add -internal hmc830_vlg_vec_tst/*
vcd add -internal hmc830_vlg_vec_tst/i1/*
run -all
quit -f
