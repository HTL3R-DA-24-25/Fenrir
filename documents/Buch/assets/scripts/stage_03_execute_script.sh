#!/bin/bash
cd "$(dirname -- "${BASH_SOURCE[0]}")" || $(echo "Cannot move to correct directory!" && exit 1)

source ./.venv/bin/activate

cat <<EOF > ./playbooks/stages/stage_03/inventory.yml
domain_controllers:
  hosts:
    primary:
      ansible_host: $1
      ansible_user: administrator
      ansible_shell_type: powershell
    secondary:
      ansible_host: $3
      ansible_user: administrator
      ansible_shell_type: powershell
EOF

ansible-playbook -i ./playbooks/stages/stage_03/inventory.yml ./playbooks/stages/stage_03/setup_dc_primary.yml -e "vm_uuid=$1" -e "management_address=$2"
ansible-playbook -i ./playbooks/stages/stage_03/inventory.yml ./playbooks/stages/stage_03/setup_dc_secondary.yml -e "vm_uuid=$3" -e "management_address=$4"
rm ./playbooks/stages/stage_03/inventory.yml
