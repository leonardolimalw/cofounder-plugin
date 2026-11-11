#!/usr/bin/env bash
# SessionStart hook of the cofounder plugin: does what the AGENTS.md pointer
# does for an `npx skills` install. A user-scope plugin runs in every project,
# so it only activates in an empty folder (a new project) or in a folder that
# already is a cofounder project (it has the docs the cofounder writes). It also
# stays silent when the project has the `npx skills` install, which activates
# itself through AGENTS.md.
#
# Both Claude Code and Codex run it from hooks/hooks.json. Codex sets
# PLUGIN_ROOT (and CLAUDE_PLUGIN_ROOT as an alias) but not CLAUDE_PROJECT_DIR;
# it passes the session's cwd in the JSON on stdin.
codex=""
[[ -n "${PLUGIN_ROOT:-}" ]] && codex=1

project="${CLAUDE_PROJECT_DIR:-}"
if [[ -z "$project" && -n "$codex" && ! -t 0 ]]; then
    project=$(sed -n 's/.*"cwd"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n1)
fi
project="${project:-$PWD}"

[[ -f "$project/.claude/skills/cofounder-playbook/SKILL.md" ]] && exit 0
[[ -n "$codex" && -f "$project/.agents/skills/cofounder-playbook/SKILL.md" ]] && exit 0

is_cofounder_project() {
    [[ -f "$project/docs/PRD.md" || -f "$project/docs/INFRASTRUCTURE.md" ]] && return 0
    local item
    for item in "$project"/* "$project"/.[!.]* "$project"/..?*; do
        [[ -e "$item" ]] || continue
        # Same exempt entries as preflight.sh's existing-content guard.
        case "${item##*/}" in
            .git|.claude|.agents|.codex|.hermes|.venv|CLAUDE.md|AGENTS.md|.gitignore|skills-lock.json) continue ;;
        esac
        return 1
    done
    return 0
}
is_cofounder_project || exit 0

if [[ -n "$codex" ]]; then
    echo "You are operating as a cofounder. Your FIRST action this session — before responding to or acting on the user's message, even if it is a specific task, question, or feature request — MUST be to load the \`cofounder-playbook\` skill of the cofounder plugin (its instructions are in \`$PLUGIN_ROOT/skills/cofounder-playbook/SKILL.md\`), then follow it as your operating instructions for the entire session. The other cofounder skills it refers to by name are in \`$PLUGIN_ROOT/skills/<skill-name>/SKILL.md\`. Do not begin the user's request until the playbook is loaded."
else
    echo "You are operating as a cofounder. Your FIRST action this session — before responding to or acting on the user's message, even if it is a specific task, question, or feature request — MUST be to use the Skill tool to invoke the \`cofounder:cofounder-playbook\` skill, then follow it as your operating instructions for the entire session. Do not begin the user's request until the playbook is loaded."
fi
