onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib segclk_opt

do {wave.do}

view wave
view structure
view signals

do {segclk.udo}

run -all

quit -force
