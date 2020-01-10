function Replay-Weighticket {
    Param ([int]$TransactionNo,
        [guid]$TransactionID,
        [string]$sitecode)
    [string]$username = $cache:sites | Where-Object { $($_.site_Code) -eq $($Session:SiteSelected) } | Select-Object db_username -ExpandProperty db_username
    [string]$password = $cache:sites | Where-Object { $($_.site_Code) -eq $($Session:SiteSelected) } | Select-Object db_password -ExpandProperty db_password
    $datasource = $cache:sites | Where-Object { $($_.site_Code) -eq $($Session:SiteSelected) } | Select-Object connection_name -ExpandProperty connection_name
    $cred = New-Object System.Management.Automation.PSCredential ($username, (ConvertTo-SecureString $password -AsPlainText -Force))

    $TicketSQL = "DECLARE @TransactionXML AS XML
    DECLARE @TransactionCleaning AS XML
    DECLARE @TransactionComposition AS XML

    SET @TransactionXML = (

    SELECT [dbo].[wmTransaction].[RegistrationCode]
            ,[dbo].[wmTransaction].[SiteCode]
            ,[dbo].[wmTransaction].[StationCode]
            ,[dbo].[wmTransaction].[UserName]
            ,[dbo].[wmTransaction].[UserName2]
            ,[dbo].[wmTransaction].[SequenceNo]
            ,[dbo].[wmTransaction].[SequenceTotal]
            ,CONVERT(VARCHAR, [dbo].[wmTransaction].[TransactionDate], 103)+ ' ' + CONVERT(VARCHAR(8), [dbo].[wmTransaction].[TransactionDate], 108) AS [TransactionDate]
            ,[dbo].[wmTransaction].[TransactionNo]
            ,[dbo].[wmTransaction].[FirstTicketNo]
            ,[dbo].[wmTransaction].[SecondTicketNo]
            ,[dbo].[wmTransaction].[WeighingMode]
            ,[dbo].[wmTransaction].[SequenceCode]
            ,[dbo].[wmTransaction].[ChargeType]
            ,[dbo].[wmTransaction].[PaymentMethod]
            ,[dbo].[wmTransaction].[VehicleTypeCode]
            ,[dbo].[wmTransaction].[InspectedFlag]
            ,[dbo].[wmTransaction].[ContractCode]
            ,[dbo].[wmTransaction].[ContractItemCode]
            ,[dbo].[wmTransaction].[CompanyCode]
            ,[dbo].[wmTransaction].[HaulierCode]
            ,[dbo].[wmTransaction].[CommodityCode]
            ,[dbo].[wmTransaction].[CommodityDetailCode]
            ,[dbo].[wmTransaction].[AuthorisationCode]
            ,[dbo].[wmTransaction].[CellCode]
            ,[dbo].[wmTransaction].[CategoryCode]
            ,[dbo].[wmTransaction].[ContainmentCode]
            ,[dbo].[wmTransaction].[SourceCode]
            ,[dbo].[wmTransaction].[DestinationCode]
            ,[dbo].[wmTransaction].[DriverCode]
            ,[dbo].[wmTransaction].[UDF1]
            ,[dbo].[wmTransaction].[UDF2]
            ,[dbo].[wmTransaction].[UDF3]
            ,[dbo].[wmTransaction].[UDF4]
            ,[dbo].[wmTransaction].[UDF5]
            ,[dbo].[wmTransaction].[UDF6]
            ,[dbo].[wmTransaction].[UDF7]
            ,[dbo].[wmTransaction].[UDF8]
            ,[dbo].[wmTransaction].[UDF9]
            ,[dbo].[wmTransaction].[UDF10]
            ,[dbo].[wmTransaction].[UDF11]
            ,[dbo].[wmTransaction].[UDF12]
            ,[dbo].[wmTransaction].[UDF13]
            ,[dbo].[wmTransaction].[UDF14]
            ,[dbo].[wmTransaction].[UDF15]
            ,[dbo].[wmTransaction].[UDF16]
            ,[dbo].[wmTransaction].[UDF17]
            ,[dbo].[wmTransaction].[UDF18]
            ,[dbo].[wmTransaction].[UDF19]
            ,[dbo].[wmTransaction].[UDF20]
            ,CONVERT(varchar, CAST([dbo].[wmTransaction].[FirstWeight] AS int), 1) AS [FirstWeight]
            ,[dbo].[wmTransaction].[FirstUnits]
            ,CONVERT(VARCHAR, [dbo].[wmTransaction].[FirstDate], 103)+ ' ' + CONVERT(VARCHAR(8), [dbo].[wmTransaction].[FirstDate], 108) AS [FirstDate]
            ,[dbo].[wmTransaction].[FirstConsec]
            ,[dbo].[wmTransaction].[FirstID]
            ,[dbo].[wmTransaction].[FirstTrailerCode]
            ,CONVERT(varchar, CAST([dbo].[wmTransaction].[FirstTrailerWeight] AS int), 1) AS [FirstTrailerWeight]
            ,[dbo].[wmTransaction].[FirstTrailerUnits]
            ,CONVERT(VARCHAR, [dbo].[wmTransaction].[FirstTrailerDate], 103)+ ' ' + CONVERT(VARCHAR(8), [dbo].[wmTransaction].[FirstTrailerDate], 108) AS [FirstTrailerDate]
            ,[dbo].[wmTransaction].[FirstTrailerConsec]
            ,[dbo].[wmTransaction].[FirstTrailerID]
            ,CONVERT(varchar, CAST([dbo].[wmTransaction].[SecondWeight] AS int), 1) AS [SecondWeight]
            ,[dbo].[wmTransaction].[SecondUnits]
            ,CONVERT(VARCHAR, [dbo].[wmTransaction].[SecondDate], 103)+ ' ' + CONVERT(VARCHAR(8), [dbo].[wmTransaction].[SecondDate], 108) AS [SecondDate]
            ,[dbo].[wmTransaction].[SecondConsec]
            ,[dbo].[wmTransaction].[SecondID]
            ,[dbo].[wmTransaction].[SecondTrailerCode]
            ,CONVERT(varchar, CAST([dbo].[wmTransaction].[SecondTrailerWeight] AS int), 1) AS [SecondTrailerWeight]
            ,[dbo].[wmTransaction].[SecondTrailerUnits]
            ,CONVERT(VARCHAR, [dbo].[wmTransaction].[SecondTrailerDate], 103)+ ' ' + CONVERT(VARCHAR(8), [dbo].[wmTransaction].[SecondTrailerDate], 108) AS [SecondTrailerDate]
            ,[dbo].[wmTransaction].[SecondTrailerConsec]
            ,[dbo].[wmTransaction].[SecondTrailerID]
            ,CONVERT(varchar, CAST([dbo].[wmTransaction].[NetWeight] AS int), 1) AS [NetWeight]
            ,CONVERT(varchar, CAST([dbo].[wmTransaction].[AdjustedNetWeight] AS int), 1) AS [AdjustedNetWeight]
            ,[dbo].[wmTransaction].[NoContainmentUnits]
            ,[dbo].[wmTransaction].[ContainmentConversionTitle]
            ,[dbo].[wmTransaction].[ConversionFactor]
            ,CAST(ROUND([dbo].[wmTransaction].[UnitConversionQuantity], 0) AS INT) AS [UnitConversionQuantity]
            ,[dbo].[wmTransaction].[UnitConversionTitle]
            ,[dbo].[wmTransaction].[UnitConversionFactor]
            ,CONVERT(varchar, CAST([dbo].[wmTransaction].[GoodsCharge] AS money), 1) AS [GoodsCharge]
            ,CONVERT(varchar, CAST([dbo].[wmTransaction].[VATCharge] AS money), 1) AS [VATCharge]
            ,[dbo].[wmTransaction].[VATBand]
            ,CONVERT(varchar, CAST([dbo].[wmTransaction].[VATRate] AS money), 1) AS VATRate
            ,CONVERT(varchar, CAST([dbo].[wmTransaction].[LandfillTaxCharge] AS money), 1) AS [LandfillTaxCharge]
            ,[dbo].[wmTransaction].[LandfillTaxBand]
            ,CONVERT(varchar, CAST([dbo].[wmTransaction].[LandFillTaxRate] AS money), 1) AS [LandFillTaxRate]
            ,CONVERT(varchar, CAST([dbo].[wmTransaction].[TotalPrice] AS money), 1) AS [TotalPrice]
            ,CONVERT(varchar, CAST([dbo].[wmTransaction].[AmountPaid] AS money), 1) AS [AmountPaid]
            ,[dbo].[wmTransaction].[CompanyDescription]
            ,[dbo].[wmTransaction].[HaulierDescription]
            ,[dbo].[wmTransaction].[SourceDescription]
            ,[dbo].[wmTransaction].[DestinationDescription]
            ,[dbo].[wmTransaction].[DriverDescription]
            ,[dbo].[wmTransaction].[AmendmentType]
            ,[dbo].[wmTransaction].[InvoiceNo]
            ,CONVERT(VARCHAR, [dbo].[wmTransaction].[InvoiceDate], 103)+ ' ' + CONVERT(VARCHAR(8), [dbo].[wmTransaction].[InvoiceDate], 108) AS [InvoiceDate]
            ,CONVERT(VARCHAR, [dbo].[wmTransaction].[InvoiceTaxPoint], 103)+ ' ' + CONVERT(VARCHAR(8), [dbo].[wmTransaction].[InvoiceTaxPoint], 108) AS [InvoiceTaxPoint]
            ,[dbo].[wmTransaction].[CSVGenerated]
            ,[dbo].[wmTransaction].[Auxilliary]
            ,[dbo].[wmTransaction].[SequenceCount]
            ,[dbo].[wmTransaction].[ShiftNumber]
            ,[dbo].[wmTransaction].[NominalWeightCode]
            ,[dbo].[wmTransaction].[NominalWeight]
            ,[dbo].[wmTransaction].[NominalWeightTolerance]
            ,[dbo].[wmTransaction].[NominalWeightUnits]
            ,CONVERT(varchar, CAST([dbo].[wmTransaction].[DeliveryCharge] AS money), 1) AS [DeliveryCharge]
            ,[dbo].[wmTransaction].[DeliveryBand]
            ,CONVERT(varchar, CAST([dbo].[wmTransaction].[DeliveryRate] AS money), 1) AS [DeliveryRate]
            ,CONVERT(varchar, CAST([dbo].[wmTransaction].[ExchangeRate] AS money), 1) AS [ExchangeRate]
            ,[dbo].[wmTransaction].[MedicationCode]
            ,CONVERT(VARCHAR, [dbo].[wmTransaction].[UseByDate], 103)+ ' ' + CONVERT(VARCHAR(8), [dbo].[wmTransaction].[UseByDate], 108) AS [UseByDate]
            ,CONVERT(VARCHAR, [dbo].[wmTransaction].[WithdrawalDate], 103)+ ' ' + CONVERT(VARCHAR(8), [dbo].[wmTransaction].[WithdrawalDate], 108) AS [WithdrawalDate]
            ,[dbo].[wmTransaction].[IsUnmanned]
            ,CONVERT(varchar, CAST([dbo].[wmTransaction].[PricePerUnit] AS money), 1) AS [PricePerUnit]
            ,CONVERT(varchar, CAST([dbo].[wmTransaction].[PricePerTonne] AS money), 1) AS [PricePerTonne]
            ,[dbo].[wmTransaction].[UnitChargeType]
            ,CONVERT(varchar, CAST([dbo].[wmTransaction].[LandfillVAT] AS money), 1) AS [LandfillVAT]
            ,CONVERT(varchar, CAST([dbo].[wmTransaction].[GoodsVAT] AS money), 1) AS [GoodsVAT]
            ,CONVERT(varchar, CAST([dbo].[wmTransaction].[DeliveryVAT] AS money), 1) AS [DeliveryVAT]
            ,[dbo].[wmTransaction].[RecordStatus]
            ,[dbo].[wmTransaction].[CurrencyCode]
            ,CONVERT(varchar, CAST([dbo].[wmTransaction].[ConversionRate] AS money), 1) AS [ConversionRate]
            ,[dbo].[wmTransaction].[CurrencySymbol]
            ,[dbo].[wmTransaction].[TransactionType]
            ,[dbo].[wmTransaction].[InvoiceCopy]
            ,CONVERT(varchar, CAST([dbo].[wmTransaction].[SalePricePerT] AS money), 1) AS [SalePricePerT]
            ,CONVERT(varchar, CAST([dbo].[wmTransaction].[CostPricePerT] AS money), 1) AS [CostPricePerT]
            ,[dbo].[wmTransaction].[NominalCode]
            ,[dbo].[wmTransaction].[MultiID]
            ,[dbo].[wmTransaction].[MultiStatus]
            ,CONVERT(varchar, CAST([dbo].[wmTransaction].[DeliveryCost] AS money), 1) AS [DeliveryCost]
            ,[dbo].[wmTransaction].[CommodityType]
            ,[dbo].[wmTransaction].[CompanyType]
            ,[dbo].[wmTransaction].[CardIdentityNumber]
            ,[dbo].[wmTransaction].[Image1]
            ,[dbo].[wmTransaction].[Image2]
            ,[dbo].[wmTransaction].[Image3]
            ,[dbo].[wmTransaction].[Image4]
            ,CONVERT(VARCHAR, [dbo].[wmTransaction].[TimeEnteredSite], 103)+ ' ' + CONVERT(VARCHAR(8), [dbo].[wmTransaction].[TimeEnteredSite], 108) AS [TimeEnteredSite]
            ,CONVERT(VARCHAR, [dbo].[wmTransaction].[TimeLeftSite], 103)+ ' ' + CONVERT(VARCHAR(8), [dbo].[wmTransaction].[TimeLeftSite], 108) AS [TimeLeftSite]
            ,[dbo].[wmTransaction].[WaitingTimeSite]
            ,[dbo].[wmTransaction].[WaitingTime]
            ,[dbo].[wmTransaction].[OnSiteWaitingTimeCharge]
            ,[dbo].[wmTransaction].[OnSiteWaitingTimeBand]
            ,[dbo].[wmTransaction].[OnSiteWaitingTimeRate]
            ,[dbo].[wmTransaction].[OffSiteWaitingTimeCharge]
            ,[dbo].[wmTransaction].[OffSiteWaitingTimeBand]
            ,[dbo].[wmTransaction].[OffSiteWaitingTimeRate]
            ,CONVERT(varchar, CAST([dbo].[wmTransaction].[TaxReliefRate] AS money), 1) AS [TaxReliefRate]
            ,CONVERT(varchar, CAST([dbo].[wmTransaction].[TaxReliefCharge] AS money), 1) AS [TaxReliefCharge]
            ,[dbo].[wmTransaction].[ProofofDelivery]
            ,[dbo].[wmTransaction].[ProofofComment]
            ,[dbo].[wmTransaction].[ScheduleNumberName]
            ,[dbo].[wmTransaction].[FleetNo]
            ,[dbo].[wmTransaction].[Notes]
            ,[dbo].[wmTransaction].[CustomerOrderNo]
            ,[dbo].[wmTransaction].[DriverTicketName]
            ,[dbo].[wmTransaction].[FleetDescription]
            ,[dbo].[wmTransaction].[VehicleTypeDescription]
            ,[dbo].[wmTransaction].[ToCellCode]
            ,[dbo].[wmTransaction].[ToCellCodeDescription]
            ,[dbo].[wmTransaction].[FromCellCodeDescription]
            ,[dbo].[wmTransaction].[AuthorisationNo]
            ,[dbo].[wmTransaction].[ScheduleDescription]
            ,CONVERT(varchar, CAST([dbo].[wmTransaction].[TotalCharge] AS money), 1) AS [TotalCharge]
            ,[dbo].[wmTransaction].[FirstWeightTime]
            ,[dbo].[wmTransaction].[SecondWeightTime]
            ,[dbo].[wmTransaction].[CommodityDescription]
            ,CONVERT(VARCHAR, [dbo].[wmTransaction].[FirstWeightDate], 103)+ ' ' + CONVERT(VARCHAR(8), [dbo].[wmTransaction].[FirstWeightDate], 108) AS [FirstWeightDate]
            ,CONVERT(VARCHAR, [dbo].[wmTransaction].[SecondWeightDate], 103)+ ' ' + CONVERT(VARCHAR(8), [dbo].[wmTransaction].[SecondWeightDate], 108) AS [SecondWeightDate]
            ,CASE WHEN [dbo].[wmCompany].[Address1] IS NOT NULL THEN [dbo].[wmCompany].[Address1]  ELSE '' END AS  [CompanyAddress1]
            ,CASE WHEN [dbo].[wmCompany].[Address2] IS NOT NULL THEN [dbo].[wmCompany].[Address2]  ELSE '' END AS  [CompanyAddress2]
            ,CASE WHEN [dbo].[wmCompany].[Address3] IS NOT NULL THEN [dbo].[wmCompany].[Address3]  ELSE '' END AS  [CompanyAddress3]
            ,CASE WHEN [dbo].[wmCompany].[Address4] IS NOT NULL THEN [dbo].[wmCompany].[Address4]  ELSE '' END AS  [CompanyAddress4]
            ,CASE WHEN [dbo].[wmCompany].[Address5] IS NOT NULL THEN [dbo].[wmCompany].[Address5]  ELSE '' END AS  [CompanyAddress5]
            ,CASE WHEN [dbo].[wmCompany].[Contact] IS NOT NULL THEN [dbo].[wmCompany].[Contact]  ELSE '' END AS  [CompanyContact]
            ,CASE WHEN [dbo].[wmHaulier].[Issuer] IS NOT NULL THEN [dbo].[wmHaulier].[Issuer] ELSE '' END AS [HaulierIssuer]
            ,CASE WHEN [dbo].[wmHaulier].[CarrierNo] IS NOT NULL THEN [dbo].[wmHaulier].[CarrierNo] ELSE '' END  AS [HaulierCarrierNo]
            ,CASE WHEN [dbo].[wmHaulier].[ExpiryDate] IS NOT NULL THEN CONVERT(VARCHAR, [dbo].[wmHaulier].[ExpiryDate], 103) ELSE '' END AS [HaulierExpiryDate]
            ,CASE WHEN [dbo].[wmHaulier].[Address1] IS NOT NULL THEN [dbo].[wmHaulier].[Address1] ELSE '' END AS [HaulierAddress1]
            ,CASE WHEN [dbo].[wmHaulier].[Address2] IS NOT NULL THEN [dbo].[wmHaulier].[Address2] ELSE '' END AS [HaulierAddress2]
            ,CASE WHEN [dbo].[wmHaulier].[Address3] IS NOT NULL THEN [dbo].[wmHaulier].[Address3] ELSE '' END AS [HaulierAddress3]
            ,CASE WHEN [dbo].[wmHaulier].[Address4] IS NOT NULL THEN [dbo].[wmHaulier].[Address4] ELSE '' END AS [HaulierAddress4]
            ,CASE WHEN [dbo].[wmHaulier].[Address5] IS NOT NULL THEN [dbo].[wmHaulier].[Address5] ELSE '' END AS [HaulierAddress5]
            ,CASE WHEN [dbo].[wmHaulier].[Telephone] IS NOT NULL THEN [dbo].[wmHaulier].[Telephone] ELSE '' END AS [HaulierTelephone]
            ,CASE WHEN [dbo].[wmHaulier].[Fax] IS NOT NULL THEN [dbo].[wmHaulier].[Fax] ELSE '' END AS [HaulierFax]
            ,CASE WHEN [dbo].[wmHaulier].[Contact] IS NOT NULL THEN [dbo].[wmHaulier].[Contact] ELSE '' END AS [HaulierContact]
          ,CASE WHEN [dbo].[wmContract].[Description] IS NOT NULL THEN [dbo].[wmContract].[Description] ELSE '' END AS [ContractDescription]
          ,CASE WHEN [dbo].[wmContract].[StartDate] IS NOT NULL THEN CONVERT(VARCHAR, [dbo].[wmContract].[StartDate], 103) ELSE '' END AS [ContractStartDate]
          ,CASE WHEN [dbo].[wmContract].[ExpiryDate] IS NOT NULL THEN CONVERT(VARCHAR, [dbo].[wmContract].[ExpiryDate], 103) ELSE '' END AS [ContractExpiryDate]
          ,CASE WHEN [dbo].[wmContract].[Address1] IS NOT NULL THEN [dbo].[wmContract].[Address1] ELSE '' END AS [ContractAddress1]
          ,CASE WHEN [dbo].[wmContract].[Address2] IS NOT NULL THEN [dbo].[wmContract].[Address2] ELSE '' END AS [ContractAddress2]
          ,CASE WHEN [dbo].[wmContract].[Address3] IS NOT NULL THEN [dbo].[wmContract].[Address3] ELSE '' END AS [ContractAddress3]
          ,CASE WHEN [dbo].[wmContract].[Address4] IS NOT NULL THEN [dbo].[wmContract].[Address4] ELSE '' END AS [ContractAddress4]
          ,CASE WHEN [dbo].[wmContract].[Address5] IS NOT NULL THEN [dbo].[wmContract].[Address5] ELSE '' END AS [ContractAddress5]
          ,CASE WHEN [dbo].[wmContract].[Telephone] IS NOT NULL THEN [dbo].[wmContract].[Telephone] ELSE '' END AS [ContractTelephone]
          ,CASE WHEN [dbo].[wmContract].[Fax] IS NOT NULL THEN [dbo].[wmContract].[Fax] ELSE '' END AS [ContractFax]
          ,CASE WHEN [dbo].[wmContract].[Contact] IS NOT NULL THEN [dbo].[wmContract].[Contact] ELSE '' END AS [ContractContact]
          ,[dbo].[wmSysSequences].[Description] AS [SequenceDescription]
          ,[dbo].[wmTransaction].[UserName2]
          ,[dbo].[wmTransaction].[MaxGrossLimit]
          ,CASE WHEN MaxGrossExceeded = 0 THEN 'NO'  ELSE 'YES' END AS  'MaxGrossExceeded',
          [dbo].[wmTransaction].[LoadNumberCode]
      FROM [dbo].[wmTransaction] LEFT OUTER JOIN
           [dbo].[wmCompany] ON [dbo].[wmTransaction].[CompanyCode] = [dbo].[wmCompany].[Code] AND [dbo].[wmTransaction].[CompanyType] = [dbo].[wmCompany].[Type]
           LEFT OUTER JOIN
           [dbo].[wmHaulier] ON [dbo].[wmTransaction].[HaulierCode] = [dbo].[wmHaulier].[Code]
           LEFT OUTER JOIN
           [dbo].[wmContract] ON [dbo].[wmTransaction].[ContractCode] = [dbo].[wmContract].[Code]
           LEFT OUTER JOIN
           [dbo].[wmSysSequences] ON [dbo].[wmTransaction].[SequenceCode] = [dbo].[wmSysSequences].[Code]
      WHERE [dbo].[wmTransaction].[ID] = '$($TransactionID)'
      FOR XML PATH('')
      )


      SET @TransactionCleaning = (
              SELECT
                [PrevLoad1CodeW1],
                [PrevLoad1CodeW1Desc],
                [CleanMethod1CodeW1],
                [CleanMethod1CodeW1Desc],
                [PrevLoad2CodeW1],
                [PrevLoad2CodeW1Desc],
                [CleanMethod2CodeW1],
                [CleanMethod2CodeW1Desc],
                [PrevLoad3CodeW1],
                [PrevLoad3CodeW1Desc],
                [CleanMethod3CodeW1],
                [CleanMethod3CodeW1Desc],
                CASE WHEN [CleaningProcessInspectedW1] = 0 THEN 'NO'  ELSE 'YES' END AS  'CleaningProcessInspectedW1',
                [PrevLoad1CodeW2],
                [PrevLoad1CodeW2Desc],
                [CleanMethod1CodeW2],
                [CleanMethod1CodeW2Desc],
                [PrevLoad2CodeW2],
                [PrevLoad2CodeW2Desc],
                [CleanMethod2CodeW2],
                [CleanMethod2CodeW2Desc],
                [PrevLoad3CodeW2],
                [PrevLoad3CodeW2Desc],
                [CleanMethod3CodeW2],
                [CleanMethod3CodeW2Desc],
                CASE WHEN [CleaningProcessInspectedW2] = 0 THEN 'NO'  ELSE 'YES' END AS  'CleaningProcessInspectedW2'
            FROM [dbo].[wmTransactionLoadClean]
            WHERE TransactionID = '$($TransactionID)'
            FOR XML PATH('')
      )

      --CIM added for Compositions
      SET @TransactionComposition = (
            SELECT
                [Code] AS 'CpsnCollate',
                [EUCode] AS 'CpsnEUCode',
                [Composition] AS 'CpsnPercent',
                CONVERT(VARCHAR, [EffectiveDate], 103) + ' ' + CONVERT(VARCHAR, [EffectiveDate], 108) AS 'CpsnEffDate'
                --[EffectiveDate] AS 'CpsnEffDate'
            FROM [dbo].[wmComposition]
            WHERE TransactionNo = '$($Transactionno)'
            ORDER BY Code
            FOR XML PATH('Composition'),ELEMENTS
      )

                    SELECT (SELECT @TransactionXML , @TransactionCleaning , @TransactionComposition FOR XML RAW('Record'), ELEMENTS, ROOT('wmTransaction')) AS xml
    "

    $SQLticketreplayParams = @{
        query          = $TicketSQL
        Serverinstance = $dataSource
        database       = 'weighman'
        Credential     = $cred
        As             = "PSObject"
    }

    $XMLoutput = Invoke-Sqlcmd2 @SQLticketreplayParams
    $XMLoutput.xml | Format-XML | Out-File -FilePath "\\viking2015\groups\IT\MuleSoft\weighman\weigh-ticket\prod\work\$($sitecode)_$($Transactionno)_REPLAY.wmx"  -Encoding UTF8
}