New-UDPage -Name "ITE Graphs" -Icon link  -AuthorizationPolicy "IT" -Content {
    New-UDLayout -Columns 2 -Content {
        New-UDChart -id 'splitbyregionchart' -Title "Split by Region"  -Endpoint {
            $Cache:Data | Group-Object BookingRegion -NoElement | Out-UDChartData -LabelProperty Name -DataProperty count -DatasetLabel "Region"
        } -type Pie -AutoRefresh -RefreshInterval 300
        New-UDCard -Text "2"
    }
    New-UDLayout -Columns 1 -Content {
        New-UDCard
    }
}