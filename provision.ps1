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


Connect-MicrosoftTeams

# Add a new Team 
$Group = New-Team -Alias $ProjectCode.ToLower() -DisplayName "Program - $ProjectName" -AccessType "public" -AddCreatorAsMember $true -Description $Description
Write-Host "Created Group $($Group.GroupId)..." -NoNewline

# Create default channels
Write-Host "Creating default Channels..." -NoNewline
New-TeamChannel -GroupId $Group.GroupId -DisplayName "Deliverables"
New-TeamChannel -GroupId $Group.GroupId -DisplayName "Project Management"

# Add Team users 


 try {    
    Write-Host "Connecting to Microsoft Graph..." -NoNewline
    Connect-PnPMicrosoftGraph -Scopes "Group.ReadWrite.All","User.Read.All"    
    Write-Host "Connected!" -ForegroundColor Green

     Write-Host "Checking for Unified Group..." -NoNewline
     $NewUnifiedGroup = Get-PnPUnifiedGroup | Where-Object {$_.SiteUrl -like "*$ProjectCode" }
    
#     if ($NewUnifiedGroup -eq $null) 
#     {
#         Write-Host "Creating Unified Group..." -NoNewline
#         $NewUnifiedGroup = New-PnPUnifiedGroup -DisplayName $ProjectName -Description $Description -MailNickname $ProjectCode -Owners $Owners -Members $Members
#         Write-Host "Done!" -ForegroundColor Green
#     }
#     else
#     {
#         Write-Host "Unified Group already exists..." -NoNewline    
#     }
    Write-Host "Connecting to Unified Group Site '$($NewUnifiedGroup.SiteUrl)'..." -NoNewline
    Connect-PnPOnline $NewUnifiedGroup.SiteUrl -UseWebLogin #-Credentials $Credentials #$(Get-Credential -Message "Enter Credentials for $($NewUnifiedGroup.SiteUrl)")
    Write-Host "Connected!" -ForegroundColor Green

    Write-Host "Adding standard lists..." -NoNewline
    Apply-PnPProvisioningTemplate -Path ".\schema.xml"
    Write-Host "Completed!" -ForegroundColor Green
}
catch {
    #Have to catch and throw error yourself to stop the script from executing.
    Write-Host "Failed" -ForegroundColor Red    
    throw $_     
}


