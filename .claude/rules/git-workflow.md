# Git Workflow

Loaded in every session. Partly enforced by `.claude/settings.json` (permission rules) and `.claude/hooks/guard-git.sh`; the rules below apply even where no technical control exists.

## Branching (GitHub Flow)

- `main` is the stable branch. Never work, commit, force-push or rewrite history on `main`.
- Branch names: `feature/`, `fix/`, `refactor/`, `test/`, `docs/` or `chore/` plus a lowercase kebab-case description (e.g. `feature/dashboard-layout`, `fix/dashboard-overflow`). Avoid generic names (`changes`, `updates`, `new-feature`).
- Before editing: check the current branch and `git status`; use `git diff` when relevant. Identify which changes belong to the task.
- Do not switch branches when it could overwrite changes. Do not create branches when the user asked for analysis only.

## Preserving work

- Never discard, overwrite or reformat unrelated or uncommitted changes. Report unexpected modifications or conflicts.
- Coordinate before touching files owned by another in-flight task. Parallel implementation uses separate worktrees; never assume agents have isolated filesystems.

## Commits

- Only with explicit user authorization.
- Conventional Commits: `<type>(<scope>): <description>` with types `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `perf`, `build`, `ci`. Describe what changed (e.g. `fix(finance): correct budget calculation`); never `update`, `changes`, `fix stuff`.
- Stage only task-related files; never `git add -A` in a tree with unrelated changes. Review the staged diff. No secrets, credentials, temporary or debug files.

## Pull requests and merging

- Integrate through focused PRs containing: objective, summary of changes, screenshots for UI changes, tests executed, known limitations, related issues.
- Before merge: required checks pass, blocking review findings are resolved, architecture stays consistent, important behavior is tested, no secrets. Passing tests alone is not approval.
- Only the project owner approves merges into `main`. Never merge automatically, force-merge, bypass checks or disable branch protections.
- Conflicts: inspect both versions, preserve the valid intent of each, ask when unclear, rerun tests. Never accept one side blindly.

## Dependencies, refactoring and CI

- `pubspec.yaml` changes must be reviewable: explain the dependency, verify compatibility, run resolution, commit the updated `pubspec.lock`, run tests. Do not update unrelated dependencies.
- Refactoring preserves behavior unless requested, stays separate from feature work, and never happens broadly inside a small fix.
- Do not modify CI configuration without authorization or disable failing checks to merge.

## Destructive operations

Require explicit authorization after inspecting the exact targets: `git reset --hard`, destructive `git clean`, `git push --force`, `git branch -D`, deleting remote branches, rewriting published history, discarding uncommitted changes. Prefer recoverable approaches. The guard hook blocks these; if the user authorizes one, they run it themselves with `!`.

## Generated files

Follow `.gitignore`. Do not commit build outputs, caches, IDE temp files, local credentials or logs. Some generated files are required (e.g. `pubspec.lock`, `ios/Podfile.lock` for this app); do not assume every generated file is ignorable.
