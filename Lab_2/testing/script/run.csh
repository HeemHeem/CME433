#!/bin/csh

#source /CMC/scripts/mentor.questasim.mentor.questasim.2019.2.csh
source /CMC/scripts/mentor.questasim.2020.1_1.csh

set tbench_top = testbench_CLA
#set tbench_top = testbench_ripple
set vlog_args = script/lab2.f
set vsim_do = script/lab2.do

if (! -e work) then
    echo "CME433: Creating work library..."
    vlib work
endif

echo "CME433: Compiling..."
vlog -f $vlog_args

echo "CME433: Running simulation..."

echo "CME433: Testbench top is \ '$tbench_top\'"
vsim -voptargs=+acc $tbench_top
