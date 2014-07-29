    Function Get-TargetResource {
        param (
            [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string]$pullServerDSC,
            [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string]$hashFile
        )
        @{
            pullServerDSC = $pullServerDSC;
            hashFile = $hashFile;

        }
    }

    Function Test-TargetResource {
        param (
            [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string]$pullServerDSC,
            [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string]$hashFile
        )
        $checkHash = Get-FileHash $pullServerDSC
        $currentHash = Get-Content $hashFile
        if($checkHash -ne $currentHash) {
            return $false
        }
        else {
            return $true
        }

    }

    Function Set-TargetResource {
        param (
            [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string]$pullServerDSC,
            [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string]$hashFile
        )
        $checkHash = Get-FileHash $pullServerDSC
        $currentHash = Get-Content $hashFile
        if($checkHash -ne $currentHash) {
            Write-Verbose "PullServerDSC has changed"
            Set-Content -Path $hashFile -Value (Get-FileHash -Path $pullServerDSC).hash
            #Invoke-Command -ScriptBlock { PowerShell.exe $pullServerDSC; break} -ArgumentList "-ExecutionPolicy Bypass -Force"
            #Start-Process -Wait $pullServerDSC -ArgumentList "-ExecutionPolicy -Bypass -Force"
            #& $pullServerDSC
        }
    }

    Export-ModuleMember -Function *-TargetResource