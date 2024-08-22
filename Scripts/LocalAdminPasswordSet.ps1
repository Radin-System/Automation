# Reqiered ENV:
#   LOCAL_ADMIN_PASSWORD

# Define the path to the stored encryption Key and IV
$encryptionKeyPath = "C:\Static\Keys\LocalAdminKey.bin"
$encryptionIVPath = "C:\Static\Keys\LocalAdminIV.bin"

# Load the encryption key and IV
$encryptionKey = [System.IO.File]::ReadAllBytes($encryptionKeyPath)
$encryptionIV = [System.IO.File]::ReadAllBytes($encryptionIVPath)

# Get the encrypted password from the environment variable
$encryptedPassword = $env:LOCAL_ADMIN_PASSWORD

# Decrypt the password
$aes = [System.Security.Cryptography.Aes]::Create()
$decryptor = $aes.CreateDecryptor($encryptionKey, $encryptionIV)
$encryptedPasswordBytes = [Convert]::FromBase64String($encryptedPassword)
$decryptedPasswordBytes = $decryptor.TransformFinalBlock($encryptedPasswordBytes, 0, $encryptedPasswordBytes.Length)
$decryptedPassword = [System.Text.Encoding]::UTF8.GetString($decryptedPasswordBytes)

# Set the local administrator password
$adminAccount = Get-LocalUser -Name "Administrator"
$adminAccount | Set-LocalUser -Password (ConvertTo-SecureString -String $decryptedPassword -AsPlainText -Force)

Write-Host "Local administrator password has been set successfully."

# Dispose of AES resources
$aes.Dispose()
