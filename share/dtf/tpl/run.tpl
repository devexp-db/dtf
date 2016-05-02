# Template for DTF's 'run' wrapper.
# Copyright (C) 2015 Red Hat, Inc.
# Written by Pavel Raiskup.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

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

test -f "$srcdir"/testcase && {
  __dtf_control_msg_n " $testname"
  __dtf_run_testcase "$SHELL" "$srcdir"/testcase
  case $__save_rc in
    77)
        msg=' -> SKIP'
        ;;
    0)
        msg=' -> OK'
        ;;
    *)
        msg=' -> FAIL'
        ;;
  esac

  esr_file=.dtf/exit_status_reason
  esr=`test -f "$esr_file" 2>/dev/null && cat "$esr_file"`
  test -n "$esr" && msg="$msg: $esr"
  __dtf_control_msg "$msg"
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
