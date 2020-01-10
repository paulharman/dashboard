New-UDPage -Name "ITE Overview" -Icon home -AuthorizationPolicy "IT" -Content {
    New-UDGrid -Title "Failed Transactions still failed" -ID Failed -AutoRefresh -RefreshInterval 250 -PageSize 10 -DefaultSortDescending -DefaultSortColumn 'created_time' -Endpoint {
        #$Cache:Data = get-auditITE
        $left = $Cache:Data | Where-Object { $_.RecordStatus -eq "ERROR" }
        $right = $Cache:Data | Where-Object { $_.RecordStatus -eq "SUCCESS" }

        $exclude = [System.Collections.Generic.HashSet[Int]][Int[]]($right.MMITEEntryID)

        $left | Where-Object { -not $exclude.Contains($_.MMITEEntryID) } | Where-Object { $_.ErrorDetailsExtended -notlike "*status 30*" } | Group-Object MMITEEntryID | ForEach-Object { $_.Group | Sort-Object created_time -Descending | Select-Object -First 1 } |
        ForEach-Object {
            [PSCustomObject]@{
                Status               = $_.RecordStatus
                ITE_ID               = $_.MMITEEntryID
                ShipmentID           = $_.ShipmentID
                OriginAccount        = $_.OriginAccount
                DestinationAccount   = $_.DestinationAccount
                TicketType           = $_.TicketType
                Username             = $_.Username
                ErrorDetails         = $_.ErrorDetails -replace 'UpdateMMAndValidationCheck=ValidationException: ', ''
                #ErrorDetailsExtended = $_.ErrorDetailsExtended
                created_time         = $_.created_time
                ShowAudit            = New-UDButton -Text "Details" -onclick {
                    Show-UDModal -Width '40%' -Content {
                        New-UDCard -Content {
                          New-UDHtml -Markup "<br></br>"
                            $_.ErrorDetailsExtended
                            New-UDHtml -Markup "<br></br>"
                        }
                        }
                }
                Resend               = New-UDButton -Text "Resend" -onclick {
                    Update-ITE -IncomingShipmentID $_.shipmentID
                    Show-UDToast -Message "Replayed $($_.ShipmentID)" -Duration 10000
                    Sync-UDElement -Id sql
                    Sync-UDElement -Id Failed
                }
            }
        } |
        Out-UDGridData
    }

    New-UDGrid -id 'alltransactionsgrid' -Title "All Transactions" -AutoRefresh -RefreshInterval 300 -PageSize 10 -DefaultSortDescending -DefaultSortColumn 'created_time' -Endpoint {
        $Cache:Data | Select-Object -Property RecordStatus, MMITEEntryID, ShipmentID, OriginAccount, DestinationAccount, TicketType, Username, BookingRegion, Commodity, @{Name = 'ErrorDetails'; Expression = { $_.ErrorDetails -replace 'UpdateMMAndValidationCheck=ValidationException: ', '' } }, created_time | Out-UDGridData
    }
}