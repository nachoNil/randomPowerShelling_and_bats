$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$keysTo1 = @("EnableLUA")
$keysTo0 = @("dontdisplaylastusername","Test")

foreach ($key in $keysTo0) {
    Set-ItemProperty $regPath -Name $key -Value "0"
    #Write-Host "Value for key" $key "set to 0..."
}

foreach ($key in $keysTo1) {
    Set-ItemProperty $regPath -Name $key -Value "1"
    #Write-Host "Value for key" $key "set to 1..."
}