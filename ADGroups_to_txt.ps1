Import-Module ActiveDirectory

Function Get-Folder($initialDirectory) {
  [void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
  $FolderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
  $FolderBrowserDialog.RootFolder = 'MyComputer'
  if ($initialDirectory) { $FolderBrowserDialog.SelectedPath = $initialDirectory }
  [void] $FolderBrowserDialog.ShowDialog()
  return $FolderBrowserDialog.SelectedPath
}

Write-Host "This creates a txt file for each AD group and its users"
Write-Host "As this gets information about users it may generate errors when it comes across groups that contain computers"
Write-Host "Please select an ouput folder"

$output_folder = Get-Folder

Write-Host "This may take awhile"

$groups = (Get-AdGroup -filter * | Where-Object { $_.name -like "**" } | Select-Object name -ExpandProperty name)

ForEach ($g in $groups) {
  $path = $output_folder + "\" + $g.Name + ".txt"

  $results = (Get-ADGroupMember -Identity $g.Name -Recursive | Get-ADUser -Properties displayname, name)

  ForEach ($r in $results) {
    $r.displayname | Out-File $path -Append
  }   
}

Write-Host "Done!"