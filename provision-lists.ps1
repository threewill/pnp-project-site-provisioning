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
   
    Write-Host "Connecting to Site $ProgramUrl .." -NoNewline
    # Connect-PnPOnline -Url $ProgramUrl -UseWebLogin 
    $currentContext = Connect-PnPOnline -Url $ProgramUrl -PnPManagementShell -ReturnConnection
    Write-Host "Connected!" -ForegroundColor Green

    Get-PnPSite -Connection $currentContext

    Write-Host "Adding standard Risk columns, ctypes, and list..." -NoNewline
    Invoke-PnPSiteTemplate -Path "./risks-template.xml" -Connection $currentContext
    Write-Host "Completed!" -ForegroundColor Green

    Write-Host "Adding standard Status Report columns, ctypes..." -NoNewline
    Invoke-PnPSiteTemplate -Path "./statusreport-template.xml" -Connection $currentContext
    Write-Host "Completed!" -ForegroundColor Green
}
catch {
    #Have to catch and throw error yourself to stop the script from executing.
    Write-Host "Failed" -ForegroundColor Red    
    throw $_     
}
