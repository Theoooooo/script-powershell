$server = "chat.freenode.net"
$port   = 6667
$bot = "bot-theo-script"
$channel = "#SCRIPT-POWERSHELL"
$owner = "The-oo"
$date = Get-Date
# Connect-session
$TCPClient = new-object Net.Sockets.TcpClient
$TCPClient.Connect($server, $port)

[Net.Sockets.NetworkStream]$NetStream = $TCPClient.GetStream()
[IO.StreamWriter]$writer = new-object IO.StreamWriter($NetStream,[Text.Encoding]::ASCII)
[IO.StreamReader]$reader = new-object IO.StreamReader($NetStream,[Text.Encoding]::ASCII)
$writer.AutoFlush = $true

if($TCPClient.Connected){
    $writer.WriteLine("NICK " + $bot)
    sleep(0.1)
    $writer.WriteLine("USER " + $bot + " 0 * :" + $bot)
    sleep(0.1)
    $writer.WriteLine("JOIN " + $channel)
    sleep(0.1)
    $writer.WriteLine("PRIVMSG " + $owner + " :Bot demarre le " + $date)
    sleep(0.1)
    $writer.WriteLine("PRIVMSG " + $channel + " :J'ai bien rejoins le channel")
    sleep(0.1)
    $writer.Flush();
}
else{
    write-host "Problème de connection"    
}

$read = $reader.ReadLine()
$hostname = $read.Split(" ")[0]

do {
    $read = $reader.ReadLine();
    write-host $read 
   
    if($read -like '*End of /MOTD command*') {
        sleep 1
        $pass = $true
    } 

} until($pass)



do {
    $read = $reader.ReadLine();
    write-host $read  

    if ($read -like '*stop_powershell*') {
        if($read -like '*' + $owner + '*') {
            $writer.WriteLine("QUIT")
            $read = $reader.ReadLine();
            write-host $read
            break
        } else {
            $writer.WriteLine("PRIVMSG #script-powershell :spece de battard tu va pas m'etteindre comme ca")
        }

    }
    if ($read -like '*command_bot*') {
        if($read -like '*' + $owner + '*') {
            $value = $read -split "command_bot "
            Write-host $value[1]
            $writer.WriteLine($value[1])
        }
    }

    if ($read -like '*' + $hostname + '*') {
        $writer.WriteLine("PRIVMSG " + $owner + " :" + $read)
        sleep(0.1)
    }




} until($read -eq "")

$TCPClient.Close();

Remove-Variable pass
