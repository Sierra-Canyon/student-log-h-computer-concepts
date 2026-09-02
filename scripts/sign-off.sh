#!/bin/bash -e
# Honors Software Engineering — close out today's log entry.
# Run it in the last minutes of the period, or when you stop working at home.
# It carries your task list forward so you can check things off.

# Work from the top of the repository no matter where you ran this from.
cd "$(dirname "$0")/.."

FILENAME="logs/$(date +'%Y-%m-%d').log.md"

if [ ! -f "$FILENAME" ]; then
  echo "No sign-on entry for today. Run scripts/start-entry.sh first."
  exit 1
fi

# Pull the task list out of the most recent entry so you can check items off
# instead of retyping them. Empty checkboxes are dropped.
TASKS=$(awk '/^# /{buf=""} /^- \[/{ if ($0 !~ /^- \[ \] *$/) buf=buf $0 "\n"} END{printf "%s", buf}' "$FILENAME")
[ -z "$TASKS" ] && TASKS="- [ ] "

{
  echo ""
  echo "# $(date +'%A, %B %e, %Y %I:%M %p')"
  echo ""
  printf '%s\n' "$TASKS"
  echo ""
  echo "Signing off."
  echo ""
  echo "**AI use:** [Fill this in]"
} >> "$FILENAME"

if command -v code > /dev/null; then
  code "$FILENAME"
elif command -v nano > /dev/null; then
  nano "$FILENAME"
else
  echo "Wrote $FILENAME. Open it in your editor."
fi

echo ""
echo "Check off what you finished, say in one honest word why anything is not"
echo "finished, replace the AI line if you used it, then:"
echo "    git add logs && git commit && git push"
