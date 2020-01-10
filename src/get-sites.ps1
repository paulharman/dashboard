function get-sites {
    $sitesql = "SELECT [site_code]
    ,[site_name]
    ,[db_username]
    ,[db_password]
    ,[connection_name]
    FROM [MULEESB_UPGRADE].[dbo].[WEIGHMAN_SITECODE_DB_MAPPING]
    WHERE [active] = 1 AND LEN([site_code]) = 3
    ORDER BY [site_code]"

    $SQLsiteParams = @{
        query          = $sitesql
        Serverinstance = $cache:dataSource
        database       = $cache:database
        Credential     = $cache:cred
        As             = "PSObject"
    }

    $sites = Invoke-Sqlcmd2 @SQLsiteParams
    return $sites
}