# ============================================================
# Create-OUs.ps1
# NakelaTech Solutions | Active Directory Enterprise Simulation
# Domain: nakelatech.local
# ============================================================
# Description:
#   Creates all Organizational Units for the nakelatech.local domain.
#   Run this script on the Domain Controller as a Domain Admin.
# ============================================================

# Define the domain root path
$DomainRoot = "DC=nakelatech,DC=local"

# Define all OUs to create
$OUs = @(
    "Executive",
    "IT",
    "HumanResources",
    "Finance",
    "CustomerSupport",
    "Operations",
    "Workstations"
)

Write-Host "`n[NakelaTech] Creating Organizational Units..." -ForegroundColor Cyan

foreach ($OU in $OUs) {
    $OUPath = "OU=$OU,$DomainRoot"

    # Check if OU already exists
    if (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$OUPath'" -ErrorAction SilentlyContinue) {
        Write-Host "  [SKIP] OU already exists: $OU" -ForegroundColor Yellow
    } else {
        try {
            New-ADOrganizationalUnit -Name $OU -Path $DomainRoot -ProtectedFromAccidentalDeletion $true
            Write-Host "  [OK]   Created OU: $OU" -ForegroundColor Green
        } catch {
            Write-Host "  [ERR]  Failed to create OU: $OU - $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

Write-Host "`n[NakelaTech] OU creation complete.`n" -ForegroundColor Cyan
