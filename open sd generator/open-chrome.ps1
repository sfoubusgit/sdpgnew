# PowerShell script to extract server URL and open Chrome
$projectPath = "C:\Users\Sina\Desktop\PCV1_new"
$defaultPort = 5173  # Default Vite port
$maxWaitTime = 20
$checkInterval = 1

Write-Host "Waiting for dev server to start..." -ForegroundColor Yellow

# Try to find the server URL by checking common ports
$serverUrl = $null
$ports = @(5173, 3000, 8080, 5174, 5175)  # Common dev server ports

for ($i = 0; $i -lt $maxWaitTime; $i++) {
    foreach ($port in $ports) {
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:$port" -TimeoutSec 1 -UseBasicParsing -ErrorAction SilentlyContinue
            if ($response.StatusCode -eq 200) {
                $serverUrl = "http://localhost:$port"
                break
            }
        } catch {
            # Port not ready yet, continue checking
        }
    }
    
    if ($null -ne $serverUrl) {
        break
    }
    
    Start-Sleep -Seconds $checkInterval
    Write-Host "." -NoNewline -ForegroundColor Gray
}

Write-Host ""

if ($null -eq $serverUrl) {
    # Default to Vite's default port
    $serverUrl = "http://localhost:$defaultPort"
    Write-Host "Using default server URL: $serverUrl" -ForegroundColor Yellow
} else {
    Write-Host "Server detected at: $serverUrl" -ForegroundColor Green
}

# Copy URL to clipboard
$serverUrl | Set-Clipboard
Write-Host "Server address copied to clipboard: $serverUrl" -ForegroundColor Cyan

# Open Chrome
Write-Host "Opening Chrome..." -ForegroundColor Green
Start-Process "chrome.exe" -ArgumentList $serverUrl

Write-Host "Done! Chrome should now be opening with the dev server." -ForegroundColor Green






