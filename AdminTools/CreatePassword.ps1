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
