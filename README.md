# 🖥️ Active Directory Enterprise Simulation Lab
### Built on Microsoft Azure | Windows Server 2025 | nakelatech.local

> A hands-on enterprise simulation demonstrating Active Directory Domain Services deployment, identity management, Group Policy enforcement, and domain onboarding — built entirely in Microsoft Azure.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Environment](#environment)
- [Architecture Diagram](#architecture-diagram)
- [OU & Security Group Structure](#ou--security-group-structure)
- [Phase 1 – Infrastructure Deployment](#phase-1--infrastructure-deployment)
- [Phase 2 – Organizational Structure & RBAC](#phase-2--organizational-structure--rbac)
- [Phase 3 – Group Policy Administration](#phase-3--group-policy-administration)
- [Phase 4 – Domain Join & Validation](#phase-4--domain-join--validation)
- [Troubleshooting Log](#troubleshooting-log)
- [Skills Demonstrated](#skills-demonstrated)
- [Lessons Learned](#lessons-learned)

---

## Overview

**NakelaTech Solutions** is a simulated mid-size technology organization requiring centralized identity and access management across multiple business departments.

This lab simulates the role of a Systems Administrator responsible for:

- Deploying and configuring Active Directory Domain Services (AD DS)
- Designing a scalable Organizational Unit (OU) structure
- Implementing Role-Based Access Control (RBAC) via Security Groups
- Enforcing security policy through Group Policy Objects (GPOs)
- Onboarding a member server to the domain
- Validating authentication and policy application

---

## Environment

| Component | Details |
|---|---|
| **Platform** | Microsoft Azure |
| **Operating System** | Windows Server 2025 Datacenter |
| **Domain** | `nakelatech.local` |
| **Domain Controller** | DC01 |
| **Member Server** | WS01 |
| **Services** | AD DS, DNS, Group Policy Management (GPMC) |

---

## Architecture Diagram

### Domain & Network Topology

```
                        ┌─────────────────────────────────────┐
                        │         Microsoft Azure              │
                        │                                      │
                        │   ┌──────────────────────────────┐  │
                        │   │     Virtual Network (VNet)   │  │
                        │   │                              │  │
                        │   │  ┌────────────────────────┐  │  │
                        │   │  │  DC01 (Domain Controller│  │  │
                        │   │  │  Windows Server 2025    │  │  │
                        │   │  │                         │  │  │
                        │   │  │  Roles:                 │  │  │
                        │   │  │  ├── AD DS              │  │  │
                        │   │  │  └── DNS Server         │  │  │
                        │   │  │                         │  │  │
                        │   │  │  Domain: nakelatech.local│ │  │
                        │   │  └────────────┬────────────┘  │  │
                        │   │               │               │  │
                        │   │        Domain Join            │  │
                        │   │               │               │  │
                        │   │  ┌────────────▼────────────┐  │  │
                        │   │  │  WS01 (Member Server)   │  │  │
                        │   │  │  Windows Server 2025    │  │  │
                        │   │  │  DNS → DC01             │  │  │
                        │   │  └─────────────────────────┘  │  │
                        │   └──────────────────────────────┘  │
                        └─────────────────────────────────────┘
```

---

### Active Directory Logical Structure

```
nakelatech.local  (Forest Root / Domain)
│
├── 📁 Executive
│     └── 👤 Nakela Johnson
│     └── 👤 Nakelaa Johnson
│
├── 📁 IT
│     └── 👤 Marcus Reed
│     └── 👤 Jordan Brooks
│
├── 📁 HumanResources
│     └── 👤 Sarah Mitchell
│     └── 👤 Jennifer Clark
│
├── 📁 Finance
│     └── 👤 Michael Thompson
│     └── 👤 Emily Davis
│
├── 📁 CustomerSupport
│
├── 📁 Operations
│
└── 📁 Workstations
      └── 🖥️ WS01
```

---

### Group Policy Object (GPO) Application Map

```
nakelatech.local
│
├── OU=IT ──────────────────────► [IT Security Policy GPO]
│                                     ├── Password Complexity: Enabled
│                                     ├── Minimum Password Length: 12 chars
│                                     ├── Machine Inactivity Limit: 15 min
│                                     └── Removable Storage: Restricted
│
└── OU=CustomerSupport ──────────► [Customer Support Policy GPO]
                                      ├── Control Panel: Restricted
                                      └── Command Prompt: Restricted
```

---

## OU & Security Group Structure

### Organizational Units

| OU Name | Purpose |
|---|---|
| Executive | Executive leadership accounts and policy scope |
| IT | IT administrator accounts and elevated policy |
| HumanResources | HR user accounts and access controls |
| Finance | Finance user accounts and access controls |
| CustomerSupport | Support staff accounts with restricted environment |
| Operations | Operations user accounts |
| Workstations | Domain-joined computer objects |

### Security Groups

| Group Name | Assigned To |
|---|---|
| `Executive_Users` | Executive OU users |
| `IT_Admins` | IT OU users |
| `HR_Users` | HumanResources OU users |
| `Finance_Users` | Finance OU users |
| `Support_Users` | CustomerSupport OU users |
| `Operations_Users` | Operations OU users |

> Security groups enforce Role-Based Access Control (RBAC) by assigning permissions at the group level rather than to individual user accounts — supporting the Principle of Least Privilege.

---

## Phase 1 – Infrastructure Deployment

**Goal:** Stand up the foundational Active Directory environment in Azure.

### Steps Performed

1. Deployed a Windows Server 2025 Datacenter VM in Microsoft Azure
2. Installed the **Active Directory Domain Services** role via Server Manager
3. Installed the **DNS Server** role
4. Promoted the server to **Domain Controller**
5. Created the Active Directory forest and domain:

```
nakelatech.local
```

### Verification

After promotion and reboot, confirmed AD DS appeared in Server Manager left panel and domain was active.

---

## Phase 2 – Organizational Structure & RBAC

**Goal:** Build a logical, scalable identity structure that mirrors a real business.

### Steps Performed

1. Created all Organizational Units via **Active Directory Users and Computers (ADUC)**
2. Created departmental **Security Groups**
3. Provisioned **user accounts** for each department
4. Assigned users to their respective Security Groups
5. Placed user objects within their corresponding OUs

### User Accounts Provisioned

| Department | Users |
|---|---|
| Executive | Nakela Johnson, Nakelaa Johnson |
| IT | Marcus Reed, Jordan Brooks |
| Human Resources | Sarah Mitchell, Jennifer Clark |
| Finance | Michael Thompson, Emily Davis |

---

## Phase 3 – Group Policy Administration

**Goal:** Enforce security and compliance settings at the departmental level using GPOs.

### IT Security Policy

**Linked to:** `OU=IT`

| Setting | Value |
|---|---|
| Password Complexity | Enabled |
| Minimum Password Length | 12 Characters |
| Machine Inactivity Limit | 15 Minutes |
| Removable Storage Access | Restricted |

### Customer Support Policy

**Linked to:** `OU=CustomerSupport`

| Setting | Value |
|---|---|
| Control Panel Access | Restricted |
| Command Prompt Access | Restricted |

### Applying and Verifying GPOs

After linking GPOs, policy was forced and verified on WS01:

```powershell
gpupdate /force
gpresult /r
```

---

## Phase 4 – Domain Join & Validation

**Goal:** Onboard a member server to the domain and validate centralized authentication and policy delivery.

### Steps Performed

1. Deployed member server **WS01** in Azure
2. Configured WS01's DNS to point to **DC01** (the Domain Controller)
3. Verified DNS resolution:

```powershell
nslookup nakelatech.local
```

4. Verified Domain Controller discovery:

```powershell
nltest /dsgetdc:nakelatech.local
```

5. Joined WS01 to the `nakelatech.local` domain
6. Validated Group Policy processing:

```powershell
gpupdate /force
gpresult /r
```

---

## Troubleshooting Log

### Issue: Domain Join Authentication Failure

**Symptom:** WS01 could not authenticate to join the domain despite correct credentials.

**Troubleshooting Steps:**

| Step | Action | Tool Used |
|---|---|---|
| 1 | Verified DNS was resolving domain name correctly | `nslookup nakelatech.local` |
| 2 | Confirmed Domain Controller was discoverable | `nltest /dsgetdc:nakelatech.local` |
| 3 | Verified domain admin account credentials | ADUC |
| 4 | Confirmed account was in Domain Admins group | ADUC |
| 5 | Tested alternative UPN login format | System Properties |

**Resolution:**

Authentication succeeded using the full UPN format:

```
nakelalab@nakelatech.local
```

**Root Cause:** Authentication format mattered — using the UPN (User Principal Name) format instead of the NetBIOS format resolved the issue.

---

## Skills Demonstrated

- ✅ Active Directory Domain Services Deployment
- ✅ Domain Controller Promotion
- ✅ Organizational Unit Design & Management
- ✅ User Lifecycle Management (Provisioning & Assignment)
- ✅ Security Group Administration
- ✅ Role-Based Access Control (RBAC)
- ✅ Group Policy Object (GPO) Creation & Enforcement
- ✅ DNS Administration
- ✅ Domain Onboarding & Member Server Management
- ✅ Authentication Troubleshooting
- ✅ Policy Validation via PowerShell
- ✅ Enterprise Documentation

---

## Technologies Used

| Tool / Technology | Role in Lab |
|---|---|
| Microsoft Azure | Cloud infrastructure hosting |
| Windows Server 2025 Datacenter | OS for DC and member server |
| Active Directory Domain Services | Identity and authentication |
| DNS Server | Name resolution for domain |
| Group Policy Management Console | GPO creation and linking |
| Active Directory Users and Computers | OU, user, and group management |
| PowerShell | Verification and troubleshooting |

---

## Lessons Learned

1. **DNS is the backbone of Active Directory.** Every domain join, authentication attempt, and DC discovery depends on DNS resolving correctly. Misconfigured DNS is the #1 cause of domain join failures.

2. **Installation vs. Promotion are separate steps.** Installing the AD DS role does not make a server a Domain Controller — promotion is required. Server Manager reflects this distinction post-reboot.

3. **GPOs apply based on OU scope.** A GPO linked at the domain level affects everyone; linked at the OU level, it affects only that OU. Placement matters.

4. **UPN format vs. NetBIOS format matters for authentication.** When standard `DOMAIN\username` auth fails, try `username@domain.local` — especially in Azure-hosted environments.

5. **Validation is not optional.** `gpresult /r` and `nltest` are essential tools for confirming the environment is working as expected, not just assumed to be.

---

*Lab completed by Nakela Johnson | nakelatech.local | Azure | Windows Server 2025*
