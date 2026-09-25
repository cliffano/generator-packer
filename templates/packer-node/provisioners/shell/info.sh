#!/bin/sh
set -o errexit
set -o nounset

echo "Node path: $(command -v node)"
echo "Python path: $(command -v python3)"
echo "Ansible path: $(command -v ansible)"
echo "{{project_name}} path: $(command -v {{project_id}})"

echo "Node version: $(node --version)"
echo "Python version: $(python3 --version)"
echo "Ansible version: $(ansible --version)"
echo "{{project_name}} sample output:"
{{project_id}} --message 'Hello World'
