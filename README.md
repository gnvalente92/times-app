# Times App

The goal of this repository is to support every step of the deployment of a `Python` application that serves the local times in New-York, Berlin, Tokyo in `HTML` format.

## Local setup
Everything was developed in a `MacBook Pro Retina`, 15-inch, Mid 2015, running `MacOS Monterey` (12.6.6). Everything should run in any `UNIX` based OS.

## Prerequisites

* `Docker` installed.
* Project created in `GCP`.
* `gcloud` installed and setup to a `GCP` account.
* `Terraform` installed.
* `Make` installed.
* `Helm3` installed.

## How to use

[This](./Makefile) `Makefile` has been created to fully spin up everything that is needed. To execute, just run the following command.

```bash
make # Or most likely gmake, if you are running on mac
```

When you are ready to teardown everything that was created, just run
```bash
make clean # Again most likely gmake, if you are running on mac
```

The section below discusses some of the implementation steps.

## Script steps
### Use `Terraform` to provision infrastructure
This deployment is supported by `Google Cloud Platform` infrastructure, namely the resources `google_compute_network`, `google_compute_subnetwork`, `google_container_cluster` and `google_artifact_registry_repository`. It is quite a simple architecture, with a `K8s` cluster running in a subnet in a `VPC` without internet access. As will be seen later on, this deployment will make use of a `Google Load Balancer`. If we were not to use that object, which massively simplifies this implementation, we would need to implement a firewall rule to allow traffic from the internet to the `VPC`. That would be achieved with a `google_compute_firewall` resource in `Terraform` over `TCP` port `80`. 

For added simplicity, we are just using a local `Terraform` state.

### `Python` Application using `Flask`
The `Python` Application itself does not require much explanation, it's just using the package `pytz` to get the necessary local times and `Flask` to implement the described routes.

### Use `Docker` to containerize the `Python` Application
To containerize the described application in [this](./app/Dockerfile) `Dockerfile`, we just fetch the `python:3.9` base image, install `Flask` and `pytz`, copy the `Python` file inside and set the execution of that application as the entrypoint.

In the script, we just build and tag the image for the created `GCR` artifact repository and push it.

### Install the `helm` chart
Just install the developed `helm3` chart from [here](./times-app/). It already has the necessary values to deploy the application to the cluster.

This chart is again where we would need some additional elements if we were not to use the `Google Cloud LoadBalancer` resource. We would need to deploy an ingress controller and an ingress with our domain configured and the route to the correct service.

### Return the address
At the end, we run a `kubectl` command to return the `IP` address where we can access the application (`EXTERNAL-IP`). This was accomplished just waiting for a minute before trying to "pull" this `IP`, if it returns `<PENDING>` it's just a matter of either running `make get_address`.
