
#!/bin/bash
source ./secrets.sh

# Ensure SSH key exists
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
    echo "Error: SSH key not found at $HOME/.ssh/id_ed25519"
    exit 1
fi
chmod 0700 $HOME/.ssh/id_ed25519

# Create Ansible vault password file
echo -n "$ANSIBLE_VAULT_PW" | tr -d '\r' > $HOME/vault-pw

# Start ssh-agent and add key
eval `ssh-agent -s`
ssh-add $HOME/.ssh/id_ed25519

# Run Ansible playbook
ansible-playbook -v ./playbooks/$PLAYBOOK.yaml --inventory $INVENTORY --vault-password-file $HOME/vault-pw --ssh-extra-args "-o StrictHostKeyChecking=no" 