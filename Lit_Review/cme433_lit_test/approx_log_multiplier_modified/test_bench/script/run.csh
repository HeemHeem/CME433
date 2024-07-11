#!/bin/csh

#source /CMC/scripts/mentor.questasim.mentor.questasim.2019.2.csh
source /CMC/scripts/mentor.questasim.2020.1_1.csh

clear

if (-e work) then
    vdel -all
endif
echo CME435\: Creating work library...
vlib work

# Define variables
set top_module = approx_log_multiplier_modified_tb
set vlog_args = script/tut.f
set vsim_do = script/tut_sim.do

# vlog commands
echo CME435\: Compiling...
vlog -f $vlog_args ./verification/$top_module.sv
# vsim command here
echo CME435\: Running simulation...
# vsim -voptargs=+acc $top_module
vsim -c $top_module -do $vsim_do
