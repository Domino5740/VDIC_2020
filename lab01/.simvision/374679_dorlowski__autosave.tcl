
# XM-Sim Command File
# TOOL:	xmsim	19.09-s003
#

set tcl_prompt1 {puts -nonewline "xcelium> "}
set tcl_prompt2 {puts -nonewline "> "}
set vlog_format %h
set vhdl_format %v
set real_precision 6
set display_unit auto
set time_unit module
set heap_garbage_size -200
set heap_garbage_time 0
set assert_report_level note
set assert_stop_level error
set autoscope yes
set assert_1164_warnings yes
set pack_assert_off {}
set severity_pack_assert_off {note warning}
set assert_output_stop_level failed
set tcl_debug_level 0
set relax_path_name 1
set vhdl_vcdmap XX01ZX01X
set intovf_severity_level ERROR
set probe_screen_format 0
set rangecnst_severity_level ERROR
set textio_severity_level ERROR
set vital_timing_checks_on 1
set vlog_code_show_force 0
set assert_count_attempts 1
set tcl_all64 false
set tcl_runerror_exit false
set assert_report_incompletes 0
set show_force 1
set force_reset_by_reinvoke 0
set tcl_relaxed_literal 0
set probe_exclude_patterns {}
set probe_packed_limit 4k
set probe_unpacked_limit 16k
set assert_internal_msg no
set svseed 1
set assert_reporting_mode 0
alias . run
alias quit exit
database -open -shm -into waves.shm waves -default
probe -create -database waves top_TB.scoreboard.A_data top_TB.scoreboard.B_data top_TB.scoreboard.calculated_4b_CRC top_TB.scoreboard.carry top_TB.scoreboard.data_error top_TB.scoreboard.expected_3b_CRC top_TB.scoreboard.expected_C_data top_TB.scoreboard.expected_alu_flags top_TB.scoreboard.expected_err_flags top_TB.scoreboard.expected_parity_bit top_TB.scoreboard.fail top_TB.scoreboard.opcode top_TB.scoreboard.overflow top_TB.scoreboard.received_3b_CRC top_TB.scoreboard.received_C_data top_TB.scoreboard.received_alu_flags top_TB.scoreboard.received_err_flags top_TB.scoreboard.received_parity_bit top_TB.scoreboard.sent_4b_CRC top_TB.A_data top_TB.B_data top_TB.rst_n top_TB.sin top_TB.get_op.get_op top_TB.get_opcode.get_opcode top_TB.crc_4b

simvision -input /home/student/dorlowski/VDIC/lab01/.simvision/374679_dorlowski__autosave.tcl.svcf
