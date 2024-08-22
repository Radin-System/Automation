# Define paths
$certPath = ".\Certificates\Certificate.pfx"  # Path to your certificate file
$certPassword = "$env:MyCertPassword"  # Password for the PFX file, if applicable
$scriptFolders = @(".\Scripts", ".\AdminTools")  # Folders containing scripts

# Import the certificate
try {
    $cert = Import-PfxCertificate -FilePath $certPath -CertStoreLocation Cert:\CurrentUser\My -Password (ConvertTo-SecureString -String $certPassword -AsPlainText -Force)
} catch {
    Write-Host "Error importing certificate: $_"
    exit
}

# Ensure the certificate was imported
if (-not $cert) {
    Write-Host "Certificate could not be imported."
    exit
}

# Get the certificate by subject name
$commonName = ($cert.Subject -split ',')[0] -replace 'CN=', ''
$cert = Get-ChildItem -Path Cert:\CurrentUser\My | Where-Object { $_.Subject -like "*CN=$commonName*" }

# Check if certificate was found
if (-not $cert) {
    Write-Host "Certificate with CN=$commonName not found."
    exit
}

# Loop through each folder and sign all .ps1 files
foreach ($folder in $scriptFolders) {
    if (Test-Path $folder) {
        Get-ChildItem -Path $folder -Recurse -Filter "*.ps1" | ForEach-Object {
            try {
                Write-Host "Signing script: $_"
                $result = Set-AuthenticodeSignature -FilePath $_.FullName -Certificate $cert
                if ($result.Status -ne 'Valid') {
                    Write-Host "Failed to sign script: $_.FullName - Status: $($result.Status)"
                }
            } catch {
                Write-Host "Error signing script: $_.FullName - $_"
            }
        }
    } else {
        Write-Host "Folder not found: $folder"
    }
}

Write-Host "All scripts have been processed."

# SIG # Begin signature block
# MIIIRwYJKoZIhvcNAQcCoIIIODCCCDQCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUKq0ddt/YbcVRButIaD2lYBfH
# Ks2gggW9MIIFuTCCBKGgAwIBAgITewAAABS4ZDzBI0YHrAAAAAAAFDANBgkqhkiG
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
# MRYEFCoCQYm3h3YxVPdMXn4hKQjWocnhMA0GCSqGSIb3DQEBAQUABIIBAJRjzHyH
# MaD9hfP6uHcCt8oeTWuDhY3IwNwN1/ZOnEPLNm4zSfu1fSZd0/Rk3C/syxgoIffh
# M+ZH/uxxzKOASYS2lPHwl//7kPVRGY/T2gjwuuFPE2ZK2JbYu+1JB0Oy9Fn2ML71
# 5sdxvTa4Ux0OqI7WXa3Ia/wrGWpLm4pKLszxerxXlpVstb6cevM5LqeB/g/49kzJ
# Dn2GB5xpOPmKeoAJVqqzu6rrLKM5ltFfarr0OgItVn+meuXVUqxkxlv2EhuFrDfE
# zHHfqBaWFUOBJQY17jN4GJyQA7/PmBWdZtiGNfWPkId8gJkfaIRgwtx5xfqltNUA
# seKnjQJgY2UR2OM=
# SIG # End signature block
