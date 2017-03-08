param(    
    [Parameter(Mandatory=$true)]
    [string]$ProjectCode,
    
    [Parameter(Mandatory=$true)]
    [string]$ProjectName,
    
    [Parameter(Mandatory=$false)]
    [string]$Description,
    
    [Parameter(Mandatory=$false)]
    [string[]]$Owners,
    
    [Parameter(Mandatory=$false)]
    [string[]]$Members,

    [switch]$Log
)
Set-StrictMode -Version 5.0
if($Log){        
    Set-PnPTraceLog -On -Level Debug -LogFile ".\TraceLogs\$(Get-Date -Format FileDateTime).log"
}

if([String]::IsNullOrWhiteSpace($Description)){
    $Description = "Office 365 Group for the $ProjectName ($ProjectCode) project."     
}
$Credentials = New-Object System.Management.Automation.PSCredential($Username, $Password)
try{    
    Write-Host "Connecting to Microsoft Graph..." -NoNewline
    Connect-PnPMicrosoftGraph -Scopes "Group.ReadWrite.All","User.Read.All"    
    Write-Host "Connected!" -ForegroundColor Green
    
    Write-Host "Creating Unified Group..." -NoNewline
    $NewUnifiedGroup = New-PnPUnifiedGroup -DisplayName $ProjectName -Description $Description -MailNickname $ProjectCode -Owners $Owners -Members $Members
    Write-Host "Done!" -ForegroundColor Green

    Write-Host "Connecting to new Site '$($NewUnifiedGroup.SiteUrl)'..." -NoNewline
    Connect-PnPOnline $NewUnifiedGroup.SiteUrl -UseWebLogin #-Credentials $Credentials #$(Get-Credential -Message "Enter Credentials for $($NewUnifiedGroup.SiteUrl)")
    Write-Host "Connected!" -ForegroundColor Green

    Write-Host "Adding standard lists..." -NoNewline
    Apply-PnPProvisioningTemplate -Path ".\schema.xml"
    Write-Host "Completed!" -ForegroundColor Green
}
catch{
    #Have to catch and throw error yourself to stop the script from executing.
    Write-Host "Failed" -ForegroundColor Red    
    throw $_     
}


