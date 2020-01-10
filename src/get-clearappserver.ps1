function get-clearappserver {
    $username = "username"
    $password = "password"
    $cred = New-Object System.Management.Automation.PSCredential ($username, (ConvertTo-SecureString $password -AsPlainText -Force))
    New-SSHSession -ComputerName unixdr2 -Credential ($cred) -AcceptKey
    $appserver = Invoke-SSHCommand -SessionId 0 -Command "cd /data/gmt/clear; /prg/gmt/scripts/proj -asq"
    $apiappserver = Invoke-SSHCommand -SessionId 0 -Command "cd /data/gmt/clear; /prg/gmt/scripts/proj api -asq"
    Get-SSHSession | Remove-SSHSession

    $clear = [PSCustomObject]@{
        appserver    = $appserver.output
        APIappserver = $apiappserver.output
    }
    return $clear
}