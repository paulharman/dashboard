New-UDPage  -Name "Clear Appservers"  -AuthorizationPolicy "IT" -Icon link -Content {
    New-UDRow {

        New-UDColumn -id 'appservercolumn1' -size 4 -Endpoint {
            New-UDGrid -id 'clearappserversgrid' -Title "Clear Appservers" -AutoRefresh -RefreshInterval 250 -PageSize 50 -Endpoint {
                $cache:appservergrid1 | Out-UDGridData
            }
        }
        New-UDColumn -id 'appservercolumn2' -size 2 -AutoRefresh -RefreshInterval 1 -Endpoint {
            New-UDCard -id 'appservercolumn2card' -TextAlignment center -Endpoint {
                $oldest = $cache:appservergrid2 | Sort-Object 'Last Change' | Select-Object -First 1
                $duration = (Get-Date) - $oldest.'Last Change'
                
                $running = $cache:appservergrid2 | Where-Object { $_.State -eq "RUNNING" }
				
				if ([math]::ceiling($duration.TotalMinutes) -ge 60){ 
				$oldest = 60} else { $oldest = [math]::ceiling($duration.TotalMinutes) }
                
				New-UDGauge -PaddingVertical 8 -Width 250 -id 'AppServerActiveServers' -MaxValue 15 -NeedleColor white -StartColor green -EndColor red -value ($cache:appserverobject.'Active Servers') -Segments 3 -ValueText $('Total servers: ' + $($cache:appserverobject.'Active Servers'))
				New-UDGauge -PaddingVertical 8 -Width 250 -id 'AppServerRunningServers' -MaxValue 15 -NeedleColor white -StartColor green -EndColor red -value (@($running).count)  -Segments 3 -ValueText $('Running servers: ' + $(@($running).count))
                New-UDGauge -PaddingVertical 8 -Width 250 -id 'AppServerOldestChange' -MaxValue 60 -NeedleColor white -StartColor green -EndColor red -value $oldest -Segments 6 -ValueText $('Oldest change: ' + $([string]$([math]::ceiling($duration.TotalMinutes)) + ' mins'))
            }
        }
        New-UDColumn -id 'appservercolumn3' -size 4 -Endpoint {
            New-UDGrid -Title "Clear API Appservers" -id "appservercolumn3card" -AutoRefresh -RefreshInterval 250 -PageSize 50 -Endpoint {
                $cache:apiappservergrid1 | Out-UDGridData
            }
        }
        New-UDColumn -id 'appservercolumn4' -size 2 -AutoRefresh -RefreshInterval 1 -Endpoint {
            New-UDCard -TextAlignment center -id 'appservercolumn4card'  -Endpoint {
                $oldest = $cache:apiappservergrid2 | Sort-Object 'Last Change' | Select-Object -First 1
                $apiduration = (Get-Date) - $oldest.'Last Change'
                $apirunning = $cache:apiappservergrid2 | Where-Object { $_.State -eq "RUNNING" }
				
				if ([math]::ceiling($apiduration.TotalMinutes) -ge 60){ 
				$apioldest = 60} else { $apioldest = [math]::ceiling($apiduration.TotalMinutes) }
				
                New-UDGauge -PaddingVertical 8 -Width 250 -id 'APIAppServerActiveServers' -MaxValue 16 -NeedleColor white -StartColor green -EndColor red -value ($cache:apiappserverobject.'Active Servers') -Segments 4 -ValueText $('Total servers: ' + $($cache:apiappserverobject.'Active Servers'))
                New-UDGauge -PaddingVertical 8 -Width 250 -id 'APIAppServerRunningServers' -MaxValue 16 -NeedleColor white -StartColor green -EndColor red -value (@($apirunning).count)  -Segments 4 -ValueText $('Running servers: ' + $(@($apirunning).count))
                New-UDGauge -PaddingVertical 8 -Width 250 -id 'APIAppServerOldestChange' -MaxValue 60 -NeedleColor white -StartColor green -EndColor red -value $apioldest -Segments 6 -ValueText $('Oldest change: ' + $([string]$([math]::ceiling($apiduration.TotalMinutes)) + ' mins'))
            }
        }
    }

    New-UDRow {

        New-UDColumn -id 'appservercolumn5' -size 6 -Endpoint {
            New-UDGrid -id 'appservercolumn5grid' -Title " " -DefaultSortColumn 'Last Change' -AutoRefresh -RefreshInterval 250 -PageSize 50 -Endpoint {
                $cache:appservergrid2 | Out-UDGridData
            }
        }
        New-UDColumn -id 'appservercolumn6' -size 6 -Endpoint {
            New-UDGrid -id 'appservercolumn6grid' -Title " " -DefaultSortColumn 'Last Change' -AutoRefresh -RefreshInterval 250 -PageSize 50 -Endpoint {
                $cache:apiappservergrid2 | Out-UDGridData
            }
        }
    }
}





#$Htmlappserver = New-UDHtml "<div>$($clear.appserver -join "<br />`n")"
#$HtmlAPIappserver = New-UDHtml "<div>$($clear.APIappserver -join "<br />`n")"
#New-UDCard -Content { $Htmlappserver }
#New-UDCard -Content { $HtmlAPIappserver }


