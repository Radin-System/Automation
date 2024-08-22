function Compare-Versions {
    param (
        [string]$version1,
        [string]$version2
    )

    # Split the version numbers into components
    $major1, $minor1, $patch1 = $version1 -split '\.'
    $major2, $minor2, $patch2 = $version2 -split '\.'

    # Pad components to ensure proper numerical comparison
    $major1 = $major1.PadLeft(3, '0')
    $minor1 = $minor1.PadLeft(3, '0')
    $patch1 = $patch1.PadLeft(3, '0')
    $major2 = $major2.PadLeft(3, '0')
    $minor2 = $minor2.PadLeft(3, '0')
    $patch2 = $patch2.PadLeft(3, '0')

    # Concatenate components to create comparable strings
    $v1 = "$major1$minor1$patch1"
    $v2 = "$major2$minor2$patch2"

    # Compare versions
    if ($v1 -ge $v2) {
        return $true
    } else {
        return $false
    }
}

function Write-Log {
    param (
        [string]$LogContent,    
        [string]$RemoteLogFile = "\\$env:DEPLOYMENT_SERVER\$env:DEPLOYMENT_PATH\Logs\$env:COMPUTERNAME.txt",
        [string]$LocalLogFile = "C:\Static\Logs\Main.txt",
        [string]$LogLevel = "Info",
        [string]$ScriptName = $MyInvocation.MyCommand.Name
    )

    # Get the current timestamp
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    # Format the log entry
    $logEntry = "$timestamp - $ScriptName - $LogLevel - $LogContent"

    # Append the log entry to the file
    Add-Content -Path $RemoteLogFile -Value $logEntry
    Add-Content -Path $LocalLogFile -Value $logEntry
}