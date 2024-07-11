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
set top_module = log_multiplier_tb
set vlog_args = script/tut.f
set vsim_do = script/tut_sim.do

# vlog commands
echo CME435\: Compiling...
vlog -f $vlog_args

# vsim command here
echo CME435\: Running simulation...
vsim -voptargs=+acc $top_module
