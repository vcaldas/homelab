# Proxmox Deployment Playbook

## Overview

The `proxmox.yaml` playbook automates the deployment and configuration of Proxmox hosts and VM templates. It handles baseline server configuration and creates reusable VM templates for both Ubuntu and Debian distributions.

## Goal

The playbook achieves two primary objectives:

1. **Baseline Configuration**: Hardens and configures Proxmox hosts with essential tools and security settings
2. **Template Creation**: Builds cloud-init enabled VM templates that can be quickly cloned for new virtual machines

## Playbook Structure

### Play Target
- **Hosts**: `proxmox_hosts` (defined in your Ansible inventory)

### Tasks

#### 1. Import Variables
Loads all variables from the `../vars` directory, including secrets from the Ansible vault.

#### 2. Baseline Configuration
Runs the `server_baseline` role to configure Proxmox hosts with:
- User creation (vcaldas)
- SSH hardening and key-based authentication
- Timezone configuration (Europe/Amsterdam)
- System packages (tmux, ncdu)
- Tailscale VPN integration

#### 3. VM Template Deployment
Uses the `proxmox_template_vm` role to create cloud-init enabled templates for:
- **Ubuntu 24.04** (ubuntu-2604-template)
- **Debian** (debian-template)

## Configuration Variables

### Required Proxmox Credentials
These must be provided from the Ansible vault:

```yaml
proxmox_template_vm_proxmox_username     # Proxmox API username
proxmox_template_vm_proxmox_api_token_id # Proxmox API token ID
proxmox_template_vm_proxmox_api_token_secret # Proxmox API token secret
```

### Ubuntu Template Options
```yaml
proxmox_template_vm_ubuntu_storage       # Storage pool (local-lvm)
proxmox_template_vm_ubuntu_name          # Template name
proxmox_template_vm_ubuntu_memory        # RAM in MB (4096)
proxmox_template_vm_ubuntu_cores         # CPU cores (1)
proxmox_template_vm_ubuntu_ciuser        # Cloud-init user (vcaldas)
proxmox_template_vm_ubuntu_cipassword    # Cloud-init password (from vault)
proxmox_template_vm_ubuntu_sshkeys       # SSH public key (auto-loaded from user home)
proxmox_template_vm_ubuntu_vlan          # Optional VLAN ID
```

### Debian Template Options
Same structure as Ubuntu with `debian` prefix instead of `ubuntu`.

### Advanced Settings
```yaml
proxmox_template_vm_slow_storage: true   # Enable if using slow storage (avoids file locks)
```

## Tailscale Integration

Both Proxmox hosts and VM templates are configured with Tailscale VPN using:
- OAuth client credentials from vault
- Auto-tagged devices ("servers")
- Ephemeral key disabled
- Pre-authorized mode enabled

This allows direct connectivity to all Proxmox infrastructure via the Tailscale mesh network.

## SSH Key Management

The playbook automatically:
1. Uses your local SSH public key (`~/.ssh/id_ed25519.pub`) for cloud-init
2. Disables password authentication on all hosts
3. Configures key-based authentication for users

## Prerequisites

1. Proxmox host(s) in your Ansible inventory under `proxmox_hosts` group
2. Ansible vault with:
   - Proxmox API credentials
   - Tailscale OAuth client secret
   - Cloud-init password
3. SSH access to Proxmox hosts
4. SSH public key available at `~/.ssh/id_ed25519.pub`

## Running the Playbook

From the `ansible/` directory:

```bash
./run.sh
```

Or manually:

```bash
ansible-playbook -v playbooks/proxmox.yaml \
  --inventory hosts.yml \
  --vault-password-file ~/.vault-pw
```

## Output

The playbook creates:
- Hardened Proxmox host with baseline security
- Ubuntu 24.04 cloud-init template (ready to clone as VMs)
- Debian cloud-init template (ready to clone as VMs)
- Tailscale integration on all hosts and templates

## Related Documentation

- [Server Baseline Role](../roles/server_baseline/README.md) - Host hardening and configuration
- [Proxmox Template VM Role](../roles/proxmox_template_vm/README.md) - VM template creation details
