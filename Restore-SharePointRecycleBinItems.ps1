Install-Module SharePointPnPPowerShellOnline  

Import-Module SharePointPnPPowerShellOnline 

 

# Create variables for the sites and credentials: 

 

$SiteUrl = "https://tenant.sharepoint.com/sites/sitename" 
$UserName = "username@tenant.onmicrosoft.com" 
$Password = "password" 
$SecurePassword= ConvertTo-SecureString $Password –asplaintext –force 
$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($UserName, $SecurePassword) 

 

# Get all the Recycle Bin items from the site: 
 
$Context = New-Object Microsoft.SharePoint.Client.ClientContext($SiteUrl)  
$Context.Credentials = $Credentials  
$Site = $Context.Site  
$RecycleBinItems = $Site.RecycleBin  
$Context.Load($Site)  
$Context.Load($RecycleBinItems)  
$Context.ExecuteQuery()  
 
# Filter Recycle Bin items by date (14 days ago):  
 

$today = (Get-Date) 

$restoreDate = $today.date.AddDays(-14) 
$RecycleBinItems = $RecycleBinItems | ? DeletedDate -gt $restoreDate $RecycleBinItems | Select Title, DeletedByEmail, DeletedDate, ItemType, ItemState | Format-Table -AutoSize 
                
# Loop through the items to restore: 

 
For ($i = 0; $i -lt $RecycleBinItems.Count; $i++)  

{       

$itemsre=$RecycleBinItems[$i].Title       

$RecycleBinItems[$i].Restore()       

$Context.ExecuteQuery()       

Write-Host $itemsre "Restored" -ForegroundColor Yellow  

} 

 

# Script usage notes: 

 

# When there are no items to restore from the target date, script returns blank. 

 

# Script does not overwrite existing folders, but will restore files into them if missing, after showing a warning for the folder: "To restore 

the folder, rename the existing folder and try again." 

 

# Adapted by Melissa from this technet post: 

 

# https://social.technet.microsoft.com/Forums/windows/en-US/d3b3d839-940f-45b3-8333-59e8e345d284/restoring-of-bulk-items-from-the-recycle-bin-sharepoint-online?forum=sharepointadmin 