function refresh_appservergrids {
    $cache:clear = get-clearappserver
    $stringData = $cache:clear.appserver -join "`n"
    $stringData2 = $cache:clear.apiappserver -join "`n"

    $cache:appservergrid1 = if ($stringData -match '.+\s+:\s+.+[\s\S]+.+\s+:\s+.+') {
        $matches[0] -replace '\s+:\s+', '=' |
        ConvertFrom-StringData |
        ForEach-Object GetEnumerator
    }
    $cache:apiappservergrid1 = if ($stringData2 -match '.+\s+:\s+.+[\s\S]+.+\s+:\s+.+') {
        $matches[0] -replace '\s+:\s+', '=' |
        ConvertFrom-StringData |
        ForEach-Object GetEnumerator
    }
    $cache:appserverobject = if ($stringData -match '.+\s+:\s+.+[\s\S]+.+\s+:\s+.+') {
        $parsedData = $matches[0] -replace '\s+:\s+', '=' |
            ConvertFrom-StringData
        [PSCustomObject]$parsedData
    }
    $cache:apiappserverobject = if ($stringData2 -match '.+\s+:\s+.+[\s\S]+.+\s+:\s+.+') {
        $parsedData = $matches[0] -replace '\s+:\s+', '=' |
            ConvertFrom-StringData
        [PSCustomObject]$parsedData
    }
    $cache:appservergrid2 = if ($stringData -match 'PID\s+State[\s\S]+') {
        $matches[0] -split '\n' |
        Where-Object { $_ -match '(?<PID>\d+)\s+(?<State>\S+)\s+(?<Port>\d+)\s+(?<Requested>\d+)\s+(?<Received>\d+)\s+(?<Sent>\d+)\s+(?<Started>\d\S+\s\d{2}:\d{2})\s+(?<LastChange>\d\S+\s\d{2}:\d{2})' } |
        ForEach-Object {
            $matches.Remove(0)
            [PSCustomObject]@{
                PID           = $matches['PID']
                State         = $matches['State']
                Port          = $matches['Port']
                Requested     = $matches['Requested'] -as [Int]
                Received      = $matches['Received'] -as [Int]
                Sent          = $matches['Sent'] -as [Int]
                Started       = Get-Date $matches['Started']
                'Last Change' = Get-Date $matches['LastChange']
            }
        }
    }

    $cache:apiappservergrid2 = if ($stringData2 -match 'PID\s+State[\s\S]+') {
        $matches[0] -split '\n' |
        Where-Object { $_ -match '(?<PID>\d+)\s+(?<State>\S+)\s+(?<Port>\d+)\s+(?<Requested>\d+)\s+(?<Received>\d+)\s+(?<Sent>\d+)\s+(?<Started>\d\S+\s\d{2}:\d{2})\s+(?<LastChange>\d\S+\s\d{2}:\d{2})' } |
        ForEach-Object {
            $matches.Remove(0)
            [PSCustomObject]@{
                PID           = $matches['PID']
                State         = $matches['State']
                Port          = $matches['Port']
                Requested     = $matches['Requested'] -as [Int]
                Received      = $matches['Received'] -as [Int]
                Sent          = $matches['Sent'] -as [Int]
                Started       = Get-Date $matches['Started']
                'Last Change' = Get-Date $matches['LastChange']
            }
        }
    }

}