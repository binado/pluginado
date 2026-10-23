# Validate claude code plugin setup
validate:
    claude plugin validate --strict .
    for p in plugins/*/; do claude plugin validate --strict "$p"; done

# Edit a skill file with $EDITOR
edit name:
    $EDITOR "plugins/workflow/skills/{{ name }}/SKILL.md"

# Add a new skill
add name:
    bunx skills init "plugins/workflow/skills/{{ name }}/SKILL.md"

# Scaffold a new plugin
create-plugin name description:
    uv run scripts/create_plugin.py --name "{{ name }}" --description "{{ description }}"
