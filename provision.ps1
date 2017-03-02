param(
    [Parameter(Mandatory=$true)]
    [string]$SiteUrl,
    [Parameter(Mandatory=$true)]
    [string]$Username,
    [Parameter(Mandatory=$true)]
    [securestring]$Password
)
$CurrentDate = Get-Date -Format FileDateTime
Set-SPOTraceLog -On -Level Debug -LogFile ".\TraceLogs\$($CurrentDate).log"
$Credentials = New-Object System.Management.Automation.PSCredential($Username, $Password)
Connect-PnPOnline -Url $SiteUrl -Credentials $Credentials

Apply-SPOProvisioningTemplate -Path ".\schema.xml"

