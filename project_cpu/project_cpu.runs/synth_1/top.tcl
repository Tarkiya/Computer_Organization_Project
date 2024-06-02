# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param xicom.use_bs_reader 1
create_project -in_memory -part xc7a35tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir C:/Users/yjc/OneDrive/Desktop/csprojects/cpu/Computer_Organization_Project/project_cpu/project_cpu.cache/wt [current_project]
set_property parent.project_path C:/Users/yjc/OneDrive/Desktop/csprojects/cpu/Computer_Organization_Project/project_cpu/project_cpu.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo c:/Users/yjc/OneDrive/Desktop/csprojects/cpu/Computer_Organization_Project/project_cpu/project_cpu.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files C:/Users/yjc/OneDrive/Desktop/csprojects/cpu/Computer_Organization_Project/project_cpu/prgmip32.coe
read_verilog -library xil_defaultlib {
  C:/Users/yjc/OneDrive/Desktop/csprojects/cpu/Computer_Organization_Project/project_cpu/project_cpu.srcs/sources_1/new/ALU.v
  C:/Users/yjc/OneDrive/Desktop/csprojects/cpu/Computer_Organization_Project/project_cpu/project_cpu.srcs/sources_1/new/Decoder.v
  C:/Users/yjc/OneDrive/Desktop/csprojects/cpu/Computer_Organization_Project/project_cpu/project_cpu.srcs/sources_1/new/IFetch.v
  C:/Users/yjc/OneDrive/Desktop/csprojects/cpu/Computer_Organization_Project/project_cpu/project_cpu.srcs/sources_1/new/MemOrIO.v
  C:/Users/yjc/OneDrive/Desktop/csprojects/cpu/Computer_Organization_Project/project_cpu/project_cpu.srcs/sources_1/new/clock_div.v
  C:/Users/yjc/OneDrive/Desktop/csprojects/cpu/Computer_Organization_Project/project_cpu/project_cpu.srcs/sources_1/new/control.v
  C:/Users/yjc/OneDrive/Desktop/csprojects/cpu/Computer_Organization_Project/project_cpu/project_cpu.srcs/sources_1/new/debouncer.v
  C:/Users/yjc/OneDrive/Desktop/csprojects/cpu/Computer_Organization_Project/project_cpu/project_cpu.srcs/sources_1/new/led.v
  C:/Users/yjc/OneDrive/Desktop/csprojects/cpu/Computer_Organization_Project/project_cpu/project_cpu.srcs/sources_1/new/m_data.v
  C:/Users/yjc/OneDrive/Desktop/csprojects/cpu/Computer_Organization_Project/project_cpu/project_cpu.srcs/sources_1/new/seg.v
  C:/Users/yjc/OneDrive/Desktop/csprojects/cpu/Computer_Organization_Project/project_cpu/project_cpu.srcs/sources_1/new/switch.v
  C:/Users/yjc/OneDrive/Desktop/csprojects/cpu/Computer_Organization_Project/project_cpu/project_cpu.srcs/sources_1/new/top.v
}
read_ip -quiet C:/Users/yjc/OneDrive/Desktop/csprojects/cpu/Computer_Organization_Project/project_cpu/project_cpu.srcs/sources_1/ip/clock_cpu/clock_cpu.xci
set_property used_in_implementation false [get_files -all c:/Users/yjc/OneDrive/Desktop/csprojects/cpu/Computer_Organization_Project/project_cpu/project_cpu.srcs/sources_1/ip/clock_cpu/clock_cpu_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/yjc/OneDrive/Desktop/csprojects/cpu/Computer_Organization_Project/project_cpu/project_cpu.srcs/sources_1/ip/clock_cpu/clock_cpu.xdc]
set_property used_in_implementation false [get_files -all c:/Users/yjc/OneDrive/Desktop/csprojects/cpu/Computer_Organization_Project/project_cpu/project_cpu.srcs/sources_1/ip/clock_cpu/clock_cpu_ooc.xdc]

read_ip -quiet C:/Users/yjc/OneDrive/Desktop/csprojects/cpu/Computer_Organization_Project/project_cpu/project_cpu.srcs/sources_1/ip/inst_memory/inst_memory.xci
set_property used_in_implementation false [get_files -all c:/Users/yjc/OneDrive/Desktop/csprojects/cpu/Computer_Organization_Project/project_cpu/project_cpu.srcs/sources_1/ip/inst_memory/inst_memory_ooc.xdc]

read_ip -quiet C:/Users/yjc/OneDrive/Desktop/csprojects/cpu/Computer_Organization_Project/project_cpu/project_cpu.srcs/sources_1/ip/data_memory/data_memory.xci
set_property used_in_implementation false [get_files -all c:/Users/yjc/OneDrive/Desktop/csprojects/cpu/Computer_Organization_Project/project_cpu/project_cpu.srcs/sources_1/ip/data_memory/data_memory_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/yjc/OneDrive/Desktop/csprojects/cpu/Computer_Organization_Project/project_cpu/project_cpu.srcs/constrs_1/new/constr.xdc
set_property used_in_implementation false [get_files C:/Users/yjc/OneDrive/Desktop/csprojects/cpu/Computer_Organization_Project/project_cpu/project_cpu.srcs/constrs_1/new/constr.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]

synth_design -top top -part xc7a35tcsg324-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef top.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file top_utilization_synth.rpt -pb top_utilization_synth.pb"
