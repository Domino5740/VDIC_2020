# tested with XCELIUM 18.09

# Commmand arguments:
# -g option starts xrun simulation with gui, with separate database

# To set the paths for xrun and imc, execute the following command in the terminal:
# source /cad/env/cadence_path.XCELIUM1909

# Help library if available with command:
# cdnshelp &

#------------------------------------------------------------------------------
# The list of tests; in GUI mode only the first test is started.
TESTS=(lab02_2A);
#------------------------------------------------------------------------------
# MAIN
function main(){
  xrun_compile
  xrun_elaborate
  xrun_run_all_tests
}
#------------------------------------------------------------------------------
# local variables#<<<
INCA="INCA_libs"
GUI=""
#>>>
#------------------------------------------------------------------------------
# check input script arguments#<<<
while getopts gh option
  do case "${option}" in
    g) GUI="+access+r +gui"; INCA="${INCA}_gui";;
    *) echo "The only valid option is -g (for GUI)"; exit -1 ;;
  esac
done
#>>>
#------------------------------------------------------------------------------
# init #<<<
rm -rf $INCA      # remove previous database
cols=`tput cols`
separator=`perl -e "print \"#\" x $cols"`
#>>>
#------------------------------------------------------------------------------
# simulator arguments #<<<
XRUN_ARGS="\
  ./shapes.sv \
  -v93 \
  +nowarnDSEM2009 \
  +nowarnDSEMEL \
  +nowarnCGDEFN \
  -xmlibdirname $INCA \
  $GUI \
  +overwrite \
  -nocopyright \
"
#>>>
#------------------------------------------------------------------------------
# PROCEDURES
#------------------------------------------------------------------------------
function xrun_info() { #<<<
  # Prints string between separators
  # args: string
  echo $separator
  echo "$*"
  echo $separator
  return 0
} #>>>
#------------------------------------------------------------------------------
function xrun_check_status() { #<<<
  # Checks the status of the action;
  # args: int (status), string (action name)

  status=$1
  action=$2

  if [[ "$status" != "0" ]]; then
    echo "$action failed with status $status".
    exit -1
  fi
  echo $action finished with status 0.
  return 0
} #>>>
#------------------------------------------------------------------------------
function xrun_compile() { #<<<
  xrun_info "# Compiling. Log saved to xrun_compile.log"
  xrun -compile -l xrun_compile.log $XRUN_ARGS 
  xrun_check_status $? "Compilation"
} #>>>
#------------------------------------------------------------------------------
function xrun_elaborate() { #<<<
  xrun_info "# Elaborating. Log saved to xrun_elaborate.log"
  xrun -elaborate  -l xrun_elaborate.log $XRUN_ARGS
  xrun_check_status $? "Elaboration"
} #>>>
#------------------------------------------------------------------------------
function xrun_run_all_tests() { #<<<
  if [[ "$GUI" != "" ]] ; then
      xrun $XRUN_ARGS \
        -l xrun_gui.log
  else  
    TEST_LIST=""

    for TEST in ${TESTS[@]} ; do
      TEST_LIST="$TEST_LIST $TEST"
      xrun_info "# Running test: $TEST. Log saved to xrun_test_$TEST.log"
      # run the simulation
      xrun $XRUN_ARGS \
        -l xrun_test_$TEST.log
      xrun_check_status $? "Test $TEST"
    done

    echo "# End of tests."
  fi
} #>>>
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
# run the main
main
# vim: fdm=marker foldmarker=<<<\,>>>
