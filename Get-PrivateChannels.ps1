$Result=""  
$Results=@() 
Write-Host Exporting all Private Channel"'s" Members and Owners report...
$Count=0
$Path="./AllPrivateChannels Members and Owners Report_$((Get-Date -format yyyy-MMM-dd-ddd` hh-mm` tt).ToString()).csv"
Get-Team | foreach {
    $TeamName=$_.DisplayName
    $GroupId=$_.GroupId
    $PrivateChannels=(Get-TeamChannel -GroupId $GroupId -MembershipType Private).DisplayName
    foreach($PrivateChannel in $PrivateChannels)
    {
        Write-Progress -Activity "`n     Processed Private Channel count: $Count "`n"  Currently Processing: $PrivateChannel"
        $Count++
        Get-TeamChannelUser -GroupId $GroupId -DisplayName $PrivateChannel | foreach {
            $Name=$_.Name
            $UPN=$_.User
            $Role=$_.Role
            $Result=@{'Teams Name'=$TeamName;'Private Channel Name'=$PrivateChannel;'UPN'=$UPN;'User Display Name'=$Name;'Role'=$Role}
            $Results= New-Object psobject -Property $Result
            $Results | select 'Teams Name','Private Channel Name',UPN,'User Display Name',Role | Export-Csv $Path -NoTypeInformation -Append
        }
    }    
}
Write-Progress -Activity "`n     Processed Private Channel count: $Count "`n"  Currently Processing: $PrivateChannel" -Completed
if((Test-Path -Path $Path) -eq "True") 
{
    Write-Host `nReport available in $Path -ForegroundColor Green
}
