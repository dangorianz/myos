#!/usr/bin/env bash
# PreToolUse hook (Bash) for MyOS.
# Blocks destructive git operations and history-changing operations on main.
# Exit 2 = block (stderr is shown to Claude). Exit 0 = no objection (normal permission rules still apply).
# Word splitting is approximate (quotes are not parsed); it errs toward blocking.

set -u

input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null)
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null)
[ -z "$cmd" ] && exit 0
[ -z "$cwd" ] && cwd=$PWD

case "$cmd" in
  *git*) ;;
  *) exit 0 ;;
esac

block() {
  echo "Blocked by .claude/hooks/guard-git.sh: $1. See .claude/rules/git-workflow.md. If the user explicitly authorizes it, they can run it themselves with '!'." >&2
  exit 2
}

# Split compound commands into segments.
segments=$(printf '%s\n' "$cmd" | tr '&|;()' '\n\n\n\n\n')

while IFS= read -r seg; do
  read -r -a w <<< "$seg" || true
  n=${#w[@]}
  i=0
  # Locate the git executable within the segment (skips env assignments, sudo, etc.).
  while [ $i -lt $n ] && [ "${w[$i]}" != "git" ] && [[ "${w[$i]}" != */git ]]; do i=$((i+1)); done
  [ $i -ge $n ] && continue
  i=$((i+1))

  # Skip git global options to find the subcommand.
  repo_dir=$cwd
  while [ $i -lt $n ]; do
    case "${w[$i]}" in
      -C) repo_dir="${w[$((i+1))]:-$cwd}"; [[ "$repo_dir" != /* ]] && repo_dir="$cwd/$repo_dir"; i=$((i+2)) ;;
      -c|--git-dir|--work-tree|--namespace) i=$((i+2)) ;;
      -*) i=$((i+1)) ;;
      *) break ;;
    esac
  done
  [ $i -ge $n ] && continue
  sub=${w[$i]}
  args=("${w[@]:$((i+1))}")
  argstr=" ${args[*]:-} "

  branch=$(git -C "$repo_dir" branch --show-current 2>/dev/null || true)

  case "$sub" in
    push)
      [[ "$argstr" =~ [[:space:]](--force|--force-with-lease[^[:space:]]*|--force-if-includes|-f|--mirror|--delete|-d|--prune)[[:space:]] ]] && block "force push, mirror or remote deletion"
      for a in "${args[@]:-}"; do
        case "$a" in
          +*|:*) block "force or delete refspec ('$a')" ;;
          main|*:main|refs/heads/main|*:refs/heads/main) block "pushing to main (integrate through a pull request)" ;;
        esac
      done
      [ "$branch" = "main" ] && block "pushing from main (work on a feature branch)"
      ;;
    reset)
      [[ "$argstr" =~ [[:space:]](--hard|--merge|--keep)[[:space:]] ]] && block "git reset --hard/--merge/--keep discards work"
      ;;
    clean)
      for a in "${args[@]:-}"; do
        [[ "$a" =~ ^-[a-zA-Z]*f ]] || [ "$a" = "--force" ] && block "destructive git clean"
      done
      ;;
    branch)
      for a in "${args[@]:-}"; do
        [[ "$a" =~ ^-[a-zA-Z]*D ]] && block "git branch -D (force delete)"
      done
      [[ "$argstr" =~ [[:space:]](--delete|-d)[[:space:]] ]] && [[ "$argstr" =~ [[:space:]](--force|-f)[[:space:]] ]] && block "forced branch deletion"
      ;;
    filter-repo|filter-branch|replace)
      block "history rewriting ($sub)"
      ;;
    checkout)
      [[ "$argstr" =~ [[:space:]](-f|--force|--|\.|:/)[[:space:]] ]] && block "discarding working-tree changes (checkout)"
      ;;
    restore)
      # Only unstaging (--staged without --worktree) is safe.
      if ! { [[ "$argstr" =~ [[:space:]](--staged|-S)[[:space:]] ]] && ! [[ "$argstr" =~ [[:space:]](--worktree|-W)[[:space:]] ]]; }; then
        block "discarding working-tree changes (restore)"
      fi
      ;;
    switch)
      [[ "$argstr" =~ [[:space:]](-f|--force|--discard-changes)[[:space:]] ]] && block "discarding working-tree changes (switch --discard-changes)"
      ;;
    stash)
      [[ "$argstr" =~ [[:space:]](clear|drop)[[:space:]] ]] && block "deleting stashed work"
      ;;
    update-ref)
      block "low-level ref rewriting (update-ref)"
      ;;
  esac

  case "$sub" in
    commit|merge|rebase|cherry-pick|revert|am|pull)
      [ "$branch" = "main" ] && block "'git $sub' on main (create a feature/fix/... branch first)"
      ;;
  esac
done <<< "$segments"

exit 0
