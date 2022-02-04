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

Write-Host "This gets all the nested groups that a user is in"
$username = Read-Host "Please enter a SamAccountName, a SID, a GUID, or a distinguishedName"

Get-NestedGroupMember $username | Select-Object -Unique Name