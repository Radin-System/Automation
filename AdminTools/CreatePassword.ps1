# Reqiered ENV:
#   DEPLOYMENT_SERVER
#   DEPLOYMENT_PATH

# Prompt the user to enter a password
$password = Read-Host -Prompt "Enter the password" -AsSecureString

# Convert the SecureString password to plain text
$passwordPlainText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))

# Generate a new encryption key and IV (Initialization Vector)
$aes = [System.Security.Cryptography.Aes]::Create()
$encryptionKey = $aes.Key
$encryptionIV = $aes.IV

# Store the encryption key and IV securely (e.g., in a file or a secure vault)
$encryptionKeyPath = "\\$env:DEPLOYMENT_SERVER\$env:DEPLOYMENT_PATH\Static\Keys\LocalAdminKey.bin"
$encryptionIVPath = "\\$env:DEPLOYMENT_SERVER\$env:DEPLOYMENT_PATH\Static\Keys\LocalAdminIV.bin"

# Save key files
[System.IO.File]::WriteAllBytes($encryptionKeyPath, $encryptionKey)
[System.IO.File]::WriteAllBytes($encryptionIVPath, $encryptionIV)

# Encrypt the password
$encryptor = $aes.CreateEncryptor($encryptionKey, $encryptionIV)
$encryptedPasswordBytes = $encryptor.TransformFinalBlock([System.Text.Encoding]::UTF8.GetBytes($passwordPlainText), 0, $passwordPlainText.Length)
$encryptedPassword = [Convert]::ToBase64String($encryptedPasswordBytes)

# Output the encrypted password
Write-Host "Encrypted Password: $encryptedPassword"

# Dispose of AES resources
$aes.Dispose()

# SIG # Begin signature block
# MIIIRwYJKoZIhvcNAQcCoIIIODCCCDQCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUSwLDtQn64+zZqMDHZiop5NWF
# GFmgggW9MIIFuTCCBKGgAwIBAgITewAAABS4ZDzBI0YHrAAAAAAAFDANBgkqhkiG
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
# MRYEFJGa5djPWBwWxgr+jt/IK1K6h9hqMA0GCSqGSIb3DQEBAQUABIIBAG9/7l/K
# 4pqjrtZc3+vjZJo2xKES0kzj9VnCgx8mdnoffx+gfxvkZPUl5IPYzuI417xEyiuX
# H0F2p8EWi3Qcs9sUV7Am1fjVtu34Zr7DmI6vQZG8bMxRSBn6Ltxwl0FHz1E67vjE
# UMGiPqJJ1kpzBa1O79Q2J2G+sAZr6ELB6Y5oYSmJe1vVoGa5HDMsxuVBvzn9yodH
# FZf17LjprKF+nb7Td45Js9xBEqtyNCw/vb9qpIPTFXJXFvv50EyrK/RTLrP0dkfJ
# vhgKGV+wmZL1NRuSd/6XXO3Kevqz7YzFzZZQf0EkPG5XGFSW6CzhpY6Hmsjl5U6y
# 1HzFmRIAN8Bwl28=
# SIG # End signature block
