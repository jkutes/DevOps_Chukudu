# DevOps_Chukudu
---
## 01-Docker-ayes: 
    Dockerfile to run Litecoin 0.18.1 in a container. 
    verify the checksum of the downloaded release
    run as a normal user, and when run without any modifiers (i.e. docker run somerepo/litecoin:0.18.1) run the daemon,
    print its output to the console. 
    build is security conscious (Anchore image security test).

## 02-k8s FTW: 
    Kubernetes StatefulSet to run the above, 
    using persistent volume claims and resource limits.

## 03-All the continuouses: 
    Simple build and deployment Jenkins pipeline for the above using groovy
    
---
## 04-Script kiddies: 
    awk & sed - Co2 emission file manipulation - extract only last 4 years.

## 05-Script grown-ups:
    Same as 04, but with Python

## 06-Terraform lovers unite: 
    Terraform module that creates the following resources in IAM; ---
    • - A role, with no permissions, which can be assumed by users within the same account,
    • - A policy, allowing users / entities to assume the above role,
    • - A group, with the above policy attached,
    • - A user, belonging to the above group.
    All four entities should have the same name, or be similarly named in some meaningful way given
    the context e.g. prod-ci-role, prod-ci-policy, prod-ci-group, prod-ci-user; or just prod-ci. Make the
    suffixes toggleable, if you like.