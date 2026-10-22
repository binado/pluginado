# Validate claude code plugin setup
validate:
    claude plugin validate --strict .

# Edit a skill file with $EDITOR
edit name:
    $EDITOR "skills/{{ name }}/SKILL.md"

# Add a new skill
add name:
    bunx skills init "skills/{{ name }}/SKILL.md"
