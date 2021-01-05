param(    
    [Parameter(Mandatory=$true)]
    [string]$ProjectCode,

    [switch]$Log
)
Set-StrictMode -Version 5.0
if($Log){        
    Set-PnPTraceLog -On -Level Debug -LogFile ".\TraceLogs\$(Get-Date -Format FileDateTime).log"
}

$ProgramUrl = "https://threewill.sharepoint.com/teams/$ProjectCode"

 try {    
   
    Write-Host "Connecting to Unified Group Site $ProgramUrl .." -NoNewline
    Connect-PnPOnline -Url $ProgramUrl -UseWebLogin 
    Write-Host "Connected!" -ForegroundColor Green

    Write-Host "Adding standard Risk columns, ctypes, and list..." -NoNewline
    Apply-PnPProvisioningTemplate -Path ".\risks-template.xml"
    Write-Host "Completed!" -ForegroundColor Green

    Write-Host "Adding standard Status Report columns, ctypes..." -NoNewline
    Apply-PnPProvisioningTemplate -Path ".\statusreport-template.xml"
    Write-Host "Completed!" -ForegroundColor Green
}
catch {
    #Have to catch and throw error yourself to stop the script from executing.
    Write-Host "Failed" -ForegroundColor Red    
    throw $_     
}
