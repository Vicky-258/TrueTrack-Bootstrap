# ==============================================================================
# TrueTrack God-Tier Web Installer
# ==============================================================================
# Usage:
#   irm <url_to_this_script> | iex
#
# Features:
#   1. Runs on standard Windows PowerShell 5.1+ (No PS7 required).
#   2. Does NOT require Git (Downloads ZIP if Git is missing).
#   3. Auto-Elevates/Bypasses Execution Policy if needed.
#   4. Seamlessly hands off to the main installer.
# ==============================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

# ------------------------------------------------------------------------------
# 0. STYLE & HELPERS
# ------------------------------------------------------------------------------
function Write-Log {
    param([string]$Message, [string]$Color="White", [string]$Icon=" ")
    Write-Host "$Icon $Message" -ForegroundColor $Color
}

Write-Log "Initializing TrueTrack Bootstrap..." "Cyan" "🚀"

# ------------------------------------------------------------------------------
# 1. SELF-CORRECTION (POLICY & TLS)
# ------------------------------------------------------------------------------
# Enable TLS 1.2 for older PowerShell 5.1 (Critical for GitHub downloads)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Policy Check
$CurrentPolicy = Get-ExecutionPolicy
if ($CurrentPolicy -ne 'Unrestricted' -and $CurrentPolicy -ne 'Bypass') {
    if ($PSCommandPath) {
        Write-Log "Switching to Bypass Execution Policy..." "Yellow" "⚠️"
        Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $MyInvocation.BoundParameters" -Wait
        exit
    }
}

# ------------------------------------------------------------------------------
# 2. CONFIGURATION
# ------------------------------------------------------------------------------
$RepoParams = @{
    User    = "Vicky-258"
    Repo    = "TrueTrack"
    Branch  = "main"
}
$RepoUrl    = "https://github.com/$($RepoParams.User)/$($RepoParams.Repo).git"
$ZipUrl     = "https://github.com/$($RepoParams.User)/$($RepoParams.Repo)/archive/refs/heads/$($RepoParams.Branch).zip"
$InstallDir = "$env:LOCALAPPDATA\TrueTrack"

Write-Log "Target Directory: $InstallDir" "Gray" "📂"

# ------------------------------------------------------------------------------
# 3. PREPARE DIRECTORY (SAFE BACKUP)
# ------------------------------------------------------------------------------
if (Test-Path $InstallDir) {
    $BackupDir = "${InstallDir}_bak_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    Write-Log "Existing installation found." "Yellow" "⚠️"
    Write-Log "Backing up to: $BackupDir" "Gray" "📦"
    
    try {
        Move-Item -Path $InstallDir -Destination $BackupDir -Force
    } catch {
        Write-Log "Failed to backup existing directory. Access denied?" "Red" "❌"
        exit 1
    }
}

# ------------------------------------------------------------------------------
# 4. DOWNLOAD LOGIC (GIT vs ZIP)
# ------------------------------------------------------------------------------
$DownloadSuccess = $false

# Method A: Try Git
if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Log "Git detected. Cloning repository..." "Green" "v"
    try {
        git clone --depth 1 $RepoUrl $InstallDir 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) {
            $DownloadSuccess = $true
            Write-Log "Repository cloned successfully." "Green" "✅"
        }
    } catch {
        Write-Log "Git clone failed. Falling back..." "Red" "❌"
    }
}

# Method B: Try Zip Download (Fallback)
if (-not $DownloadSuccess) {
    Write-Log "Downloading latest source code (ZIP)..." "Cyan" "⬇️"
    
    $ZipPath = "$env:TEMP\TrueTrack_Install.zip"
    $ExtractPath = "$env:TEMP\TrueTrack_Extract"

    try {
        # Clean Temp
        Remove-Item $ZipPath -ErrorAction SilentlyContinue | Out-Null
        Remove-Item -Recurse -Force $ExtractPath -ErrorAction SilentlyContinue | Out-Null

        # Download
        Invoke-WebRequest -Uri $ZipUrl -OutFile $ZipPath -UseBasicParsing
        
        # Extract
        Write-Log "Extracting files..." "Cyan" "📦"
        Expand-Archive -Path $ZipPath -DestinationPath $ExtractPath -Force
        
        # Move to InstallDir
        # GitHub ZIPs extract to "TrueTrack-main" folder usually
        $SourceInner = Get-ChildItem -Path $ExtractPath -Directory | Select-Object -First 1
        
        if ($SourceInner) {
            New-Item -ItemType Directory -Force -Path (Split-Path -Parent $InstallDir) | Out-Null
            Move-Item -Path $SourceInner.FullName -Destination $InstallDir -Force
            $DownloadSuccess = $true
            Write-Log "Extracted successfully." "Green" "✅"
        } else {
            throw "Could not find extracted folder structure."
        }
    } catch {
        Write-Log "Download failed: $_" "Red" "❌"
        Write-Log "Details: $ZipUrl" "Gray" "🔍"
        exit 1
    }
    
    # Cleanup Temp
    Remove-Item $ZipPath -ErrorAction SilentlyContinue
    Remove-Item -Recurse -Force $ExtractPath -ErrorAction SilentlyContinue
}

# ------------------------------------------------------------------------------
# 5. EXECUTE INSTALLER
# ------------------------------------------------------------------------------
$InstallerScript = "$InstallDir\install\install_windows.ps1"

if (Test-Path $InstallerScript) {
    Write-Log "Transferring control to main installer..." "Green" "⏩"
    Write-Host ""
    
    # Hand off execution
    & $InstallerScript
} else {
    Write-Log "CRITICAL: Installer script not found at $InstallerScript" "Red" "💀"
    exit 1
}
