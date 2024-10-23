# linux-security

Generate the `.auto.tfvars` from the [template](config/template.tfvars):

```sh
cp config/template.tfvars
```

Set your public IP address in the `allowed_source_address_prefixes` variable using CIDR notation:

```sh
# allowed_source_address_prefixes = ["1.2.3.4/32"]
curl ipinfo.io/ip
```

Create a temporary key for the Virtual Machine:

```sh
mkdir keys && ssh-keygen -f keys/temp_rsa
```

Deploy the resources:

```sh
terraform init
terraform apply -auto-approve
```

### Protecting local secrets

If storing secrets locally in disk is unavoidable, extra protections shoud be provisioned.

- Tunneling
- Restrict origin addresses (IP, SNI)
- Disk encryption
- 


#### Strong disk encryption

There are different options for disk encryption, as in this [article][1]. There is a comparison table as well.

<img src=".assets/azure-disk-encryption-comparison.png" />


#### Service user with restricted permissions

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
> The `execute` permission is required to 

```sh
chmod 400 /opt/litapp/sample_rsa
chmod 400 /opt/litapp/sample_rsa.pub
chmod 500 /opt/litapp
```

For advanced protection for the root user, a [custom kernel][4] might have to be written. Modules such as with [SELinux][5] or [AppArmor][6].


#### Auditing / Monitoring

SIEM events can be registered to monitor these directories.



[1]: https://learn.microsoft.com/en-us/azure/virtual-machines/disk-encryption-overview
[2]: https://superuser.com/questions/77617/how-can-i-create-a-non-login-user
[3]: https://linux.die.net/man/8/useradd
[4]: https://stackoverflow.com/a/59559335/3231778
[5]: https://blog.siphos.be/2015/07/restricting-even-root-access-to-a-folder/
[6]: https://debian-handbook.info/browse/stable/sect.apparmor.html
