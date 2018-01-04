# Introduction 
This provisioing script is a PowerShell PnP based provisioning process used when creating new collaboration spaces for clients.  The script uses the Microsoft-Teams PowerShell Module to provision a new Team (Unified Group), create default channels, add owners and members, and finally apply a site template using SharePoint PnP PowerShell cmdlets.

## Known Issues and Limitations
The script assumes the use of the ```Connect-PnPMicrosoftGraph``` cmdlet which will be deprecated in future versions of the SharePoint PowerShell PnP cmdlets.  This will change as time permits.

The script is also using a **preview**  version of the Microsoft-Teams cmdlets, but is working well for us.  

## Getting Started
The script requires two PowerShell modules to be installed.  

* [SharePointPnPPowerShellOnline](https://github.com/SharePoint/PnP-PowerShell) module using ```Install-Module SharePointPnPPowerShellOnline``` 
* [Microsoft-Teams](https://blogs.technet.microsoft.com/skypehybridguy/2017/11/07/microsoft-teams-powershell-support/) module using ```Install-Module Microsoft-Teams```  



## Syntax
```powershell
./provision.ps1 -ProjectCode <String> 
                -ProjectName <String> 
                [-Description <String>] 
                [-Owners <String[]>] 
                [-Members <String[]>] 
                [-Log [<SwitchParameter>]]
```
## Parameters
Parameter|Type|Required|Description
---------|----|--------|-----------
|ProjectCode|String|True|The ThreeWill project code. Will be used as the alias for the group and URL for the team site.|
|ProjectName|String|True|The 'Display Name' of the project. Will become the Title of the Group.|
|Description|String|False|A short description of the project. If not provided, will default to "Office 365 Group for the \<ProjectName> (\<ProjectCode>) project."|
|Owners|String[]|False|A list of users to be added as Team owners. The user executing the script will be added by default.|
|Members|String[]|False|A list of users to be added as Team Members.|
|Log|SwitchParameter|False|If provided, a trace log will be created. Useful if issues are encountered when attempting to provision lists.|


## Examples
### Example 1
```powershell
./provision.ps1 -ProjectCode "PNP-01" -ProjectName "PnP Demo 01" 
```
Provisions a New Office 365 Group titled 'PnP Demo 01', a description of 'Office 365 Group for the PnP Demo 01 (pnp-demo-01) project.', a team site at https://contoso.sharepoint.com/teams/pnp-demo-01, and with a group email address of pnp-demo-01@contoso.com.

### Example 2
```powershell
./provision.ps1 -ProjectCode "PNP-01" -ProjectName "PnP Demo 01" -Description "Contoso PnP Team Site" 
```
Provisions a New Office 365 Group titled 'PnP Demo 01', a description of 'Contoso PnP Team Site', a team site at https://contoso.sharepoint.com/teams/pnp-demo-01, and with a group email address of pnp-demo-01@contoso.com.

### Example 3
```powershell
./provision.ps1 -ProjectCode "PNP-01" -ProjectName "PnP Demo 01" -Owners "foo@contoso.com", "bar@contoso.com"
```
Provisions a New Office 365 Group titled 'PnP Demo 01', a description of 'Office 365 Group for the PnP Demo 01 (pnp-demo-01) project.', a team site at https://contoso.sharepoint.com/teams/pnp-demo-01, and with a group email address of pnp-demo-01@contoso.com. The users 'foo@contoso.com' and 'bar@constoso.com', in addition to the user running the script, will be listed as the group owners.

### Example 3
```powershell
./provision.ps1 -ProjectCode "PNP-01" -ProjectName "PnP Demo 01" -Members "foo@contoso.com", "bar@contoso.com"
```
Provisions a New Office 365 Group titled 'PnP Demo 01', a description of 'Office 365 Group for the PnP Demo 01 (pnp-demo-01) project.', a team site at https://contoso.sharepoint.com/teams/pnp-demo-01, and with a group email address of pnp-demo-01@contoso.com. The users 'foo@contoso.com' and 'bar@constoso.com' will be listed as the group members.


### Running the Script
* Open a PowerShell Window and set the directory to the folder containing the 'provision.ps1' script
```powershell
cd c:/github/pnp-project-site-provisioning
```
* Execute the script with whatever parameters necessary.
```powershell
./provision.ps1 -ProjectCode "PNP-01" -ProjectName "PnP Demo 01"
```
* When prompted, enter the credentials for the tenant you wish to provision this new group in.
![Microsoft Graph Login][msgraph-login]
* Wait for the script to finish.

### Developer Notes
Currently, this project uses the '2016-05' version of the [PnP Provisioning-Schema](https://github.com/SharePoint/PnP-Provisioning-Schema)

[Click Here to view a sample](https://github.com/SharePoint/PnP-Provisioning-Schema/blob/master/Samples/ProvisioningSchema-2016-05-FullSample-02.xml) 

[msgraph-login]: https://github.com/threewill/pnp-project-site-provisioning/blob/master/images/pnp-msgraph-login.jpg "Microsoft Graph Login Window"

##### Disclaimer
This repository is provided as-is, with no guarantee or warranty.  Feel free to clone and contribute if you wish. 

