#!/usr/bin/env bash
# PreToolUse hook (Edit|Write|NotebookEdit) declared in myos-flutter-qa frontmatter.
# QA may only modify files under test/ or integration_test/ inside the project.
# Files outside the project (scratch files) are allowed. Exit 2 = block.

set -u

input=$(cat)
path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // .tool_input.notebook_path // empty' 2>/dev/null)
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null)
project=${CLAUDE_PROJECT_DIR:-${cwd:-$PWD}}

[ -z "$path" ] && exit 0
[[ "$path" != /* ]] && path="${cwd:-$PWD}/$path"

# Normalize the project prefix (resolve symlinks such as /private on macOS).
project_real=$(cd "$project" 2>/dev/null && pwd -P || echo "$project")
dir_real=$(cd "$(dirname "$path")" 2>/dev/null && pwd -P || dirname "$path")
real="$dir_real/$(basename "$path")"

case "$real" in
  "$project_real"/test/*|"$project_real"/integration_test/*) exit 0 ;;
  "$project_real"/*)
    rel=${real#"$project_real"/}
    echo "Blocked by .claude/hooks/qa-test-paths-only.sh: myos-flutter-qa may only modify files under test/ or integration_test/ (attempted: $rel). Report the defect instead of changing production code." >&2
    exit 2
    ;;
  *) exit 0 ;;
esac
