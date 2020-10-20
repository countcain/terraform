# IaC

Personally I have a need to organize my dev envs. Right now the stack is mainly around DigitalOcean and AWS.

I use DO's VMs(droplets) to run containers and persist data on AWS RDS.
I have a bunch of terraform files and ansible playbooks in private repos documenting all the configuration of Consul, Nomad, Datadog agents and other tools.
In this repo I try to abstract all of them and make them more generic, so I can share and learn it with everyone in the same field.
