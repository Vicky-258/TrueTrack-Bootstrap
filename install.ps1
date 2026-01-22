# ==============================================================================
# TrueTrack Bootstrap Installer (Windows)
# ==============================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$RepoUrl    = "https://github.com/<your-org>/truetrack.git"
$InstallDir = "$env:LOCALAPPDATA\TrueTrack"

Write-Host "TrueTrack Bootstrap Installer"
Write-Host "-----------------------------"

# --------------------------------------------------------------------------
# PowerShell Version Check
# --------------------------------------------------------------------------
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Error "PowerShell 7 or newer is required."
    Write-Error "Install from https://aka.ms/powershell and re-run."
    exit 1
}

# --------------------------------------------------------------------------
# Tool Check
# --------------------------------------------------------------------------
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "git is required but not installed."
    Write-Error "Please install git and re-run this command."
    exit 1
}

# --------------------------------------------------------------------------
# Target Directory Check
# --------------------------------------------------------------------------
if (Test-Path $InstallDir) {
    Write-Error "$InstallDir already exists."
    Write-Error "If this is a previous install, remove it first:"
    Write-Error "  Remove-Item -Recurse -Force `"$InstallDir`""
    exit 1
}

# --------------------------------------------------------------------------
# Clone Repository
# --------------------------------------------------------------------------
Write-Host "Cloning TrueTrack into $InstallDir..."
git clone $RepoUrl $InstallDir

# --------------------------------------------------------------------------
# Delegate to Real Installer
# --------------------------------------------------------------------------
Write-Host "Starting TrueTrack installer..."
& "$InstallDir\install\install_windows.ps1"
