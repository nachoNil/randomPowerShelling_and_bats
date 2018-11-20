#set global variables
$src = "$ENV:UserProfile\Desktop\Spam\"
$dest = "\\tsclient\C\Temp\Spam\"
$enduser = $null
$enduserPath= $null
$srcType = "*.msg"
$zFile = "spam.zip" 
$zDone = $src+$zfile
$die = $false

<#
=======================
FUNCTIONS
=======================
#>

#Function to get enduser workstation name - check if reachable
function getEnduser {
    $user = Read-Host "Provide enduser workstation name"
    if ((Test-Connection $user -Count 1 -ErrorAction SilentlyContinue).IPV4Address -eq $null ){ 
        Write-Host "- Workstation"$user "not found"
        break
    } else { 
        Write-Host "- Workstation found... connecting"
        $script:enduser = $user
        $script:enduserPath = "\\$user\C$\Temp\Spam"
    }
}

#create needed folder on host and hop
function chkAndCreatePaths {
    if ((Test-Path $src) -eq $false){
        md $src | out-null
        Write-Host "- Spam folder created on HOP Desktop"
    }

    if ((Test-Path $dest) -eq $false){
        md $dest | out-null
        Write-Host "- Spam folder created in host machine. Path: C:\Temp\Spam"
    }

    if((Test-Path $enduserPath) -eq $false){
        md $enduserPath | Out-Null
        Write-Host "- Spam folder created on enduser workstation"
    }
}

#Function to check files on enduser machine and move files - delete spam folder after this
function handleEnduserFiles {
    Read-Host "- Press Enter when all files are in Spam folder and ready to be processed"
    $chk = (Get-ChildItem "$enduserPath\$srcType" -Include $srcType -Recurse -ErrorAction SilentlyContinue).Name   
    switch([string]::IsNullOrEmpty($chk)){
        $true { Write-Host "- No messages to process in $enduserPath" }
        #move file(s) and remove spam folder
        default { Move-Item -Path "$enduserPath\$srcType" -Destination $src -Force; Write-Host "- Files moved to HOP machine"; Write-Host "- Cleaning up enduser folder"; Remove-Item $enduserPath -Force }
        
    }
}

#Function for checking for *.msg and compressing if found
function chkAndCompress {
    Set-Alias 7z "$ENV:ProgramFiles\7-Zip\7z.exe"
    $chk = Get-ChildItem -Path $src -Include $srcType -Recurse -ErrorAction SilentlyContinue
    switch([string]::IsNullOrEmpty($chk)){
        $true { Read-Host "`n- No emails files to compress.`n- Press enter to exit"; break }
        #zip message(s) into spam.zip with password ""
        default { Write-Host "- 7-Zip handling files:"; 7z a -tzip $zDone $src$srcType -p""; Write-Host "- Files compressed" }
    }
}

#Function for checking for *.zip and moving to host computer
function chkAndMove {
    $chk = (Get-ChildItem $src -Include $zFile -Recurse -ErrorAction SilentlyContinue).Name
    switch([string]::IsNullOrEmpty($chk)){
        $true { Read-Host '- No zip to move.' }
        #move zip file 
        default { Move-Item -Path $zDone -Destination $dest -Force; Write-Host "- Zip moved to Host machine `n" }
    }
}

#Function for prompting user for cleanup
function cleanup {
    while ($die -eq $false){
        switch(Read-Host "Clean up Spam folder? (y/n)"){
            'y' { Write-Host "- Mopping up"; Get-ChildItem $src -Include * -Recurse -ErrorAction SilentlyContinue | foreach { $_.Delete() }; Start-Sleep -s 2; $script:die = $true; break }
            'n' { Write-Host "- Ending script" ; Start-Sleep -s 1 ; $script:die = $true; break }
            default{ Write-Host "- Invalid input: $_ `n y or n `n" }
        }
    }
}

<#
=======================
SEQUENCE 
=======================
#>

getEnduser
chkAndCreatePaths
handleEnduserFiles
chkAndCompress
chkAndMove
cleanup
