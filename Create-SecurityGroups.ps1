# ============================================================
# Create-SecurityGroups.ps1
# NakelaTech Solutions | Active Directory Enterprise Simulation
# Domain: nakelatech.local
# ============================================================
# Description:
#   Creates all departmental security groups and places them
#   in their respective Organizational Units.
#   Run this script after Create-OUs.ps1.
# ============================================================

# Define the domain root
$DomainRoot = "DC=nakelatech,DC=local"

# Define security groups with their target OU
$SecurityGroups = @(
    @{ Name = "Executive_Users";  OU = "OU=Executive,$DomainRoot"     },
    @{ Name = "IT_Admins";        OU = "OU=IT,$DomainRoot"            },
    @{ Name = "HR_Users";         OU = "OU=HumanResources,$DomainRoot"},
    @{ Name = "Finance_Users";    OU = "OU=Finance,$DomainRoot"       },
    @{ Name = "Support_Users";    OU = "OU=CustomerSupport,$DomainRoot"},
    @{ Name = "Operations_Users"; OU = "OU=Operations,$DomainRoot"    }
)

Write-Host "`n[NakelaTech] Creating Security Groups..." -ForegroundColor Cyan

foreach ($Group in $SecurityGroups) {
    # Check if group already exists
    if (Get-ADGroup -Filter "Name -eq '$($Group.Name)'" -ErrorAction SilentlyContinue) {
        Write-Host "  [SKIP] Group already exists: $($Group.Name)" -ForegroundColor Yellow
    } else {
        try {
            New-ADGroup `
                -Name $Group.Name `
                -GroupScope Global `
                -GroupCategory Security `
                -Path $Group.OU `
                -Description "Security group for $($Group.Name -replace '_', ' ')"

            Write-Host "  [OK]   Created group: $($Group.Name)" -ForegroundColor Green
        } catch {
            Write-Host "  [ERR]  Failed to create group: $($Group.Name) - $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

Write-Host "`n[NakelaTech] Security group creation complete.`n" -ForegroundColor Cyan
