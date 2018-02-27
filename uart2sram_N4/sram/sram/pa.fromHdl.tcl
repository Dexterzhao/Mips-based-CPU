
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name sram -dir "F:/ISE/work/sram/sram/planAhead_run_1" -part xc6slx45csg484-3
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "SRAM_realmodetest.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {SRAM.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {Anvyl_DISP.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {SRAM_realmodetest.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set_property top SRAM_realmodetest $srcset
add_files [list {SRAM_realmodetest.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc6slx45csg484-3
