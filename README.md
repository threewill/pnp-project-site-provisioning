#Introduction 
A PowerShell PnP based provisioning process used when creating new ThreeWill project sites.

#Getting Started
1.	Installation process
    1. [Install PnP-PowerShell](https://github.com/SharePoint/PnP-PowerShell)

#How To Use
Simply Execute the 'provision.ps1' script like so...
```powershell
./provision.ps1 -SiteUrl 'https://<<tenant name>>.sharepoint.com/sites/NewProjectSite' -Username <<youremail@whatever.com>> 
```    
You'll then be prompted to enter your password.

#The Schema
Currently, this project uses the '2016-05' version of the [PnP Provisioning-Schema](https://github.com/SharePoint/PnP-Provisioning-Schema)

[Click Here to view a sample](https://github.com/SharePoint/PnP-Provisioning-Schema/blob/master/Samples/ProvisioningSchema-2016-05-FullSample-02.xml) 

