[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")

Function get-SharepointFile([string]$UserName, [string]$Password, [string]$FileUrl, [string]$DownloadPath) {


    if ([string]::IsNullOrEmpty($Password)) {
        $SecurePassword = Read-Host -Prompt "Enter the password" -AsSecureString
    }
    else {
        $SecurePassword = $Password | ConvertTo-SecureString -AsPlainText -Force
    }
    $fileName = [System.IO.Path]::GetFileName($FileUrl)
    $downloadFilePath = [System.IO.Path]::Combine($DownloadPath, $fileName)


    $client = New-Object System.Net.WebClient
    $client.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($UserName, $SecurePassword)
    $client.Headers.Add("X-FORMS_BASED_AUTH_ACCEPTED", "f")
    $client.DownloadFile($FileUrl, $downloadFilePath)
    $client.Dispose()
}
function get-availability {
    get-SharepointFile -UserName "upn" -Password "password" -FileUrl 'url/Peoplestatus.xlsx' -DownloadPath "C:\dashboards\appsupport\"

    $people =
    @([pscustomobject]@{Name = "Andy"; StartRow = 3; EndRow = 3; StartColumn = 1; EndColumn = 2 },
        [pscustomobject]@{Name = "Charlene"; StartRow = 4; EndRow = 4; StartColumn = 1; EndColumn = 2 },
        [pscustomobject]@{Name = "Hammad"; StartRow = 5; EndRow = 5; StartColumn = 1; EndColumn = 2 },
        [pscustomobject]@{Name = "Jan"; StartRow = 6; EndRow = 6; StartColumn = 1; EndColumn = 2 },
        [pscustomobject]@{Name = "Joe"; StartRow = 7; EndRow = 7; StartColumn = 1; EndColumn = 2 },
        [pscustomobject]@{Name = "Jonathan"; StartRow = 8; EndRow = 8; StartColumn = 1; EndColumn = 2 },
        [pscustomobject]@{Name = "Joy"; StartRow = 3; EndRow = 3; StartColumn = 4; EndColumn = 5 },
        [pscustomobject]@{Name = "Kevin"; StartRow = 4; EndRow = 4; StartColumn = 4; EndColumn = 5 },
        [pscustomobject]@{Name = "Monika"; StartRow = 5; EndRow = 5; StartColumn = 4; EndColumn = 5 },
        [pscustomobject]@{Name = "Paul"; StartRow = 6; EndRow = 6; StartColumn = 4; EndColumn = 5 },
        [pscustomobject]@{Name = "Sharon"; StartRow = 7; EndRow = 7; StartColumn = 4; EndColumn = 5 },
        [pscustomobject]@{Name = "Stephen"; StartRow = 8; EndRow = 8; StartColumn = 4; EndColumn = 5 }
    )

    $peoplestatus = Open-ExcelPackage C:\dashboards\appsupport\Peoplestatus.xlsx

    $cache:status = $people | ForEach-Object { Import-Excel -ExcelPackage $peoplestatus -WorksheetName 'Sheet1' -StartRow $_.StartRow -endrow $_.EndRow -startcolumn $_.StartColumn -endcolumn $_.EndColumn -NoHeader } | ForEach-Object { [PSCustomObject] @{
            Name   = $_.P1
            Status = if ([String]::IsNullOrEmpty($_.P2)) { "Not Set" } else { $_.P2 }
        } | Sort-Object -Property Name
    }

}