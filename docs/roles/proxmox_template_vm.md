# Proxmox Template VM Role

This role deploys template VMs to your Proxmox host/cluster with cloud-init support. These templates can be cloned to create VMs that are pre-configured with your user, password, and SSH keys. You can even pre-configure network settings, allowing you to clone the template and SSH into the VM as soon as it boots.

A template VM will be created on each host in the group. A randomized 4-5 digit VMID will be generated based on the host's machine ID.

## Requirements

### Proxmox API Token
You need a Proxmox API token to authenticate with your Proxmox node/cluster for VM creation.

To create one:
1. Go to **Datacenter** → **Permissions** → **API Tokens** in the Proxmox web UI
2. Create a new token with appropriate permissions for VM management

## Role Variables

### Required Variables

Not providing any of the following variables will cause the task to fail.

```yaml
proxmox_template_vm_proxmox_username: <username>              # Proxmox username (e.g., root)
proxmox_template_vm_proxmox_api_token_id: <token-id>          # API token ID
proxmox_template_vm_proxmox_api_token_secret: <token-secret>  # API token secret
proxmox_template_vm_distros: []                                # List of distros (ubuntu, debian, fedora)
```

#### Example - Required Variables

```yaml
proxmox_template_vm_proxmox_username: "{{ proxmox_username }}"            # From vault
proxmox_template_vm_proxmox_api_token_id: "{{ proxmox_api_token_id }}"    # From vault
proxmox_template_vm_proxmox_api_token_secret: "{{ proxmox_api_token_secret }}"  # From vault

proxmox_template_vm_distros:
  - ubuntu
  - debian
```

### Template Configuration Variables

Customize VM templates with these variables (each has a default):

```yaml
proxmox_template_vm_ubuntu_name: ubuntu-2604-template
proxmox_template_vm_ubuntu_memory: 4096              # MB
proxmox_template_vm_ubuntu_cores: 1
proxmox_template_vm_ubuntu_storage: local-lvm

proxmox_template_vm_debian_name: debian-template
proxmox_template_vm_debian_memory: 4096              # MB
proxmox_template_vm_debian_cores: 1
proxmox_template_vm_debian_storage: local-lvm
```

### Cloud-Init Configuration

Optional cloud-init settings (omitted if not provided):

```yaml
proxmox_template_vm_ubuntu_ciuser: vcaldas           # Cloud-init username
proxmox_template_vm_ubuntu_cipassword: <password>    # Cloud-init password
proxmox_template_vm_ubuntu_sshkeys: <public-key>     # SSH key for cloud-init
proxmox_template_vm_ubuntu_vlan: 50                  # Optional VLAN tag
```

### Slow Storage Configuration

If your storage is prone to file locking, enable slow storage mode:

```yaml
proxmox_template_vm_slow_storage: true   # Default: false
```

If a task fails due to file lock errors, simply re-run the playbook. See [Proxmox discussion](https://forum.proxmox.com/threads/error-with-cfs-lock-unable-to-create-image-got-lock-timeout-aborting-command.65786/) for details.

## Dependencies

### community.general Collection
This role requires the [community.general](https://galaxy.ansible.com/ui/repo/published/community/general/) collection for:
- [community.general.proxmox_kvm](https://docs.ansible.com/ansible/latest/collections/community/general/proxmox_kvm_module.html)
- [community.general.proxmox_disk](https://docs.ansible.com/ansible/latest/collections/community/general/proxmox_disk_module.html)

## Example Playbook

```yaml
- name: Deploy VM templates
  hosts: proxmox_hosts

  tasks:
    - name: Deploy templates
      ansible.builtin.include_role:
        name: proxmox_template_vm
      vars:
        proxmox_template_vm_proxmox_username: "{{ proxmox_username }}"
        proxmox_template_vm_proxmox_api_token_id: "{{ proxmox_api_token_id }}"
        proxmox_template_vm_proxmox_api_token_secret: "{{ proxmox_api_token_secret }}"
        
        proxmox_template_vm_distros:
          - ubuntu
          - debian
        
        proxmox_template_vm_ubuntu_name: ubuntu-2604-template
        proxmox_template_vm_ubuntu_memory: 4096
        proxmox_template_vm_ubuntu_cores: 1
        proxmox_template_vm_ubuntu_ciuser: vcaldas
        proxmox_template_vm_ubuntu_cipassword: "{{ cipassword }}"
        proxmox_template_vm_ubuntu_sshkeys: "{{ lookup('file', lookup('env', 'HOME') + '/.ssh/id_ed25519.pub') }}"
        
        proxmox_template_vm_slow_storage: true
```
