#!/bin/sh
set -o errexit
set -o nounset

echo "Ansible path: $(command -v ansible)"
echo "{{project_name}} path: $(command -v {{project_id}})"

echo "Ansible version: $(ansible --version)"
echo "{{project_name}} sample output:"
{{project_id}} --message 'Hello World'
