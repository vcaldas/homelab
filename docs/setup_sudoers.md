For both the pi and proxmox host groups, it’ll do the following:

Make sure sudo is present on the machines.
Enable passwordless sudo for any user in the sudo group. The lineinfile also has a handy validation function which will validate the changes on a temporary file before overwriting. This way the sudoers file doesn’t accidentally get borked.
For every item in the users var, create a user with item.name. The contents for item.password end up exact in /etc/shadow, so it must be hashed and salted beforehand. To do this, it can be generated with openssl passwd -6 -salt <salt> <password>.
For every item in the users var, add authorized keys from GitHub based on the item.github key. This is similar to previous steps with ssh-import-id, but this is adding the public keys for the newly created user.

```
generate salt:

```shell
openssl passwd -6 -salt <salt> <password>.
``` 
