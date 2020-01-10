New-UDPage  -Name "Availability"  -AuthorizationPolicy "IT" -Icon link -Content {

    New-UDCard -id Availabilitycard -Content {
        New-UDLayout -Columns 2 -Content {
            New-UDElement -Tag 'div' -Id 'a' -Endpoint {
                New-UDStyle -id 'Availabilitystyle' -Style '
                                            .card .card-content {
                                                font-size: 60px !important;
                                                text-align: center }' -Content {
                    New-UDGrid -Title " " -ID 'availabilitygrid' -AutoRefresh -RefreshInterval 250 -PageSize 10 -NoFilter -Endpoint {
                        $cache:status | Select-Object -First 6 | ForEach-Object {
                            $BgColor = '#8EA294'
                            $FontColor = '#E4EAED'
                            if ($_.'Status' -ne 'IN') {
                                $BgColor = '#63474D'
                                $FontColor = '#E4EAED'
                            }
                            [PSCustomObject]@{
                                'Name'   = New-UDElement -Tag 'div' -Attributes @{ style = @{ 'backgroundColor' = $BgColor; color = $fontColor } } -Content { $_.'Name' }
                                'Status' = New-UDElement -Tag 'div' -Attributes @{ style = @{ 'backgroundColor' = $BgColor; color = $fontColor } } -Content { $_.'Status' }
                            }
                        } |
                        Out-UDGridData
                    }
                }
            }
            New-UDElement -Tag 'div' -Id 'a2' -Endpoint {
                New-UDStyle -id 'Availabilitystyle2' -Style '
                                            .card .card-content {
                                                font-size: 60px !important }' -Content {
                    New-UDGrid -Title " " -ID 'Availabilitygrid2' -AutoRefresh -RefreshInterval 250 -PageSize 10 -NoFilter -Endpoint {
                        $cache:status | Select-Object -Last 6 | ForEach-Object {
                            $BgColor = '#8EA294'
                            $FontColor = '#E4EAED'
                            if ($_.'Status' -ne 'IN') {
                                $BgColor = '#63474D'
                                $FontColor = '#E4EAED'
                            }
                            [PSCustomObject]@{
                                'Name'   = New-UDElement -Tag 'div' -Attributes @{ style = @{ 'backgroundColor' = $BgColor; color = $fontColor } } -Content { $_.'Name' }
                                'Status' = New-UDElement -Tag 'div' -Attributes @{ style = @{ 'backgroundColor' = $BgColor; color = $fontColor } } -Content { $_.'Status' }
                            }
                        } |
                        Out-UDGridData
                    }
                }
            }
        }
    }
}


