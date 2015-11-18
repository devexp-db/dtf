#! /bin/sh
# vi: ft=sh

test -z "$outputdir" && outputdir="$PWD/DTF_RESULT"

$__DTF_TOP_TEST && {
    exec 3>&1 4>&2
    rm -rf "$outputdir"
}


. "$top_srcdir/library"

__dtf_rc=0


# Gather sub-tests.
sub_tests=
for __dtf_sub_test in "$srcdir"/*
do
  __dtf_is_testdir "$__dtf_sub_test" || continue
  sub_tests="$sub_tests
$__dtf_sub_test/run"
done

#
# Execute the testcase, when available.
#

test -f $srcdir/testcase && {
  __dtf_control_msg " $testname"
  __dtf_run_testcase "$SHELL" "$srcdir"/testcase
}

#
# Execute sub-tests.
#

if test -n "$sub_tests"; then
  __dtf_top_control_msg  "going to $testname"

  for subtest in $sub_tests
  do
    __dtf_run_testcase "$SHELL" "$subtest"
  done
  result=Ok.
  test "$__dtf_rc" -eq 0 || result=Fail.
  __dtf_top_control_msg "group $testname: $result"
fi

__dtf_toplevel_result_msg "$__dtf_rc"
exit $__dtf_rc
