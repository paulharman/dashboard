Import-Module ("$PSScriptRoot\..\output\UniversalDashboard.psd1") -Force
Get-UDDashboard | Stop-UDDashboard 
$Dashboard = . "$PSScriptRoot\dashboard.ps1"
Start-UDDashboard -Dashboard $Dashboard -Port 10001