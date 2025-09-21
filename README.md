# Azure Linux Security

> [!NOTE]
> Make sure you enable [host-based encryption][7] in the subscription before you start

Generate the `.auto.tfvars` from the [template](config/template.tfvars):

```sh
cp config/template.tfvars .auto.tfvars
```

Set your public IP address in the `allowed_source_address_prefixes` variable using CIDR notation:

```sh
# allowed_source_address_prefixes = ["1.2.3.4/32"]
curl ifconfig.io/ip
```

Create a temporary key for the Virtual Machine:

```sh
mkdir .keys && ssh-keygen -f .keys/azure
```

Deploy the resources:

```sh
terraform init
terraform apply -auto-approve
```

Connect to the VM and [mount the data disk][9].

> [!IMPORTANT]
> Make sure mount is persistent after reboots

## Create Privileged User

Createt the user:

```sh
sudo adduser newusername
sudo usermod -aG sudo newusername
```

Verify:

```sh
groups newusername
su - newusername
sudo whoami
```

While logged in with the "newusername", set the SSH authentication key:

```sh
# On your server (logged as an existing sudo user):
sudo mkdir -p /home/newusername/.ssh
sudo nano /home/newusername/.ssh/authorized_keys
```

Alternatively, change the ownership afterwards:

```sh
sudo chown -R newusername:newusername /home/newusername/.ssh
sudo chmod 700 /home/newusername/.ssh
sudo chmod 600 /home/newusername/.ssh/authorized_keys
```

### Password Logins

Edit the SSH config:

```sh
sudo nano /etc/ssh/sshd_config
```

Enable password authentication:

```
PasswordAuthentication yes
```

Restart the service:

```sh
sudo systemctl restart ssh
```


## Protecting local secrets

If storing secrets locally in disk is unavoidable, extra protections should be provisioned.

> [!IMPORTANT]
> When implementing advanced features, check limits and restrictions that might apply

- Tunneling from the origin to destination
- Restrict origin addresses at the destination (IP, SNI)
- Proper file permissions setup
- Strong admin user access control
- Disk encryption with customer-managed key (CMK)
- Platform-specific encryption technology (Azure Encryption-at-Host, ADE)
- Use HSM

Complex approaches:

- Use a custom kernel module to change root access permissions (SELinux, AppArmor)
- Security events monitoring (SIEM)
- Auditing

Other approaches (not as effective, side effects):

- Encrypted locally but with password in the same filesystem (chicken and the egg problem)
- Create the secret files with a hidden prefix (".")
- Use a random name for the files

### Strong disk encryption

There are different options for disk encryption, as in this [article][1]. There is a comparison table as well.

<img src=".assets/azure-disk-encryption-comparison.png" />


### System user permissions

Following this [threat][2], there are some ways of increasing the security of local secrets.

Login as super user:

```sh
sudo su -
```

Create the system user with the `-r` option ([manual pages][3]):

```sh
# A system user does not have a password, a home dir, and is unable to login
useradd -r litapp
```

Create the appliation directory and assign ownership:

```sh
mkdir /opt/litapp
chown -R litapp /opt/litapp
```

Switch to the `litapp` user:

```sh
sudo -u litapp -s
```

Enter the directory and create the sample key:

```sh
cd /opt/litapp
ssh-keygen -f sample_rsa
```

Once the sample key is created, restrict the access to the files to **read only**:

> [!TIP]
> The `execute` permission is required to cd into the directory

```sh
# Owner read-only to files
chmod 400 /opt/litapp/sample_rsa
chmod 400 /opt/litapp/sample_rsa.pub

# Owner read and execute for the directory
chmod 500 /opt/litapp
```

For advanced protection for the root user, a [custom kernel][4] might have to be written. Modules such as with [SELinux][5] or [AppArmor][6].

### Encryption

Key Vaults might have [limited capabilities for keys][8].

> [!IMPORTANT]
> This project uses a Key Vault with Private Link to test CMK scenarios (in case there are network restrictions)

### Security events monitoring (SIEM)

A SIEM-like approach can be used to monitor these directories that react to user actions that could potentially compromise the secrets.


[1]: https://learn.microsoft.com/en-us/azure/virtual-machines/disk-encryption-overview
[2]: https://superuser.com/questions/77617/how-can-i-create-a-non-login-user
[3]: https://linux.die.net/man/8/useradd
[4]: https://stackoverflow.com/a/59559335/3231778
[5]: https://blog.siphos.be/2015/07/restricting-even-root-access-to-a-folder/
[6]: https://debian-handbook.info/browse/stable/sect.apparmor.html
[7]: https://learn.microsoft.com/en-us/azure/virtual-machines/disks-enable-host-based-encryption-portal?tabs=azure-powershell#prerequisites
[8]: https://learn.microsoft.com/en-us/azure/key-vault/keys/about-keys
[9]: https://learn.microsoft.com/en-us/azure/virtual-machines/linux/attach-disk-portal
