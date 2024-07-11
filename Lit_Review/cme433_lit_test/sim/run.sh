source ./compile_designs.sh

# vopt -work work tb_fullmnist -o tb_fullmnist_$1_opt

# vsim -c "+V=$1" tb_fullmnist_$1_opt -do "run -all"


set tbench_top = tbench_top
# set vlog_args = script/lab1.f
# set vsim_do = script/lab1.do

if (! -e work) then
    echo "CME435: Creating work library..."
    vlib work
endif

# echo "CME435: Compiling..."
# vlog -f $vlog_args

# echo "CME435: Running simulation..."

# echo "CME435: Testbench top is \ '$tbench_top\'"
vsim -c $tbench_top -do "run -all"
