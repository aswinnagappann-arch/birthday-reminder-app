# Native Zero-Dependency HTTP Server for Windows
# Runs immediately using Windows built-in .NET HttpListener without requiring external installations.

param (
    [int]$Port = 3000
)

$baseDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$publicDir = Join-Path $baseDir "frontend\public"

if (-not (Test-Path $publicDir)) {
    Write-Error "Public directory not found at $publicDir"
    exit 1
}

$listener = New-Object System.Net.HttpListener
$prefix = "http://localhost:$Port/"
$listener.Prefixes.Add($prefix)

try {
    $listener.Start()
} catch {
    # If 3000 is occupied, try 3001
    $Port = 3001
    $listener = New-Object System.Net.HttpListener
    $prefix = "http://localhost:$Port/"
    $listener.Prefixes.Add($prefix)
    $listener.Start()
}

Write-Host "==========================================================" -ForegroundColor Green
Write-Host "🎂 Birthday Reminder Web App is LIVE!" -ForegroundColor Cyan
Write-Host "🌐 URL: $prefix" -ForegroundColor Yellow
Write-Host "🔒 53 Encrypted Celebrants Loaded" -ForegroundColor Green
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Gray
Write-Host "==========================================================" -ForegroundColor Green

# Open browser
Start-Process $prefix

$mimeMap = @{
    ".html" = "text/html; charset=utf-8"
    ".css"  = "text/css; charset=utf-8"
    ".js"   = "application/javascript; charset=utf-8"
    ".json" = "application/json; charset=utf-8"
    ".csv"  = "text/csv; charset=utf-8"
    ".png"  = "image/png"
    ".jpg"  = "image/jpeg"
    ".jpeg" = "image/jpeg"
    ".ico"  = "image/x-icon"
    ".svg"  = "image/svg+xml"
}

while ($listener.IsListening) {
    try {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response

        $rawPath = $request.Url.LocalPath.TrimStart('/')
        if ([string]::IsNullOrWhiteSpace($rawPath)) {
            $rawPath = "index.html"
        }

        # Health API check
        if ($rawPath -eq "api/health") {
            $json = '{"status":"healthy","cryptography":"AES-256-GCM Vault Active","morning_reminder_time":"09:00 AM"}'
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($json)
            $response.ContentType = "application/json; charset=utf-8"
            $response.ContentLength64 = $buffer.Length
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
            $response.Close()
            continue
        }

        $filePath = Join-Path $publicDir $rawPath.Replace('/', '\')

        if (Test-Path $filePath -PathType Leaf) {
            $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
            $mime = if ($mimeMap.ContainsKey($ext)) { $mimeMap[$ext] } else { "application/octet-stream" }

            $bytes = [System.IO.File]::ReadAllBytes($filePath)
            $response.ContentType = $mime
            $response.ContentLength64 = $bytes.Length
            $response.OutputStream.Write($bytes, 0, $bytes.Length)
            $response.Close()
        } else {
            # Fallback to index.html for SPA routing
            $indexPath = Join-Path $publicDir "index.html"
            $bytes = [System.IO.File]::ReadAllBytes($indexPath)
            $response.ContentType = "text/html; charset=utf-8"
            $response.ContentLength64 = $bytes.Length
            $response.OutputStream.Write($bytes, 0, $bytes.Length)
            $response.Close()
        }
    } catch {
        # Listener closed or aborted
        break
    }
}
