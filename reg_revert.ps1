$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$keysTo1 = @("disablecad")
$keysTo0 = @("PromptOnSecureDesktop","EnableLUA","dontdisplaylastusername","dontdisplaylockeduserid")

foreach ($key in $keysTo0) {
    Try {
        Set-ItemProperty $regPath -Name $key -Value "0"
        Write-Host "Value for key" $key "set to 0..."
    } 
    Catch {
        Write-Host "Value of key" $key "could not be modified..."    
    }
}

foreach ($key in $keysTo1) {
    Try {
        Set-ItemProperty $regPath -Name $key -Value "1"
        Write-Host "Value for key" $key "set to 1..."
    }
    Catch {
        Write-Host "Value of key" $key "could not be modified..."
    }
}

Read-Host -Prompt "Press Enter to exit"
