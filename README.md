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

#### Strong disk encryption

There are different options for disk encryption, as in this [article][1]. There is a comparison table as well.

<img src=".assets/azure-disk-encryption-comparison.png" />



[1]: https://learn.microsoft.com/en-us/azure/virtual-machines/disk-encryption-overview
