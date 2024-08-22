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
