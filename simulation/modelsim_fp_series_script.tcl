vlib work

vlog ../float_series_add_tb.v ../../fp_series_add.v ../../float_add.v

vsim -novopt -c -t 1ps -L cycloneive_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate_ver -L altera_lnsim_ver work.test_fp_series_add -voptargs="+acc"

add wave sim:/test_fp_series_add/*

run -all

wave zoom full
