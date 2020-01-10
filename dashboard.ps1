Import-Module UniversalDashboard
Import-Module UniversalDashboard.Style
Import-Module UniversalDashboard.UD-Calendar
Import-Module UniversalDashboard.UDCircle
Import-Module UniversalDashboard.UDGauge
Import-Module UniversalDashboard.UDIndicator
Import-Module Posh-SSH
Import-Module Invoke-SqlCmd2

$modulepath = Join-Path $PSScriptRoot poshmodules
Import-Module -Name $modulepath -Verbose

$folder = $PSScriptRoot

$ConfigurationFile = Get-Content (Join-Path $PSScriptRoot dbconfig.json) | ConvertFrom-Json

Try {
    Import-Module (Join-Path $PSScriptRoot $ConfigurationFile.dashboard.rootmodule) -ErrorAction Stop
}
Catch {
    Write-Warning "Valid function module not found. Generate one by running $(Join-Path $PSScriptRoot New-UDProject.ps1) -ProjectName 'myProject'"
    break;
}

. (Join-Path $PSScriptRoot "themes\*.ps1")


$PageFolder = Get-ChildItem (Join-Path $PSScriptRoot pages)

$Pages = Foreach ($Page in $PageFolder) {
    . $Page.Fullname
}

$Initialization = New-UDEndpointInitialization -Module @(Join-Path $folder $ConfigurationFile.dashboard.rootmodule)

$ITPolicy = New-UDAuthorizationPolicy -Name "IT" -Endpoint {
    param($ClaimsPrincipal)
    $ClaimsPrincipal.HasClaim("http://schemas.microsoft.com/ws/2008/06/identity/claims/groupsid", "S-1-5-21-966205532-1977663930-808559644-7933")
}
$AdminPolicy = New-UDAuthorizationPolicy -Name 'Admin' -Endpoint {
    param($user)
    $User.Identity.Name -eq 'UK\harmanp'
}

$Auth = New-UDAuthenticationMethod -Windows
$LoginPage = New-UDLoginPage -AuthenticationMethod @($Auth) -PassThru -AuthorizationPolicy @($ITPolicy, $AdminPolicy)
#$footer = New-UDFooter -Id Footer -Copyright "Logged in as $User / $ClaimPrinciple.Identity.Name"

$DashboardParams = @{
    Title                  = $ConfigurationFile.dashboard.title
    Theme                  = $SampleTheme
    Pages                  = $Pages
    EndpointInitialization = $Initialization
    LoginPage              = $LoginPage 
    AdminModeAuthorizationPolicy = 'Admin'
    #Footer = $footer
}



$MyDashboard = New-UDDashboard @DashboardParams

Get-UDDashboard | Stop-UDDashboard
Enable-UDLogging -Level debug -Console -FilePath .\log.txt

$username = "monitoring"
$password = ConvertTo-SecureString "password" -AsPlainText -Force
$cache:dataSource = 'server'
$cache:database = 'database'
$cache:cred = New-Object System.Management.Automation.PSCredential ($username, $password)

$proxyString = "http://ifvmcsp001:3128"
$proxyUri = new-object System.Uri($proxyString)
[System.Net.WebRequest]::DefaultWebProxy = new-object System.Net.WebProxy ($proxyUri, $true)
[System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials

$Schedule5 = New-UDEndpointSchedule -Every 5 -Minute
$Schedule1 = New-UDEndpointSchedule -Every 1 -Minute
$endpoint1 = New-UDEndpoint -Schedule $Schedule5 -Id sql -Endpoint {
    $Cache:Data = get-auditITE
    refresh_appservergrids
    get-availability
}
$endpoint2 = New-UDEndpoint -Schedule $Schedule1 -Id sql -Endpoint {
    #Sync-UDElement -id 'appservercolumn2card' -Broadcast
    #Sync-UDElement -id 'appservercolumn4card' -Broadcast
}
$endpoint = $endpoint1, $endpoint2


Start-UDDashboard  -Dashboard $MyDashboard -Name $ConfigurationFile.dashboard.title -Endpoint $endpoint -Wait -AdminMode -AllowHttpForLogin # $AdminPolicy #-Port $ConfigurationFile.dashboard.port -AutoReload


###############