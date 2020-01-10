function Update-ITE {
    Param ([int]$IncomingShipmentID)
    $updatesql = "UPDATE dbo.Transit_Vehicle_Staging
    SET LastModified = GETDATE()
    WHERE Shipment_ID = $IncomingShipmentID"

    $SQUpdateParams = @{
        query          = $updatesql
        Serverinstance = 'ifvmsql05'
        database       = 'SitaMaterials_Live'
        Credential     = $cred
        As             = "PSObject"
    }

    Invoke-Sqlcmd2 @SQUpdateParams
}