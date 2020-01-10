#region SQL Stuff
# Database info
function get-auditITE {

  #set SQL script
  $sql = "SELECT CASE
  WHEN E3.[fk_audit_type_code] = '-1'
    THEN 'ERROR'
  ELSE 'SUCCESS'
  END AS RecordStatus,
E1.[fk_system_code] as SourceSystem,
'LP2' AS DestinationSystem,
E1.[business_id] as MMITEEntryID,
JSON_VALUE(CONVERT(VARCHAR(MAX),E1.[payload]), '$.shipmentId') as ShipmentID,
CASE WHEN JSON_VALUE(CONVERT(VARCHAR(MAX),E1.[payload]), '$.ticketType') = 'S' THEN E6.[Branch] ELSE E7.[Branch] END AS OriginatingITEBranch,
JSON_VALUE(CONVERT(VARCHAR(MAX),E1.[payload]), '$.sourceAccountNumber') as OriginAccount,
JSON_VALUE(CONVERT(VARCHAR(MAX),E1.[payload]), '$.destinationAccountNumber') as DestinationAccount,
JSON_VALUE(CONVERT(VARCHAR(MAX),E1.[payload]), '$.ticketType') as TicketType,
JSON_VALUE(CONVERT(VARCHAR(MAX),E1.[payload]), '$.branch.code') as LinkedBranch,
JSON_VALUE(CONVERT(VARCHAR(MAX),E1.[payload]), '$.commodities[0].code') as Commodity,
JSON_VALUE(CONVERT(VARCHAR(MAX),E1.[payload]), '$.stockLocations[0].code') as StockLocation,
JSON_VALUE(CONVERT(VARCHAR(MAX),E1.[payload]), '$.regionCode') as BookingRegion,
JSON_VALUE(CONVERT(VARCHAR(MAX),E1.[payload]), '$.username') as Username,
REPLACE (CONVERT(VARCHAR(MAX),E3.[payload]),char(10),'') as ErrorDetails,
REPLACE (CONVERT(VARCHAR(MAX),E4.[payload]),char(10),'') as ErrorDetailsExtended,
E1.[correlation_id],
E1.[created_time]
FROM [MULEESB_UPGRADE].[dbo].[AUDIT_DETAILS] E1 WITH (NOLOCK)
LEFT OUTER JOIN
(SELECT DISTINCT [correlation_id],[business_id], [fk_audit_type_code], CAST([payload] as NVARCHAR(MAX)) as [Payload]
FROM [MULEESB_UPGRADE].[dbo].[AUDIT_DETAILS] WITH (NOLOCK) WHERE [fk_audit_type_code] = '-1') as E3 on E1.[correlation_id] = E3.[correlation_id] and E1.[business_id] = E3.[business_id]
LEFT OUTER JOIN
(SELECT [api_audit_id],[correlation_id],[payload],[business_id],[fk_system_code], [fk_audit_type_code],[status_code]
FROM [MULEESB_UPGRADE].[dbo].[API_AUDIT] WITH (NOLOCK) WHERE [fk_system_code] = 'LP2' and [status_code] = '500') as E4 on E1.[correlation_id] = E4.[correlation_id] and E1.[business_id] = E4.[business_id]
LEFT OUTER JOIN
(SELECT [Site_Name], [Branch],[Disposal_Site],[Debtor_Number] FROM [MULEESB_UPGRADE].[dbo].[MM_SITE_LOOKUP] WITH (NOLOCK)) as E6
on JSON_VALUE(CONVERT(VARCHAR(MAX),E1.[payload]), '$.sourceAccountNumber') = E6.[Debtor_Number]
and JSON_VALUE(CONVERT(VARCHAR(MAX),E1.[payload]), '$.stockLocations[0].code') = E6.[Disposal_Site]
LEFT OUTER JOIN
(SELECT [Site_Name], [Branch],[Disposal_Site],[Debtor_Number] FROM [MULEESB_UPGRADE].[dbo].[MM_SITE_LOOKUP] WITH (NOLOCK)) as E7
on JSON_VALUE(CONVERT(VARCHAR(MAX),E1.[payload]), '$.destinationAccountNumber') = E7.[Debtor_Number]
and JSON_VALUE(CONVERT(VARCHAR(MAX),E1.[payload]), '$.stockLocations[0].code') = E7.[Disposal_Site]
WHERE E1.[fk_interface_code] = 'INTRANSIT_BOOKING'
and E1.[fk_error_code] IS NULL
and E1.[fk_audit_type_code] != '0'
and E1.[created_time] >= GETDATE() -1
and (CASE WHEN JSON_VALUE(CONVERT(VARCHAR(MAX),E1.[payload]), '$.ticketType') = 'P' AND JSON_VALUE(CONVERT(VARCHAR(MAX),E1.[payload]), '$.branch.code') <> '0' then '1' ELSE '0' END) = 0
order by E1.created_time ASC"

  $SQLParams = @{
    query          = $sql
    Serverinstance = $cache:dataSource
    database       = $cache:database
    Credential     = $cache:cred
    As             = "PSObject"
  }

  $auditITE = Invoke-Sqlcmd2 @SQLParams
  return $auditITE

}

