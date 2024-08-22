# Import the functions from MyFunctions.ps1
. "C:\Path\To\MyFunctions.ps1"

# Required ENV:
#   LOCAL_ADMIN_PASSWORD

# Define the path to the stored encryption Key and IV
$encryptionKeyPath = "C:\Static\Keys\LocalAdminKey.bin"
$encryptionIVPath = "C:\Static\Keys\LocalAdminIV.bin"

try {
    # Log the start of the script
    Write-Log -LogContent "Script started. Preparing to load encryption key and IV." -LogLevel "Info"

    # Load the encryption key and IV
    $encryptionKey = [System.IO.File]::ReadAllBytes($encryptionKeyPath)
    $encryptionIV = [System.IO.File]::ReadAllBytes($encryptionIVPath)

    Write-Log -LogContent "Encryption key and IV loaded successfully." -LogLevel "Info"

    # Get the encrypted password from the environment variable
    $encryptedPassword = $env:LOCAL_ADMIN_PASSWORD
    if (-not $encryptedPassword) {
        throw "Environment variable LOCAL_ADMIN_PASSWORD is not set or empty."
    }

    Write-Log -LogContent "Encrypted password retrieved from environment variable." -LogLevel "Info"

    # Decrypt the password
    $aes = [System.Security.Cryptography.Aes]::Create()
    $decryptor = $aes.CreateDecryptor($encryptionKey, $encryptionIV)
    $encryptedPasswordBytes = [Convert]::FromBase64String($encryptedPassword)
    $decryptedPasswordBytes = $decryptor.TransformFinalBlock($encryptedPasswordBytes, 0, $encryptedPasswordBytes.Length)
    $decryptedPassword = [System.Text.Encoding]::UTF8.GetString($decryptedPasswordBytes)

    Write-Log -LogContent "Password decrypted successfully." -LogLevel "Info"

    # Set the local administrator password
    $adminAccount = Get-LocalUser -Name "Administrator"
    $adminAccount | Set-LocalUser -Password (ConvertTo-SecureString -String $decryptedPassword -AsPlainText -Force)

    Write-Log -LogContent "Local administrator password has been set successfully." -LogLevel "Info"

} catch {
    # Log any errors that occur
    Write-Log -LogContent "Error: $_" -LogLevel "Error"
} finally {
    # Dispose of AES resources
    if ($aes) {
        $aes.Dispose()
        Write-Log -LogContent "AES resources disposed." -LogLevel "Info"
    }
    
    Write-Log -LogContent "Script completed." -LogLevel "Info"
}

# SIG # Begin signature block
# MIIIRwYJKoZIhvcNAQcCoIIIODCCCDQCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU1VfQukM9vWsesg3ZPqEqhguA
# MX+gggW9MIIFuTCCBKGgAwIBAgITewAAABS4ZDzBI0YHrAAAAAAAFDANBgkqhkiG
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
# MRYEFKcnzQZre/8HwoGJDogVOhfeYCQhMA0GCSqGSIb3DQEBAQUABIIBAJYEFKz4
# j2xsw7xmjyxaj3mn4Rdn2i4X+2Y3ZH/zLsrnfQ4x2NQ3tpMR41oVccePDTVfBmGL
# rGo/eUKZcCACpme+w1wwpeayf0zwIm55/6gJ9aUuOOzhW4/YU5a99XweEvNTlAig
# iS2cvfPfa+QjdHy3/alKC93TMvcu/WUSOkc1ssr6NzrmGif3vmLNWB3Di84deN+T
# txzCcyHS3tSHGF1JhMWG792Lsyyv5WjwWabiHdA7VOgZ/0Mjt24WDPpSlhW33x6Y
# qWqeEzAqBttrZST4jxBKvaFvAMs+NkxNmNuyoYOTWGgsEcL+YbAxe9R3qUUAXbQO
# LSC9YW0v/UjfS/o=
# SIG # End signature block
