onbreak {resume}

set tbench_top tbench_top

if {! [file exists work]} {
  puts "CME435: Creating work library..."
  vlib work
}

#if [file exists work] {
#  vdel -all
#}
#vlib work

puts "CME435: Compiling..."

puts "CME435: Running simulation..."
puts "CME435: Testbench top is \"$tbench_top\""
