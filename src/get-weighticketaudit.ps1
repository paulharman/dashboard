function Get-WeighticketAudit {
    Param ([int]$TransactionNo)
    $cache:dataSource = 'IFVMESBSQL1'
    $cache:database = 'MULEESB_UPGRADE'
    $cache:cred = New-Object System.Management.Automation.PSCredential ($username, $password)

    #set SQL script
    $sql = "SELECT [audit_detail_id]
,[correlation_id]
,[fk_audit_type_code]
,[payload]
,[created_time]
,[fk_error_code]
FROM [MULEESB_UPGRADE].[dbo].[AUDIT_DETAILS]
WHERE business_id = '$($TransactionNo)'
ORDER BY created_time desc"

    $SQLweighticketauditParams = @{
        query          = $sql
        Serverinstance = $cache:dataSource
        database       = $cache:database
        Credential     = $cache:cred
        As             = "PSObject"
    }

    $result = Invoke-Sqlcmd2 @SQLweighticketauditParams
    return $result
}