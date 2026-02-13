# Server Baseline Role

This role makes a baseline configuration for linux servers. The following configurations are made:

- Create a user with sudo privileges*
- Copy your SSH key to the server and disable password-based authentication
- Update apt/dnf and ensure a list of default packages are present
- Install any additional desired system packages
- Configure default deny on the firewall, allowing SSH connections* 
- Install and bring up [Tailscale](https://tailscale.com)

*Not executed on Proxmox hosts

## Requirements

### Supported Operating Systems
As of the latest update, the only tested and supported operating systems are:
- Ubuntu 22.04+
- Fedora 40+
- Proxmox 8+

Other versions may work but have not been tested.

### Tailscale OAuth Client Secret
You will need a [Tailscale](https://tailscale.com) account and an [OAuth client](https://tailscale.com/kb/1215/oauth-clients) secret to use this role.

## Role Variables

### Required Variables
Not providing these variables will cause the task to fail.

```yaml
server_baseline_created_username: <your-username>              # Username to create with sudo privileges
server_baseline_tailscale_oauth_client_secret: <secret>        # Tailscale OAuth client secret (dict format recommended)
server_baseline_timezone: <server-timezone>                    # Timezone to set on server
```

#### Example - Required Variables

```yaml
server_baseline_created_username: vcaldas
server_baseline_tailscale_oauth_client_secret: "{{ tailscale_servers_oauth_client['key'] }}"  # From Ansible vault
server_baseline_timezone: Europe/Amsterdam
```

### Optional Variables

Install additional packages beyond the defaults:

```yaml
server_baseline_fedora_packages: []      # Additional packages for Fedora
server_baseline_ubuntu_packages: []      # Additional packages for Ubuntu
server_baseline_proxmox_packages: []     # Additional packages for Proxmox
```

#### Example - Optional Variables

```yaml
server_baseline_fedora_packages:
  - borgbackup
  - tmux

server_baseline_ubuntu_packages:
  - aptitude
  - borgbackup
  - tmux

server_baseline_proxmox_packages:
  - tmux
  - iperf3
```

### Default Packages by Distribution

**Ubuntu:**
- curl
- nano
- vim
- git
- ufw
- cifs-utils

**Fedora:**
- curl
- nano
- vim
- git
- dnf-plugins-core
- firewalld
- cifs-utils

**Proxmox:**
- curl
- nano
- vim
- git
- python3-proxmoxer
- python3-requests

## Dependencies

### artis3n.tailscale Collection
This role depends on the [artis3n.tailscale](https://github.com/artis3n/ansible-collection-tailscale) collection for Tailscale installation.

Install with:
```bash
ansible-galaxy collection install artis3n.tailscale
```

## Example Playbook

```yaml
- name: Configure baseline servers
  hosts: all
  
  tasks:
    - name: Run server baseline
      ansible.builtin.include_role:
        name: server_baseline
      vars:
        server_baseline_created_username: vcaldas
        server_baseline_tailscale_oauth_client_secret: "{{ tailscale_servers_oauth_client['key'] }}"
        server_baseline_timezone: Europe/Amsterdam
        server_baseline_ubuntu_packages:
          - tmux
          - ncdu
```
