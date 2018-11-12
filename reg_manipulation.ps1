$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$keysTo1 = @("disablecad")
$keysTo0 = @("PromptOnSecureDesktop","EnableLUA","dontdisplaylastusername","dontdisplaylockeduserid")

foreach ($key in $keysTo0) {
    Set-ItemProperty $regPath -Name $key -Value "0"
    #Write-Host "Value for key" $key "set to 0..."
}

foreach ($key in $keysTo1) {
    Set-ItemProperty $regPath -Name $key -Value "1"
    #Write-Host "Value for key" $key "set to 1..."
}
