# PowerShell script to start dev server and open in Chrome
$projectPath = "C:\Users\Sina\Desktop\PCV1_new"
$maxWaitTime = 30  # Maximum seconds to wait for server to start
$checkInterval = 0.5  # Check every 0.5 seconds

# Change to project directory
Set-Location $projectPath

Write-Host "Starting npm run dev..." -ForegroundColor Green

# Start npm run dev process and capture output
$processInfo = New-Object System.Diagnostics.ProcessStartInfo
$processInfo.FileName = "npm"
$processInfo.Arguments = "run dev"
$processInfo.WorkingDirectory = $projectPath
$processInfo.UseShellExecute = $false
$processInfo.RedirectStandardOutput = $true
$processInfo.RedirectStandardError = $true
$processInfo.CreateNoWindow = $false

$process = New-Object System.Diagnostics.Process
$process.StartInfo = $processInfo

# Create string builders to capture output
$outputBuilder = New-Object System.Text.StringBuilder
$errorBuilder = New-Object System.Text.StringBuilder

# Add event handlers to capture output
$script:outputComplete = $false
$outputAction = {
    if (-not [string]::IsNullOrWhiteSpace($EventArgs.Data)) {
        [void]$outputBuilder.AppendLine($EventArgs.Data)
        Write-Host $EventArgs.Data
    }
}

$errorAction = {
    if (-not [string]::IsNullOrWhiteSpace($EventArgs.Data)) {
        [void]$errorBuilder.AppendLine($EventArgs.Data)
        Write-Host $EventArgs.Data -ForegroundColor Red
    }
}

Register-ObjectEvent -InputObject $process -EventName OutputDataReceived -Action $outputAction | Out-Null
Register-ObjectEvent -InputObject $process -EventName ErrorDataReceived -Action $errorAction | Out-Null

# Start the process
$process.Start() | Out-Null
$process.BeginOutputReadLine()
$process.BeginErrorReadLine()

Write-Host "Waiting for server to start..." -ForegroundColor Yellow

# Wait for server URL to appear in output
$serverUrl = $null
$elapsedTime = 0

while ($null -eq $serverUrl -and $elapsedTime -lt $maxWaitTime) {
    Start-Sleep -Seconds $checkInterval
    $elapsedTime += $checkInterval
    
    $output = $outputBuilder.ToString()
    
    # Try to match Vite server URL patterns
    # Pattern: "Local:   http://localhost:PORT/" or "➜  Local:   http://localhost:PORT/"
    if ($output -match "(?:Local|➜\s+Local):\s+(https?://[^\s]+)") {
        $serverUrl = $matches[1].Trim()
        Write-Host "`nServer URL found: $serverUrl" -ForegroundColor Green
        break
    }
    # Also try simpler pattern
    elseif ($output -match "(https?://localhost:\d+)") {
        $serverUrl = $matches[1].Trim()
        Write-Host "`nServer URL found: $serverUrl" -ForegroundColor Green
        break
    }
}

if ($null -eq $serverUrl) {
    Write-Host "`nWarning: Could not detect server URL automatically." -ForegroundColor Yellow
    Write-Host "Please check the output above and manually open the server address in Chrome." -ForegroundColor Yellow
    Write-Host "`nPress any key to keep the dev server running..." -ForegroundColor Cyan
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
} else {
    # Copy URL to clipboard
    $serverUrl | Set-Clipboard
    Write-Host "Server address copied to clipboard: $serverUrl" -ForegroundColor Cyan
    
    # Open Chrome with the server URL
    Write-Host "Opening Chrome..." -ForegroundColor Green
    Start-Process "chrome.exe" -ArgumentList $serverUrl
    
    Write-Host "`nDev server is running. Press Ctrl+C to stop." -ForegroundColor Yellow
    Write-Host "The server will continue running in this window." -ForegroundColor Yellow
}

# Keep the process running
try {
    $process.WaitForExit()
} catch {
    Write-Host "`nDev server stopped." -ForegroundColor Red
}






