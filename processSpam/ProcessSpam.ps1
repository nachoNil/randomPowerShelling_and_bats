<#
"Company" > wanted
"P4ssw0rd" > wanted
#>

#set needed variables
Set-Alias 7z "$ENV:ProgramFiles\7-Zip\7z.exe"
$src = "$ENV:UserProfile\Desktop\Spam\"
$srcType = "*.msg"
$zFile = "company-spam.zip" 
$zDone = $src+$zfile
$dest = "\\tsclient\C\Temp\Spam"
$die = $false

#create needed folder on host and hop
if ((Test-Path $src) -eq $false){
    md $ENV:UserProfile\Desktop\Spam\ | out-null
    Read-Host "Spam folder created on Desktop `nPress enter"
}

if ((Test-Path $dest) -eq $false){
    md \\tsclient\C\Temp\Spam | out-null
    Read-Host "Spam folder created in host machine C:\Temp `nScript ready for use `nPress enter to exit"
    break
}

#check if any messages to compress
$chkM = Get-ChildItem -Path $src -Include $srcType -Recurse -ErrorAction SilentlyContinue
if ($chkM -eq $null){
    Read-Host "`nNo emails files to compress.`nPress enter to exit"
    break
} else {
    Write-Host "Found messages..."
    #zip message(s) into company-spam.zip with password: P4ssw0rd
    7z a -tzip $zDone $src$srcType -p"P4ssw0rd"
}

#check if there is a zip to move
$chkF = (Get-ChildItem $src -Include *company-spam.zip* -Recurse -ErrorAction SilentlyContinue).Name
switch($chkF -eq $null){
    $true {Read-Host 'No zip to move.'}
    #move zip file 
    default {Move-Item -Path $zDone -Destination $dest -Force; Write-Host "`nZip moved to Host machine... `n"}
}

#ask user if folders should be cleaned
while ($die -eq $false){
    switch(Read-Host "Clean up Spam folder? (y/n)"){
        'y' { Write-Host "Mopping up..."; Get-ChildItem $src -Include * -Recurse -ErrorAction SilentlyContinue | foreach { $_.Delete() }; Start-Sleep -s 2; $die = $true ;break }
        'n' { Write-Host "Ending script..." ; Start-Sleep -s 1 ; $die = $true ;break}
        default{ Write-Host "Invalid input: $_ `n y or n `n" }
    }
}