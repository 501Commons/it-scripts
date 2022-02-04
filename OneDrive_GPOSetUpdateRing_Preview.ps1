# Set variables to indicate value and key to set
$RegistryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\OneDrive'
$Name = 'GPOSetUpdateRing'
$Value = '4'
# Create the key if it does not exist
If (-NOT (Test-Path $RegistryPath)) {
  New-Item -Path $RegistryPath -Force | Out-Null
}  
# Now set the value
New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType DWORD -Force 