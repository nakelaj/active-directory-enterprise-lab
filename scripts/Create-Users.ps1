# ============================================================
# Create-Users.ps1
# NakelaTech Solutions | Active Directory Enterprise Simulation
# Domain: nakelatech.local
# ============================================================
# Description:
#   Provisions all departmental user accounts and places them
#   in their respective Organizational Units.
#   Run this script after Create-OUs.ps1.
#
# Default password: Welcome@NakelaTech1
# Users will be required to change password at first logon.
# ============================================================

# Import the Active Directory module
Import-Module ActiveDirectory

# Define domain root
$DomainRoot  = "DC=nakelatech,DC=local"
$UPNSuffix   = "nakelatech.local"

# Default password for all new accounts
$DefaultPassword = ConvertTo-SecureString "Welcome@NakelaTech1" -AsPlainText -Force

# Define all users with their OU placement
$Users = @(

    # Executive
    @{ First = "Nakela";   Last = "Johnson";   OU = "OU=Executive,$DomainRoot"      },
    @{ First = "Nakelaa";  Last = "Johnson";   OU = "OU=Executive,$DomainRoot"      },

    # Information Technology
    @{ First = "Marcus";   Last = "Reed";      OU = "OU=IT,$DomainRoot"             },
    @{ First = "Jordan";   Last = "Brooks";    OU = "OU=IT,$DomainRoot"             },

    # Human Resources
    @{ First = "Sarah";    Last = "Mitchell";  OU = "OU=HumanResources,$DomainRoot" },
    @{ First = "Jennifer"; Last = "Clark";     OU = "OU=HumanResources,$DomainRoot" },

    # Finance
    @{ First = "Michael";  Last = "Thompson";  OU = "OU=Finance,$DomainRoot"        },
    @{ First = "Emily";    Last = "Davis";     OU = "OU=Finance,$DomainRoot"        }
)

Write-Host "`n[NakelaTech] Provisioning user accounts..." -ForegroundColor Cyan

foreach ($User in $Users) {

    # Build display name and samAccountName
    $DisplayName    = "$($User.First) $($User.Last)"
    $SamAccountName = "$($User.First.ToLower()).$($User.Last.ToLower())"
    $UPN            = "$SamAccountName@$UPNSuffix"

    # Check if user already exists
    if (Get-ADUser -Filter "SamAccountName -eq '$SamAccountName'" -ErrorAction SilentlyContinue) {
        Write-Host "  [SKIP] User already exists: $DisplayName ($SamAccountName)" -ForegroundColor Yellow
    } else {
        try {
            New-ADUser `
                -GivenName          $User.First `
                -Surname            $User.Last `
                -Name               $DisplayName `
                -DisplayName        $DisplayName `
                -SamAccountName     $SamAccountName `
                -UserPrincipalName  $UPN `
                -Path               $User.OU `
                -AccountPassword    $DefaultPassword `
                -ChangePasswordAtLogon $true `
                -Enabled            $true

            Write-Host "  [OK]   Created user: $DisplayName ($UPN)" -ForegroundColor Green
        } catch {
            Write-Host "  [ERR]  Failed to create user: $DisplayName - $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

Write-Host "`n[NakelaTech] User provisioning complete.`n" -ForegroundColor Cyan
