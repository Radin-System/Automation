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
# SIG # Begin signature block
# MIIIRwYJKoZIhvcNAQcCoIIIODCCCDQCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU43lUnXoqT6YV8Lkpvp4OeKBq
# EMigggW9MIIFuTCCBKGgAwIBAgITewAAABS4ZDzBI0YHrAAAAAAAFDANBgkqhkiG
# 9w0BAQsFADA8MRIwEAYKCZImiZPyLGQBGRYCaXIxFDASBgoJkiaJk/IsZAEZFgRy
# c3RvMRAwDgYDVQQDEwdyc3RvLUNBMB4XDTI0MDgyMjE0MTEwNFoXDTI1MDgyMjE0
# MTEwNFowaTESMBAGCgmSJomT8ixkARkWAmlyMRQwEgYKCZImiZPyLGQBGRYEcnN0
# bzEVMBMGA1UECxMMUmFkaW4gU3lzdGVtMQswCQYDVQQLEwJJVDEZMBcGA1UEAxMQ
# TW9oYW1tYWQgSGV5ZGFyaTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB
# AJ27Ri5BP43M8oXQ6nO1R8Pzg+exkAoVAtnOc5AfhcRouZtS/Yn3x97oYEa8pvf2
# hz25QbRuuG16mUx3ROLBqZ66erIwZOvpYDtDWwxmOJiyC2Zm/39PhLx77okMbwix
# L8iHoq/L9x4UI8ex69YdOh4R2c6fJtTiPvcKSCgVlQLpfzup/5+tC0+1ZlnewjEJ
# MplsiXuYRsE117zA9SoL3apL03V+OpNybXsNyXf77Tq8ca0G1isBlGK2KPqK+ete
# mj2wf//phze3tcfUdvlsKSCZ9EP+dodnPU0tebN9gtNlwJOHu3eqVrCb0MfXlEXV
# QpDmWsyzW/gO3DkET61Q/J0CAwEAAaOCAoUwggKBMCUGCSsGAQQBgjcUAgQYHhYA
# QwBvAGQAZQBTAGkAZwBuAGkAbgBnMBMGA1UdJQQMMAoGCCsGAQUFBwMDMA4GA1Ud
# DwEB/wQEAwIHgDAdBgNVHQ4EFgQUpLfLEhR2kz8J9NGz/ooMdnMKdIYwHwYDVR0j
# BBgwFoAUrpuaQurwE2sDHs41SOGULX9XZEIwgbwGA1UdHwSBtDCBsTCBrqCBq6CB
# qIaBpWxkYXA6Ly8vQ049cnN0by1DQSxDTj1DQSxDTj1DRFAsQ049UHVibGljJTIw
# S2V5JTIwU2VydmljZXMsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1y
# c3RvLERDPWlyP2NlcnRpZmljYXRlUmV2b2NhdGlvbkxpc3Q/YmFzZT9vYmplY3RD
# bGFzcz1jUkxEaXN0cmlidXRpb25Qb2ludDCBtQYIKwYBBQUHAQEEgagwgaUwgaIG
# CCsGAQUFBzAChoGVbGRhcDovLy9DTj1yc3RvLUNBLENOPUFJQSxDTj1QdWJsaWMl
# MjBLZXklMjBTZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERD
# PXJzdG8sREM9aXI/Y0FDZXJ0aWZpY2F0ZT9iYXNlP29iamVjdENsYXNzPWNlcnRp
# ZmljYXRpb25BdXRob3JpdHkwLAYDVR0RBCUwI6AhBgorBgEEAYI3FAIDoBMMEW0u
# aGV5ZGFyaUByc3RvLmlyME4GCSsGAQQBgjcZAgRBMD+gPQYKKwYBBAGCNxkCAaAv
# BC1TLTEtNS0yMS0yMjYwNTY0NjkzLTMyMjU3NDU4MjEtNDQwODY2MDU4LTE2MTMw
# DQYJKoZIhvcNAQELBQADggEBAFrp55Vo3XUDnZKIWlba1dFSVdECNme6uAw/H51A
# HG0AlVgmuWO+59Qha/VtIlCjI1rcczc5IClO3ZPNsXJyx658l02wgsVo83tjFZvZ
# HWN5SymHjlV9nY8N7gSuao873/Jdvx76siQ2cw3b5+Tj/dVYh5+VxSuynYf8MVJ0
# OxXnn3DsljjN20y4zYPJsZt9MaXerSEVMo2ecV/ZuM6p2OAeS9cNzw4Juh+8hH0i
# dpkUMZr2D3R9ovb7BCvlSIlAku2OE/KEa19ZhTufS3d26PK3dqM7NrY4HvtmCJA+
# J1qMAFBK44K2Bz66DH+85/XS/mJ3qLy4RpZtSbURAQn/WrIxggH0MIIB8AIBATBT
# MDwxEjAQBgoJkiaJk/IsZAEZFgJpcjEUMBIGCgmSJomT8ixkARkWBHJzdG8xEDAO
# BgNVBAMTB3JzdG8tQ0ECE3sAAAAUuGQ8wSNGB6wAAAAAABQwCQYFKw4DAhoFAKB4
# MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQB
# gjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkE
# MRYEFJGBK7vLtvfdlr6VQBsLFnU8I15HMA0GCSqGSIb3DQEBAQUABIIBACOcFFu9
# tNPoR1jjb4TMClAI+4Q29uUjFori3ZMgkR4c0JVcsUCD4zx8hsZ/L2Ppd2F136a4
# CYZOxDhbl6yqpR1zi+7x4w3hCWP74jAZI+kriLMi+uS2ztlFEE91NrSjsqay4TCH
# cdcxTao8wziPqGrSy4wTd7b/7ggycoqQ3DLN6ToXLHBUFvrGEfzG6IJYvYTt0LJc
# Ms+3uRsBMP01P0enwy4AMOUFUBBSRl3Gt5d1utDcGoUmHBR1HLJXJIk2sdsVcEd3
# ec4sjhlhk3wyuSGLMoooyTl+68aU0Hl2S0pGduFHyJdA2Tdh7W/ztkWrAArHGezR
# uErXDqZ7oEC6QJM=
# SIG # End signature block