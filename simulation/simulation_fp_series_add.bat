rem recreate a temp folder for all the simulation files
rd /s /q sim
md sim
cd sim

rem start the simulation
vsim -do ../modelsim_fp_series_script.tcl

rem return to the parent folder
cd ..