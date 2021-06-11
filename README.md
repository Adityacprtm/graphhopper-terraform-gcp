# Graphhopper Terraform GCP

What is [Graphhopper](https://www.graphhopper.com/)?

Here will deploy an open source project from Graphhopper, namely the `GraphHopper Routing Engine`, check the [repo](https://github.com/graphhopper/graphhopper).

## Tools

- Graphhopper 3.0
- Packer
- Terraform
- Google Cloud Platform
  - Cloud Image
  - Compute Engine

## Usage

## Setup Service Account

Create Service Account on GCP with At least `Compute Instance Admin (v1) & Service Account User roles.`

### Build image

Packer

```shell
packer build -var "time=$(date '+%Y%m%d%H%M%S')" packer-graphhopper.json
```

> this command will create temporary VM instance and running the command shell, the output from this process is image whit name: `graphhopper-v3-[date]`

Output:

- image

### Deploy

Terraform

```shell
terraform apply -auto-approve
```

> this command will deploy graphhopper ready to use. `-auto-approve` will waive the prompt approval.

Output:

- Instance Template with Image that created from Packer
- Instance Group with 1 member
- Compute Engine as member of group

## Note

This instance will not have an External IP Address, so create External Load Balancer on Cloud Load Balancer and assign it with Instance Group that just created before.
