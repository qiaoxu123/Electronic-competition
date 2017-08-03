onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /vga_test_tb/clk
add wave -noupdate /vga_test_tb/rst_n
add wave -noupdate /vga_test_tb/vga_top/vga_control/hx
add wave -noupdate /vga_test_tb/vga_top/vga_control/vy
add wave -noupdate /vga_test_tb/vga_top/vga_control/RGB
add wave -noupdate /vga_test_tb/vga_top/vga_control/add
add wave -noupdate /vga_test_tb/vga_top/vga_control/area
add wave -noupdate /vga_test_tb/vga_top/vga_control/b
add wave -noupdate /vga_test_tb/vga_top/vga_control/g
add wave -noupdate /vga_test_tb/vga_top/vga_control/q
add wave -noupdate /vga_test_tb/vga_top/vga_control/r
add wave -noupdate /vga_test_tb/vga_top/vga_control/rom
add wave -noupdate /vga_test_tb/vga_top/vga_control/vgalive
add wave -noupdate /vga_test_tb/vga_top/vga_control/z1
add wave -noupdate /vga_test_tb/vga_top/vga_control/z2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ps} {3320 ps}
