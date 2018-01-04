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

$existingTeam = Get-Team | Where-Object {$_.DisplayName -like '*$($ProjectCode)*'}
if ($existingTeam -eq $null )
{
    Write-Host "Creating Team ..." 
    # Add a new Team 
    $Group = New-Team -Alias $ProjectCode.ToLower() -DisplayName "Program - $ProjectName" -AccessType "public" -AddCreatorAsMember $true -Description $Description
    Write-Host "Created Group $($Group.GroupId)..."

    # Create default channels
    Write-Host "Creating default Channels..." 
    New-TeamChannel -GroupId $Group.GroupId -DisplayName "Deliverables"
    New-TeamChannel -GroupId $Group.GroupId -DisplayName "Project Management"

    #Add Team Owners provided 
    if($Owners -ne $null) {
        Write-Host "Adding Owners..." -NoNewline
        $Owners | ForEach-Object {Add-TeamUser -Role Owner -User $_ -GroupId $Group.GroupId}
        Write-Host "complete!" -ForegroundColor Green
    }

    #Add Team Members provided 
    if($Members -ne $null) {
        Write-Host "Adding Members..." -NoNewline
        $Members | ForEach-Object {Add-TeamUser -Role Member -User $_ -GroupId $Group.GroupId}
        Write-Host "complete!" -ForegroundColor Green
    }

} else {
    Write-Host "Team with Display name containing $($ProjectCode) found ..." 
}


 try {    
    Write-Host "Connecting to Microsoft Graph..." -NoNewline
    Connect-PnPMicrosoftGraph -Scopes "Group.ReadWrite.All","User.Read.All"    
    Write-Host "Connected!" -ForegroundColor Green

    Write-Host "Checking for Unified Group..." -NoNewline
    $NewUnifiedGroup = Get-PnPUnifiedGroup | Where-Object {$_.SiteUrl -like "*$ProjectCode" }
    
    Write-Host "Connecting to Unified Group Site '$($NewUnifiedGroup.SiteUrl)'..." -NoNewline
    Connect-PnPOnline $NewUnifiedGroup.SiteUrl -UseWebLogin 
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


