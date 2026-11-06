<#
================================================================================
  ULTIMATE WINDOWS 11 POWERSHELL & TERMINAL MASTER SETUP REPOSITORY
================================================================================
  Author: Modern Terminal Setup
  Platform: Windows 11 (Supports PowerShell 7+ and Windows PowerShell 5.1)
  Purpose: One-click bootstrap script and complete environment profile for
           fresh machine provisioning.

  HOW TO RUN THIS SCRIPT ON A FRESH MACHINE:
  -----------------------------------------------------------------------------
  1. Open Windows Terminal / PowerShell as Administrator.
  2. If running locally from this file:
       Set-ExecutionPolicy Bypass -Scope Process -Force
       .\windows_11_terminal_setup.ps1
  3. If running directly from GitHub Raw URL:
       irm https://raw.githubusercontent.com/<user>/<repo>/main/setup.ps1 | iex
================================================================================
#>

# ==============================================================================
# PHASE 1: SYSTEM PERMISSIONS & PACKAGE PROVIDER CONFIGURATION
# ==============================================================================
Write-Host "==> [Phase 1/5] Configuring Execution Policy and Package Providers..." -ForegroundColor Cyan

# Enable local script execution for the current user
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# Force TLS 1.2 for secure module downloads
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Bootstrap NuGet package provider if missing
if (-not (Get-PackageProvider -Name NuGet -ListAvailable -ErrorAction SilentlyContinue)) {
    Write-Host "Installing NuGet provider..." -ForegroundColor Gray
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope CurrentUser | Out-Null
}

# Trust PSGallery to eliminate interactive prompts
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted -ErrorAction SilentlyContinue


# ==============================================================================
# PHASE 2: WINGET CLI TOOLS & NERD FONT INSTALLATION
# ==============================================================================
Write-Host "`n==> [Phase 2/5] Installing CLI Tools, Rust Utilities, and Nerd Font..." -ForegroundColor Cyan

$wingetPackages = @(
    @{ Id = 'Microsoft.PowerShell';       Desc = 'PowerShell 7+ Engine' },
    @{ Id = 'Microsoft.CascadiaCode';     Desc = 'Cascadia Code NF (Nerd Font for Starship/Icons)' },
    @{ Id = 'Starship.Starship';          Desc = 'Cross-shell Fast Prompt Engine' },
    @{ Id = 'ajeetdsouza.zoxide';         Desc = 'Zoxide (Smart directory jumper)' },
    @{ Id = 'junegunn.fzf';               Desc = 'FZF (Fuzzy Finder CLI core)' },
    @{ Id = 'eza-community.eza';          Desc = 'Eza (Modern, colored ls replacement)' },
    @{ Id = 'sharkdp.bat';                Desc = 'Bat (Syntax-highlighted cat replacement)' },
    @{ Id = 'BurntSushi.ripgrep.MSVC';    Desc = 'Ripgrep (High-performance grep)' },
    @{ Id = 'Fastfetch-cli.Fastfetch';    Desc = 'Fastfetch (System info visualizer)' },
    @{ Id = 'JesseDuffield.lazygit';     Desc = 'Lazygit (Terminal UI for Git)' }
)

foreach ($pkg in $wingetPackages) {
    Write-Host "Installing $($pkg.Desc) [$($pkg.Id)]..." -ForegroundColor Gray
    winget install --id $pkg.Id --source winget --accept-source-agreements --accept-package-agreements --silent
}


# ==============================================================================
# PHASE 3: POWERSHELL GALLERY MODULES
# ==============================================================================
Write-Host "`n==> [Phase 3/5] Installing and Updating PowerShell Modules..." -ForegroundColor Cyan

$modules = @(
    'PSReadLine',        # Upgrades built-in console to support Predictive IntelliSense
    'PSFzf',             # Fuzzy interactive search for history and paths
    'Terminal-Icons'     # Visual folder/file glyphs fallback
)

foreach ($mod in $modules) {
    Write-Host "Installing/Updating $mod..." -ForegroundColor Gray
    Install-Module -Name $mod -Scope CurrentUser -Force -SkipPublisherCheck -AllowClobber -ErrorAction SilentlyContinue
}


# ==============================================================================
# PHASE 4: PROFILE SCRIPT GENERATION
# ==============================================================================
Write-Host "`n==> [Phase 4/5] Deploying Optimized Profile Configuration..." -ForegroundColor Cyan

$profileTemplate = @'
# ==============================================================================
# ULTIMATE POWERSHELL RUNTIME PROFILE
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. READLINE & PREDICTIVE INTELLISENSE
# ------------------------------------------------------------------------------
Import-Module PSReadLine -ErrorAction SilentlyContinue

