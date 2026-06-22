# 🔧 Troubleshooting Log
### Active Directory Enterprise Simulation Lab | nakelatech.local

This document captures issues encountered during the lab, the troubleshooting steps taken, and how each was resolved. These are real issues worked through during the build — documented here for reference and replication.

---

## Table of Contents

- [Issue 1 – User Creation Errors](#issue-1--user-creation-errors)
- [Issue 2 – Finance Group Naming Issue](#issue-2--finance-group-naming-issue)
- [Issue 3 – Domain Join Authentication Failure](#issue-3--domain-join-authentication-failure)
- [Issue 4 – Users Removed from Departments](#issue-4--users-removed-from-departments)
- [Issue 5 – Group Membership Failures](#issue-5--group-membership-failures)

---

## Issue 1 – User Creation Errors

**Phase:** Phase 2 – Organizational Structure & RBAC

**Symptom:**
User accounts failed to create or were created with incorrect attributes when provisioning via the GUI or PowerShell script.

**Troubleshooting Steps:**

1. Reviewed error messages in ADUC for specific failure reasons
2. Verified that the target OU path was correctly specified
3. Checked for duplicate usernames or samAccountName conflicts
4. Confirmed the domain was reachable and AD DS services were running

**Resolution:**

Corrected the OU distinguished name paths and ensured samAccountName values were unique across the domain. Re-ran user provisioning after corrections.

**Lesson:**
Always verify the full OU path (distinguished name) before running bulk user creation. A single typo in the OU path will silently place users in the wrong container or fail entirely.

---

## Issue 2 – Finance Group Naming Issue

**Phase:** Phase 2 – Organizational Structure & RBAC

**Symptom:**
The Finance security group was created with an inconsistent name that did not match the established naming convention used for other departmental groups.

**Troubleshooting Steps:**

1. Reviewed all security group names in ADUC against the naming convention
2. Identified the Finance group was named incorrectly
3. Checked for any existing group membership or GPO references tied to the incorrect name

**Resolution:**

Renamed the group to `Finance_Users` to align with the established convention:

```
Executive_Users
IT_Admins
HR_Users
Finance_Users       ← corrected
Support_Users
Operations_Users
```

**Lesson:**
Establish and document your naming convention before creating any objects. Renaming groups after membership has been assigned adds unnecessary rework and risk.

---

## Issue 3 – Domain Join Authentication Failure

**Phase:** Phase 4 – Domain Join & Validation

**Symptom:**
WS01 could not authenticate to join the `nakelatech.local` domain despite entering what appeared to be valid domain administrator credentials.

**Troubleshooting Steps:**

| Step | Action | Tool |
|---|---|---|
| 1 | Verified DNS was resolving the domain name | `nslookup nakelatech.local` |
| 2 | Confirmed Domain Controller was discoverable on the network | `nltest /dsgetdc:nakelatech.local` |
| 3 | Verified the domain admin account existed and was active | ADUC |
| 4 | Confirmed the account was a member of Domain Admins | ADUC → Group Membership |
| 5 | Tested alternative authentication format (UPN vs NetBIOS) | System Properties → Domain Join |

**Resolution:**

Authentication succeeded when using the **UPN (User Principal Name)** format instead of the NetBIOS format:

```
# Format that failed:
NAKELATECH\nakelalab

# Format that worked:
nakelalab@nakelatech.local
```

**Root Cause:**
In Azure-hosted environments, UPN-format authentication is more reliable during domain join operations. The NetBIOS name resolution was not functioning as expected, but the fully qualified UPN resolved correctly.

**Lesson:**
When domain join authentication fails, always try both formats. UPN format (`user@domain.local`) is the safer default in cloud-hosted AD environments.

---

## Issue 4 – Users Removed from Departments

**Phase:** Phase 2 – Organizational Structure & RBAC

**Symptom:**
After initial provisioning, certain user accounts were found outside of their intended Organizational Units — either in the default `Users` container or in the wrong OU.

**Troubleshooting Steps:**

1. Audited all user objects in ADUC to identify misplaced accounts
2. Compared actual OU placement against the intended structure
3. Identified accounts that had been created in the default container rather than the target OU

**Resolution:**

Moved affected user accounts to their correct OUs using ADUC drag-and-drop or the Move function. Verified final placement by refreshing ADUC and confirming each user appeared under the correct OU.

**PowerShell alternative for bulk moves:**

```powershell
Move-ADObject -Identity "CN=Emily Davis,CN=Users,DC=nakelatech,DC=local" `
              -TargetPath "OU=Finance,DC=nakelatech,DC=local"
```

**Lesson:**
When creating users via the GUI, always right-click the target OU first before selecting "New User." Creating from the top-level domain or default Users container is a common mistake that requires cleanup.

---

## Issue 5 – Group Membership Failures

**Phase:** Phase 2 – Organizational Structure & RBAC

**Symptom:**
Users were not appearing as members of their assigned security groups after the initial provisioning attempt. Group membership assignments either failed silently or were not applied.

**Troubleshooting Steps:**

1. Opened each security group in ADUC and reviewed the Members tab
2. Identified which users were missing from their expected groups
3. Attempted to re-add users manually via ADUC
4. Tested via PowerShell to isolate whether the issue was GUI-related or permission-related

**Resolution:**

Re-added affected users to their groups using `Add-ADGroupMember` with explicit identity parameters:

```powershell
Add-ADGroupMember -Identity "Finance_Users" -Members "emily.davis", "michael.thompson"
Add-ADGroupMember -Identity "HR_Users" -Members "sarah.mitchell", "jennifer.clark"
Add-ADGroupMember -Identity "IT_Admins" -Members "marcus.reed", "jordan.brooks"
Add-ADGroupMember -Identity "Executive_Users" -Members "nakela.johnson", "nakelaa.johnson"
```

Verified membership after running:

```powershell
Get-ADGroupMember -Identity "Finance_Users" | Select-Object Name, SamAccountName
```

**Lesson:**
Always verify group membership after provisioning — don't assume it applied correctly. `Get-ADGroupMember` is the fastest way to confirm. PowerShell is more reliable than the GUI for bulk membership operations.

---

*Troubleshooting documented by Nakela Johnson | nakelatech.local | Active Directory Enterprise Simulation Lab*
