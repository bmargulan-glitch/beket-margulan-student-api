#!/bin/bash
# Part 1 demonstration — run from the project root:  bash scripts/part1_linux_demo.sh
# Shows every step of Tasks 1.1–1.4 with the commands being executed.

cd "$(dirname "$0")/.." || exit 1
SCRIPT=scripts/Beket_Margulan_system_report.sh
LOG=logs/Beket_Margulan_system_report.log

step() { echo; echo "### $*"; }
run()  { echo "\$ $*"; eval "$@"; }

step "Task 1.1 — project structure"
run "mkdir -p scripts logs backups src"
run "touch $LOG"
run "pwd"
if command -v tree > /dev/null; then
    run "tree -a -L 2 -I '.git|.gradle|build'"
else
    run "find . -maxdepth 2 -not -path './.git*' -not -path './build*' | sort"
fi
for f in Dockerfile docker-compose.yml Jenkinsfile build.gradle README.md $SCRIPT $LOG; do
    [ -e "$f" ] && echo "OK      $f" || echo "MISSING $f"
done

step "Task 1.2 — run the system report"
run "bash $SCRIPT > /dev/null"
echo "(full report is in $LOG)"

step "Task 1.3 — permissions and backup"
run "chmod 744 $SCRIPT"          # rwx for owner, r-- for group, r-- for others
run "ls -l $SCRIPT"
run "cp README.md backups/README_Beket_Margulan_backup.md"
run "ls -l backups/"
run "diff README.md backups/README_Beket_Margulan_backup.md && echo 'Backup is identical to README.md'"
run "head -5 backups/README_Beket_Margulan_backup.md"

step "Task 1.4 — processes and log analysis"
run "ps aux | head -5"
echo "\$ ps aux | grep -i [j]ava"
ps aux | grep -i [j]ava | cut -c1-160 | grep . || echo "No Java process is running right now"
run "tail -n 5 $LOG"
run "grep -n 'Beket' $LOG > logs/Beket_Margulan_log_analysis.txt"
run "cat logs/Beket_Margulan_log_analysis.txt"
echo
echo ">  overwrites a file (old content is lost)"
echo ">> appends to the end of a file (old content stays)"
