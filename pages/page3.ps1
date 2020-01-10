New-UDPage  -Name "Weighman Tickets"  -AuthorizationPolicy "IT" -Icon link -Content {
    New-UDCard -Content {
        New-UDRow -Columns {
            New-UDColumn -SmallOffset 2 -Size 3  -Content {
                # -BrowserDefault
                New-UDSelect -Id "siteselect"  -Label " " -Option {
                    New-UDSelectOption -Name "Select site" -Value " "
                    $cache:sites = get-sites
                    $cache:sites | ForEach-Object { New-UDSelectOption -Name "$($_.site_code) $($_.site_name)" -Value "$($_.site_code)" }

                } -OnChange {
                    $Session:SiteSelected = $eventdata
                    #  Show-UDToast -Message "Changed to $($Session:SiteSelected)" -Duration 5000
                    #  Sync-UDElement -Id Heading
                }
            }
            New-UDColumn -Size 3 -Content {

                New-UDDatePicker -Id "Picker"
            }
            New-UDColumn -Size 3 -Content {
                New-UDHtml -Markup "<br></br>"
                New-UDButton -Id "getticketbutton" -Text "Get tickets" -OnClick {
                    $from = (Get-UDElement -Id "Picker").Attributes.from
                    [datetime]$s = "$from"
                    $session:Start = Get-Date $s -format 'yyyy-MM-dd'
                    $to = (Get-UDElement -Id "Picker").Attributes.to
                    [datetime]$e = "$to"
                    $session:End = Get-Date $e -format 'yyyy-MM-dd'
                    Sync-UDElement -id Heading
                    #Show-UDToast -message "You Selected $Start until $End" -duration 5000 -Position center
                }
            }
        }

        New-UDRow   -Columns {
            New-UDColumn -id 'Heading' -SmallOffset 4 -SmallSize 4 -Endpoint {
                Write-UDLog -Level info -Message "Site is |$($Session:SiteSelected)|"
                if ($Session:SiteSelected -Ne $null -and $Session:SiteSelected -ne " " -and $Session:SiteSelected -ne "") {
                    New-UDGrid -id 'weighticketgrid' -Title "Showing weightickets for $($Session:SiteSelected)" -PageSize 50  -Endpoint {
                        if ($Session:SiteSelected -Ne $null -and $Session:SiteSelected -ne " " -and $Session:SiteSelected -ne "") {
                            [string]$username = $cache:sites | Where-Object { $($_.site_Code) -eq $($Session:SiteSelected) } | Select-Object db_username -ExpandProperty db_username
                            [string]$password = $cache:sites | Where-Object { $($_.site_Code) -eq $($Session:SiteSelected) } | Select-Object db_password -ExpandProperty db_password
                            $datasource = $cache:sites | Where-Object { $($_.site_Code) -eq $($Session:SiteSelected) } | Select-Object connection_name -ExpandProperty connection_name
                            $cred = New-Object System.Management.Automation.PSCredential ($username, (ConvertTo-SecureString $password -AsPlainText -Force))

                            $TicketSQL = "SELECT [ID]
                                            ,[SiteCode]
                                            ,[RegistrationCode]
                                            ,[TransactionDate]
                                            ,[TransactionNo]
                                            ,[SequenceCode]
                                            FROM [weighman].[dbo].[wmTransaction]
                                            WHERE TransactionDate > '$($session:Start) 00:00:00.000' AND TransactionDate < '$($session:End) 23:59:59.000'
                                            ORDER BY TransactionNo asc"

                            $SQLticketParams = @{
                                query          = $TicketSQL
                                Serverinstance = $dataSource
                                database       = 'weighman'
                                Credential     = $cred
                                As             = "PSObject"
                            }
                            Invoke-Sqlcmd2 @SQLticketParams | ForEach-Object {
                                [PSCustomObject]@{
                                    #ID               = $_.ID
                                    SiteCode         = $_.SiteCode
                                    RegistrationCode = $_.RegistrationCode
                                    TransactionDate  = $_.TransactionDate
                                    TransactionNo    = $_.TransactionNo
                                    SequenceCode     = $_.SequenceCode
                                    Resend           = New-UDButton -Text "Details" -onclick {
                                        Show-UDModal -Width '98%' -Content {
                                            New-UDGrid -id 'auditdetailgrid' -Title "Showing audit details for $($_.TransactionNo)" -AutoRefresh -RefreshInterval 300 -PageSize 50  -Endpoint {
                                                Get-WeighticketAudit -TransactionNo $_.TransactionNo | Out-UDGridData
                                            }
                                            New-UDButton -Text "Replay"  -OnClick {
                                                Replay-Weighticket -TransactionNo $_.TransactionNo -TransactionID $_.ID -sitecode $_.SiteCode
                                                Show-UDToast -Message "Replayed $($_.TransactionNo)" -Duration 10000
                                            }
                                        }

                                    }
                                }
                            } | Out-UDGridData



                            Write-UDLog -Level Info -Message "Username = $($username) Password = $($password) Datasource = $($datasource) Ticketsql = $($TicketSQL)"

                        }
                    }
                }
                else {
                    New-UDHeading  -Text "Waiting for selection..."
                }
            }
        }
    }
}