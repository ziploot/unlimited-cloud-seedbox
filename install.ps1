# ZipLoot Windows 1-Click Cloud Seedbox Setup
try {
    Write-Host "==============================================" -ForegroundColor Green
    Write-Host "[ZipLoot] Cloud Seedbox Installer" -ForegroundColor Green
    Write-Host "==============================================" -ForegroundColor Green

    # Determine script execution path safely
    $projectFolder = $PSScriptRoot
    if (-not $projectFolder) {
        $projectFolder = Split-Path -Parent $MyInvocation.MyCommand.Definition
    }
    if (-not $projectFolder) {
        $projectFolder = Get-Location
    }

    Write-Host "[+] Running setup in: $projectFolder" -ForegroundColor Cyan

    # Ensure required files are present; download from GitHub if missing
    $baseUrl = "https://raw.githubusercontent.com/Ziplootapp/unlimited-cloud-seedbox/main"
    $requiredFiles = @("index.js", "package.json", "render.yaml", "README.md")
    foreach ($file in $requiredFiles) {
        $filePath = Join-Path $projectFolder $file
        if (-not (Test-Path $filePath)) {
            Write-Host "[+] Downloading missing file: $file ..." -ForegroundColor Yellow
            Invoke-WebRequest -Uri "$baseUrl/$file" -OutFile $filePath -UseBasicParsing
        }
    }

    Set-Location $projectFolder

    Write-Host "`n==============================================" -ForegroundColor Green
    Write-Host "⚡ OPTION 1: 1-Click Cloud Deployment (Render - `$0 Free Hosting)" -ForegroundColor Green
    Write-Host "==============================================" -ForegroundColor Green
    Write-Host "The absolute easiest way! Deploy to the cloud in 10 seconds for `$0:" -ForegroundColor Cyan
    Write-Host "1. Log into Render (or sign up for free)."
    Write-Host "2. The script will open the 1-Click deploy page."
    Write-Host "3. Click 'Create Web Service' and your seedbox will be live in 1 minute!" -ForegroundColor Green

    $openCloud = Read-Host "`n[INPUT] Do you want to open the 1-Click Render Deployment page now? (Y/N)"
    if ($openCloud -eq "Y" -or $openCloud -eq "y") {
        Start-Process "https://render.com/deploy?repo=https://github.com/Ziplootapp/unlimited-cloud-seedbox"
    }

    Write-Host "`n==============================================" -ForegroundColor Green
    Write-Host "⚡ OPTION 2: Local Server Setup" -ForegroundColor Green
    Write-Host "==============================================" -ForegroundColor Green
    $runLocal = Read-Host "[INPUT] Do you want to run the Seedbox server locally on your computer? (Y/N)"
    
    if ($runLocal -eq "Y" -or $runLocal -eq "y") {
        # Check Node.js
        $nodeInstalled = Get-Command node -ErrorAction SilentlyContinue
        if (-not $nodeInstalled) {
            Write-Host "[WARN] Node.js not detected. Installing NodeJS via winget..." -ForegroundColor Yellow
            winget install OpenJS.NodeJS --silent --accept-package-agreements --accept-source-agreements
            $env:Path += ";$env:ProgramFiles\nodejs"
        }

        Write-Host "[INSTALL] Installing local dependencies..." -ForegroundColor Cyan
        cmd.exe /c "npm install"

        Write-Host "`n[START] Launching Local Seedbox Server..." -ForegroundColor Cyan
        # Start the node server in a hidden background window (default port 7860)
        Start-Process -FilePath "node" -ArgumentList "index.js" -WorkingDirectory $projectFolder -WindowStyle Hidden
        Start-Sleep -Seconds 2

        Write-Host "`n[BROWSER] Opening Local Seedbox Dashboard..." -ForegroundColor Cyan
        Start-Process "http://localhost:7860"
        
        Write-Host "`n[SUCCESS] Local Seedbox Server is running in the background!" -ForegroundColor Green
        Write-Host "To start it manually later, run 'npm start' in: $projectFolder"
    }

    Read-Host "`nSetup completed. Press Enter to exit..."
} catch {
    Write-Host "[ERROR] An unexpected error occurred: $_" -ForegroundColor Red
    Read-Host "Press Enter to exit..."
}
