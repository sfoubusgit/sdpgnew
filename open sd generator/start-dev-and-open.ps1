# All-in-one script to start dev server and open Chrome
$projectPath = "C:\Users\Sina\Desktop\PCV1_new"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Starting Dev Server & Opening Chrome" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Change to project directory
Set-Location $projectPath

# Start npm run dev in a new CMD window
Write-Host "Opening CMD and starting npm run dev..." -ForegroundColor Green
$cmdCommand = "cd /d `"$projectPath`" && npm run dev"
Start-Process cmd.exe -ArgumentList "/k", $cmdCommand

# Wait for server to start
Write-Host "Waiting for dev server to start (checking ports)..." -ForegroundColor Yellow

$serverUrl = $null
$ports = @(5173, 3000, 8080, 5174, 5175)  # Common dev server ports, Vite default is 5173
$maxWaitTime = 30
$checkInterval = 1

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
    $serverUrl = "http://localhost:5173"
    Write-Host "Could not auto-detect server. Using default: $serverUrl" -ForegroundColor Yellow
    Write-Host "Please check the CMD window for the actual server address." -ForegroundColor Yellow
} else {
    Write-Host "Server detected at: $serverUrl" -ForegroundColor Green
}

# Copy URL to clipboard
$serverUrl | Set-Clipboard
Write-Host ""
Write-Host "Server address copied to clipboard: $serverUrl" -ForegroundColor Cyan

# Open Chrome
Write-Host "Opening Google Chrome..." -ForegroundColor Green
Start-Process "chrome.exe" -ArgumentList $serverUrl

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Done! Chrome should now be opening." -ForegroundColor Green
Write-Host "  Dev server is running in the CMD window." -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green