# Verify PSReadLine version >= 2.2.0 before applying prediction flags
$psReadLineModule = Get-Module PSReadLine
if ($psReadLineModule -and ($psReadLineModule.Version -ge [Version]'2.2.0')) {
    # Fish-shell style predictive ghost text from history and plugins
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin
    Set-PSReadLineOption -PredictionViewStyle InlineView
    Set-PSReadLineOption -Colors @{ InlinePrediction = '#767676' }
    
    # Press F2 to toggle between inline suggestions and full dropdown list view
    Set-PSReadLineKeyHandler -Key F2 -Function SwitchPredictionView
}

# Strict Key Handler Bindings
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key 'Ctrl+Spacebar' -Function MenuComplete
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key RightArrow -Function ForwardChar

# ------------------------------------------------------------------------------
# 2. SHELL ENHANCEMENTS & UTILITIES
# ------------------------------------------------------------------------------

# Zoxide (Smart directory jumping via 'z' and 'zi')
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& zoxide init powershell | Out-String)
}

# PSFzf (Fuzzy history search via Ctrl+R, directory search via Ctrl+T)
try {
    Import-Module PSFzf -ErrorAction Stop
    Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r' -PSReadlineChordProvider 'Ctrl+t'
} catch {}

# Native Winget Tab Completion
if (Get-Command winget -ErrorAction SilentlyContinue) {
    Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
        param($wordToComplete, $commandAst, $cursorPosition)
        [Console]::InputEncoding = [System.Text.Encoding]::UTF8
        $text = winget complete --word="$wordToComplete" --position=$cursorPosition --commandline="$commandAst"
        return $text | ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_) }
    }
}

# ------------------------------------------------------------------------------
# 3. MODERN RUST REPLACEMENTS & CUSTOM ALIASES
# ------------------------------------------------------------------------------

# Replace 'ls' with 'eza' (Tree view, git status, icons)
if (Get-Command eza -ErrorAction SilentlyContinue) {
    function ls   { eza --icons --group-directories-first $args }
    function ll   { eza -la --icons --group-directories-first --git $args }
    function tree { eza --tree --icons $args }
} else {
    try { Import-Module Terminal-Icons -ErrorAction Stop } catch {}
}

# Replace 'cat' with 'bat' (Syntax highlighting, line numbers)
if (Get-Command bat -ErrorAction SilentlyContinue) {
    Set-Alias -Name cat -Value bat -Option AllScope -ErrorAction SilentlyContinue
}

# Custom helper utilities
function which ($name) { 
    Get-Command $name -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source 
}

function reload-profile { 
    . $PROFILE 
}

# ------------------------------------------------------------------------------
# 4. STARSHIP PROMPT INITIALIZATION
# ------------------------------------------------------------------------------
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (& starship init powershell --print-full-init | Out-String)
}
'@

# Synchronize profile across both PowerShell 7+ and legacy Windows PowerShell 5.1
$profileLocations = @(
    $PROFILE,
    "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1",
    "$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
) | Select-Object -Unique

foreach ($target in $profileLocations) {
    $parentDir = Split-Path -Parent $target
    if (-not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }
    Set-Content -Path $target -Value $profileTemplate -Encoding utf8 -Force
    Write-Host "Installed: $target" -ForegroundColor Gray
}


# ==============================================================================
# PHASE 5: ENVIRONMENT REFRESH & COMPLETION
# ==============================================================================
Write-Host "`n==> [Phase 5/5] Refreshing Environment PATH..." -ForegroundColor Cyan

# Reload PATH from registry without requiring a reboot
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

Write-Host "`n==================================================================" -ForegroundColor Green
Write-Host "   TERMINAL SETUP COMPLETED SUCCESSFULLY!" -ForegroundColor Green
Write-Host "==================================================================" -ForegroundColor Green
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Restart Windows Terminal or open PowerShell 7 (pwsh)." -ForegroundColor White
Write-Host "2. In Windows Terminal Settings, set your font to 'Cascadia Code NF'." -ForegroundColor White
Write-Host "3. To reload your profile anytime, type: reload-profile`n" -ForegroundColor White

# Reload profile in current session if supported
if (Test-Path $PROFILE) {
    . $PROFILE
}


# ==============================================================================
# APPENDIX: WINDOWS TERMINAL SETTINGS CONFIGURATION (OPTIONAL MANUAL STEP)
# ==============================================================================
<#
To enable Cascadia Code Nerd Font and Windows 11 Acrylic styling:
1. Press [Ctrl + ,] in Windows Terminal.
2. Click "Open JSON file" in the bottom-left corner.
3. Paste the following block inside "profiles" -> "defaults":

    "defaults": {
        "font": {
            "face": "Cascadia Code NF",
            "size": 11.0
        },
        "opacity": 85,
        "useAcrylic": true,
        "cursorShape": "bar",
        "historySize": 10000
    }
#>
