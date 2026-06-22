# ============================================================
# GroupMemberships.ps1
# NakelaTech Solutions | Active Directory Enterprise Simulation
# Domain: nakelatech.local
# ============================================================
# Description:
#   Assigns all provisioned users to their respective
#   departmental security groups.
#   Run this script after Create-Users.ps1 and
#   Create-SecurityGroups.ps1.
# ============================================================

Import-Module ActiveDirectory

Write-Host "`n[NakelaTech] Assigning users to security groups..." -ForegroundColor Cyan

# Define group memberships
$GroupMemberships = @(

    @{
        Group   = "Executive_Users"
        Members = @("nakela.johnson", "nakelaa.johnson")
    },
    @{
        Group   = "IT_Admins"
        Members = @("marcus.reed", "jordan.brooks")
    },
    @{
        Group   = "HR_Users"
        Members = @("sarah.mitchell", "jennifer.clark")
    },
    @{
        Group   = "Finance_Users"
        Members = @("michael.thompson", "emily.davis")
    }
)

foreach ($Entry in $GroupMemberships) {
    Write-Host "`n  Group: $($Entry.Group)" -ForegroundColor Cyan

    foreach ($Member in $Entry.Members) {
        # Check if user exists before adding
        if (-not (Get-ADUser -Filter "SamAccountName -eq '$Member'" -ErrorAction SilentlyContinue)) {
            Write-Host "    [WARN] User not found, skipping: $Member" -ForegroundColor Yellow
            continue
        }

        # Check if already a member
        $Existing = Get-ADGroupMember -Identity $Entry.Group -ErrorAction SilentlyContinue |
                    Where-Object { $_.SamAccountName -eq $Member }

        if ($Existing) {
            Write-Host "    [SKIP] Already a member: $Member" -ForegroundColor Yellow
        } else {
            try {
                Add-ADGroupMember -Identity $Entry.Group -Members $Member
                Write-Host "    [OK]   Added $Member to $($Entry.Group)" -ForegroundColor Green
            } catch {
                Write-Host "    [ERR]  Failed to add $Member - $($_.Exception.Message)" -ForegroundColor Red
            }
        }
    }
}

Write-Host "`n[NakelaTech] Group membership assignment complete." -ForegroundColor Cyan

# ── Verification ─────────────────────────────────────────────
Write-Host "`n[NakelaTech] Verifying group memberships...`n" -ForegroundColor Cyan

$GroupsToVerify = @("Executive_Users","IT_Admins","HR_Users","Finance_Users")

foreach ($Group in $GroupsToVerify) {
    Write-Host "  $Group" -ForegroundColor White
    Get-ADGroupMember -Identity $Group | Select-Object Name, SamAccountName |
        Format-Table -AutoSize
}
