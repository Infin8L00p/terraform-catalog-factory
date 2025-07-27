# Overview

This repository implements a **Service Catalog Factory** using Terraform.

**What it does**
1. Creates one or more **Service Catalog portfolios**.
2. Shares each portfolio to specified **AWS Organizations OUs**.
3. Publishes **Git‑synced products** (one small CloudFormation stack per product).
4. Applies a **LaunchRoleConstraint** to each portfolio–product pair **in Terraform**.
5. Distributes **launch roles** to all consumer accounts using **CloudFormation StackSets**.

**What it does *not* do**
- It does not store product templates — point products at your **template repo**.
- It does not grant end‑user access — attach Service Catalog policies to users/roles separately.
