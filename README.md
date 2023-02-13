# Exoscale Terraform Provider Issue

This repository contains the source code necessary to replicate an issue encountered when using the `exoscale/exoscale` terraform provider to create IAM access keys.

## Issue

When creating a `exoscale_iam_access_key` with tags successfully, running `terraform plan` shows modifications although nothing has been changed.

It appears that Exoscale _expands_ the tags to their matching list of operations which results in terraform thinking that the state does not match.

### Steps to reproduce

1. Create an Exoscale API key (unrestricted)
2. Rename `main.auto.tfvars.example` to `main.auto.tfvars`
3. Fill in the `exoscale_api_key` and `exoscale_api_secret` variables
4. Initialize terraform by running `terraform init` in this directory.
5. Run `terraform plan -out plan.json`
6. Run `terraform apply plan.json`
7. Run `terraform plan -out plan.json`
8. See that terraform wants to delete items in the `tags_operations` and `operations`, although they have never been specified.

## Example run

### 1st `plan`

This is what you get after running `terraform plan` for the first time.

<details>
    <summary>Output</summary>

```
$ terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # exoscale_iam_access_key.my-access-key will be created
  + resource "exoscale_iam_access_key" "my-access-key" {
      + id              = (known after apply)
      + key             = (sensitive value)
      + name            = "my-access-key"
      + secret          = (sensitive value)
      + tags            = [
          + "compute",
        ]
      + tags_operations = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

</details>

### 1st `apply`

This is what you get after running `terraform apply` based on the previous plan.

<details>
    <summary>Output</summary>

```
$ terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # exoscale_iam_access_key.my-access-key will be created
  + resource "exoscale_iam_access_key" "my-access-key" {
      + id              = (known after apply)
      + key             = (sensitive value)
      + name            = "my-access-key"
      + secret          = (sensitive value)
      + tags            = [
          + "compute",
        ]
      + tags_operations = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

exoscale_iam_access_key.my-access-key: Creating...
exoscale_iam_access_key.my-access-key: Creation complete after 0s [id=EXO7dde0fbd99d975e6e08cc4a6]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

</details>

### 2nd `plan`

This is what you get after running `terraform plan` a second time, after the previous apply.

<details>
    <summary>Output</summary>

````
terraform plan
exoscale_iam_access_key.my-access-key: Refreshing state... [id=EXO7dde0fbd99d975e6e08cc4a6]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
-/+ destroy and then create replacement

Terraform will perform the following actions:

  # exoscale_iam_access_key.my-access-key must be replaced
-/+ resource "exoscale_iam_access_key" "my-access-key" {
      ~ id              = "EXO7dde0fbd99d975e6e08cc4a6" -> (known after apply)
      ~ key             = (sensitive value)
        name            = "my-access-key"
      - operations      = [
          - "add-external-source-to-security-group",
          - "add-instance-protection",
          - "add-rule-to-security-group",
          - "add-service-to-load-balancer",
          - "attach-instance-to-elastic-ip",
          - "attach-instance-to-private-network",
          - "attach-instance-to-security-group",
          - "compute-change-service-for-vm",
          - "compute-delete-reverse-dns-from-ip",
          - "compute-delete-reverse-dns-from-vm",
          - "compute-get-export-snapshot",
          - "compute-list-volumes",
          - "compute-query-reverse-dns-for-ip",
          - "compute-query-reverse-dns-for-vm",
          - "compute-register-user-keys",
          - "compute-reset-ssh-key-for-vm",
          - "compute-update-reverse-dns-for-ip",
          - "compute-update-reverse-dns-for-vm",
          - "compute-validate-client-signature",
          - "copy-template",
          - "create-anti-affinity-group",
          - "create-elastic-ip",
          - "create-instance",
          - "create-instance-pool",
          - "create-load-balancer",
          - "create-private-network",
          - "create-security-group",
          - "create-sks-cluster",
          - "create-sks-nodepool",
          - "create-snapshot",
          - "create-ssh-key",
          - "delete-anti-affinity-group",
          - "delete-elastic-ip",
          - "delete-instance",
          - "delete-instance-pool",
          - "delete-load-balancer",
          - "delete-load-balancer-service",
          - "delete-private-network",
          - "delete-reverse-dns-elastic-ip",
          - "delete-reverse-dns-instance",
          - "delete-rule-from-security-group",
          - "delete-security-group",
          - "delete-sks-cluster",
          - "delete-sks-nodepool",
          - "delete-snapshot",
          - "delete-ssh-key",
          - "delete-template",
          - "detach-instance-from-elastic-ip",
          - "detach-instance-from-private-network",
          - "detach-instance-from-security-group",
          - "enable-instance-ipv6",
          - "evict-instance-pool-members",
          - "evict-sks-nodepool-members",
          - "export-snapshot",
          - "generate-sks-cluster-kubeconfig",
          - "get-anti-affinity-group",
          - "get-console-proxy-url",
          - "get-deploy-target",
          - "get-elastic-ip",
          - "get-instance",
          - "get-instance-password",
          - "get-instance-pool",
          - "get-instance-type",
          - "get-load-balancer",
          - "get-load-balancer-service",
          - "get-operation",
          - "get-private-network",
          - "get-quota",
          - "get-reverse-dns-elastic-ip",
          - "get-reverse-dns-instance",
          - "get-security-group",
          - "get-sks-cluster",
          - "get-sks-cluster-authority-cert",
          - "get-sks-nodepool",
          - "get-snapshot",
          - "get-ssh-key",
          - "get-template",
          - "list-anti-affinity-groups",
          - "list-deploy-targets",
          - "list-elastic-ips",
          - "list-events",
          - "list-global-templates",
          - "list-instance-pools",
          - "list-instance-types",
          - "list-instances",
          - "list-load-balancers",
          - "list-private-networks",
          - "list-quotas",
          - "list-security-groups",
          - "list-sks-cluster-deprecated-resources",
          - "list-sks-cluster-versions",
          - "list-sks-clusters",
          - "list-snapshots",
          - "list-ssh-keys",
          - "list-templates",
          - "list-zones",
          - "ping",
          - "promote-snapshot-to-template",
          - "reboot-instance",
          - "register-ssh-key",
          - "register-template",
          - "remove-external-source-from-security-group",
          - "remove-instance-protection",
          - "reset-elastic-ip-field",
          - "reset-instance",
          - "reset-instance-field",
          - "reset-instance-password",
          - "reset-instance-pool-field",
          - "reset-load-balancer-field",
          - "reset-load-balancer-service-field",
          - "reset-private-network-field",
          - "reset-sks-cluster-field",
          - "reset-sks-nodepool-field",
          - "resize-instance-disk",
          - "reveal-instance-password",
          - "revert-instance-to-snapshot",
          - "rotate-sks-ccm-credentials",
          - "rotate-sks-operators-ca",
          - "scale-instance",
          - "scale-instance-pool",
          - "scale-sks-nodepool",
          - "start-instance",
          - "stop-instance",
          - "update-elastic-ip",
          - "update-instance",
          - "update-instance-pool",
          - "update-instance-security-groups",
          - "update-load-balancer",
          - "update-load-balancer-service",
          - "update-private-network",
          - "update-private-network-instance-ip",
          - "update-reverse-dns-elastic-ip",
          - "update-reverse-dns-instance",
          - "update-sks-cluster",
          - "update-sks-nodepool",
          - "update-template",
          - "upgrade-sks-cluster",
          - "upgrade-sks-cluster-service-level",
        ] -> null # forces replacement
      ~ secret          = (sensitive value)
        tags            = [
            "compute",
        ]
      ~ tags_operations = [
          - "add-external-source-to-security-group",
          - "add-instance-protection",
          - "add-rule-to-security-group",
          - "add-service-to-load-balancer",
          - "attach-instance-to-elastic-ip",
          - "attach-instance-to-private-network",
          - "attach-instance-to-security-group",
          - "compute-change-service-for-vm",
          - "compute-delete-reverse-dns-from-ip",
          - "compute-delete-reverse-dns-from-vm",
          - "compute-get-export-snapshot",
          - "compute-list-volumes",
          - "compute-query-reverse-dns-for-ip",
          - "compute-query-reverse-dns-for-vm",
          - "compute-register-user-keys",
          - "compute-reset-ssh-key-for-vm",
          - "compute-update-reverse-dns-for-ip",
          - "compute-update-reverse-dns-for-vm",
          - "compute-validate-client-signature",
          - "copy-template",
          - "create-anti-affinity-group",
          - "create-elastic-ip",
          - "create-instance",
          - "create-instance-pool",
          - "create-load-balancer",
          - "create-private-network",
          - "create-security-group",
          - "create-sks-cluster",
          - "create-sks-nodepool",
          - "create-snapshot",
          - "create-ssh-key",
          - "delete-anti-affinity-group",
          - "delete-elastic-ip",
          - "delete-instance",
          - "delete-instance-pool",
          - "delete-load-balancer",
          - "delete-load-balancer-service",
          - "delete-private-network",
          - "delete-reverse-dns-elastic-ip",
          - "delete-reverse-dns-instance",
          - "delete-rule-from-security-group",
          - "delete-security-group",
          - "delete-sks-cluster",
          - "delete-sks-nodepool",
          - "delete-snapshot",
          - "delete-ssh-key",
          - "delete-template",
          - "detach-instance-from-elastic-ip",
          - "detach-instance-from-private-network",
          - "detach-instance-from-security-group",
          - "enable-instance-ipv6",
          - "evict-instance-pool-members",
          - "evict-sks-nodepool-members",
          - "export-snapshot",
          - "generate-sks-cluster-kubeconfig",
          - "get-anti-affinity-group",
          - "get-console-proxy-url",
          - "get-deploy-target",
          - "get-elastic-ip",
          - "get-instance",
          - "get-instance-password",
          - "get-instance-pool",
          - "get-instance-type",
          - "get-load-balancer",
          - "get-load-balancer-service",
          - "get-operation",
          - "get-private-network",
          - "get-quota",
          - "get-reverse-dns-elastic-ip",
          - "get-reverse-dns-instance",
          - "get-security-group",
          - "get-sks-cluster",
          - "get-sks-cluster-authority-cert",
          - "get-sks-nodepool",
          - "get-snapshot",
          - "get-ssh-key",
          - "get-template",
          - "list-anti-affinity-groups",
          - "list-deploy-targets",
          - "list-elastic-ips",
          - "list-events",
          - "list-global-templates",
          - "list-instance-pools",
          - "list-instance-types",
          - "list-instances",
          - "list-load-balancers",
          - "list-private-networks",
          - "list-quotas",
          - "list-security-groups",
          - "list-sks-cluster-deprecated-resources",
          - "list-sks-cluster-versions",
          - "list-sks-clusters",
          - "list-snapshots",
          - "list-ssh-keys",
          - "list-templates",
          - "list-zones",
          - "ping",
          - "promote-snapshot-to-template",
          - "reboot-instance",
          - "register-ssh-key",
          - "register-template",
          - "remove-external-source-from-security-group",
          - "remove-instance-protection",
          - "reset-elastic-ip-field",
          - "reset-instance",
          - "reset-instance-field",
          - "reset-instance-password",
          - "reset-instance-pool-field",
          - "reset-load-balancer-field",
          - "reset-load-balancer-service-field",
          - "reset-private-network-field",
          - "reset-sks-cluster-field",
          - "reset-sks-nodepool-field",
          - "resize-instance-disk",
          - "reveal-instance-password",
          - "revert-instance-to-snapshot",
          - "rotate-sks-ccm-credentials",
          - "rotate-sks-operators-ca",
          - "scale-instance",
          - "scale-instance-pool",
          - "scale-sks-nodepool",
          - "start-instance",
          - "stop-instance",
          - "update-elastic-ip",
          - "update-instance",
          - "update-instance-pool",
          - "update-instance-security-groups",
          - "update-load-balancer",
          - "update-load-balancer-service",
          - "update-private-network",
          - "update-private-network-instance-ip",
          - "update-reverse-dns-elastic-ip",
          - "update-reverse-dns-instance",
          - "update-sks-cluster",
          - "update-sks-nodepool",
          - "update-template",
          - "upgrade-sks-cluster",
          - "upgrade-sks-cluster-service-level",
        ] -> (known after apply)
    }

Plan: 1 to add, 0 to change, 1 to destroy.
```

</details>
````
