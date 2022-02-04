Import-Module ActiveDirectory

Function Get-NestedGroupMember {
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]
        $Identity
    )

    process {
        $user = Get-ADUser -Identity $Identity
        $userdn = $user.DistinguishedName
        $strFilter = "(member:1.2.840.113556.1.4.1941:=$userdn)"
        Get-ADGroup -LDAPFilter $strFilter -ResultPageSize 1000
    }
}

Function Get-FileName($InitialDirectory) {
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $initialDirectory
    $OpenFileDialog.filter = "CSV (*.csv) | *.csv"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.FileName
}

Write-Host "This takes a .csv of the 'Unique Groups + Users' sheet from a Permissions Report, adds a column with all the groups a user is in, then saves it as user_groups_output.csv"
Write-Host "Please select a .csv file"

$csv = Get-FileName | Import-Csv

ForEach ($row in $csv) {
    $username = $null
    $group_string = $null
    if ($row.Type -eq 'User') {
        $username = $row.Account.Split("\")[1]
        $groups = Get-NestedGroupMember $username | ForEach-Object { "{0}, " -f $_.Name }
        $group_string = Out-String -InputObject $groups -NoNewline
    }
    $row | Add-Member -MemberType NoteProperty -Name 'Groups' -Value $group_string
}

$csv | Export-Csv 'user_groups_output.csv' -NoTypeInformation
Write-Host "Done!"