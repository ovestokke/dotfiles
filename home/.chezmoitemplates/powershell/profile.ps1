# Oh My Posh themes (user curated)
$global:OMP_THEMES = @(
    'catppuccin_mocha',
    'powerlevel10k_rainbow',
    'gruvbox',
    'night-owl',
    'blueish',
    'atomic',
    'negligible',
    'quick-term',
    'cert',
    'iterm2',
    'jblab_2021',
    'wholespace',
    'M365Princess',
    'blue-owl',
    'clean-detailed',
    'easy-term',
    'unicorn',
    'if_tea',
    'kushal',
    'multiverse-neon',
    'montys',
    'mojada',
    'microverse-power',
    'paradox'
)

# Theme config file
$global:OMP_CONFIG_FILE = "$env:USERPROFILE\.omp_theme"

# Load saved theme or use default
if (Test-Path $OMP_CONFIG_FILE) {
    $global:OMP_THEME = Get-Content $OMP_CONFIG_FILE -Raw
    $global:OMP_THEME = $global:OMP_THEME.Trim()
} else {
    $global:OMP_THEME = 'catppuccin_mocha'
    $global:OMP_THEME | Out-File -FilePath $OMP_CONFIG_FILE -NoNewline
}

# Function to switch themes
function theme {
    param(
        [string]$name
    )

    if (-not $name) {
        Write-Host "Current: $global:OMP_THEME" -ForegroundColor Cyan
        Write-Host "Available themes:"
        foreach ($t in $global:OMP_THEMES) {
            if ($t -eq $global:OMP_THEME) {
                Write-Host "  * $t (active)" -ForegroundColor Green
            } else {
                Write-Host "    $t"
            }
        }
        Write-Host ""
        Write-Host "Usage: theme <name>  - switch to theme"
        Write-Host "       theme next    - cycle to next theme"
        return
    }

    $newTheme = $name

    # Handle 'next' to cycle through themes
    if ($name -eq 'next') {
        $idx = $global:OMP_THEMES.IndexOf($global:OMP_THEME)
        if ($idx -eq -1) { $idx = 0 }
        $idx = ($idx + 1) % $global:OMP_THEMES.Count
        $newTheme = $global:OMP_THEMES[$idx]
    }

    # Validate theme exists in list
    if ($global:OMP_THEMES -notcontains $newTheme) {
        Write-Host "Error: Theme '$newTheme' not found" -ForegroundColor Red
        Write-Host "Use 'theme' without arguments to see available themes"
        return
    }

    # Save and apply new theme
    $global:OMP_THEME = $newTheme
    $newTheme | Out-File -FilePath $global:OMP_CONFIG_FILE -NoNewline
    oh-my-posh init pwsh --config "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/$newTheme.omp.json" | Invoke-Expression
    Write-Host "Switched to: $newTheme" -ForegroundColor Green
}

# Initialize Oh My Posh prompt with saved theme
oh-my-posh init pwsh --config "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/$global:OMP_THEME.omp.json" | Invoke-Expression

# Initialize zoxide (better cd)
Invoke-Expression (& { (zoxide init powershell | Out-String) })

Import-Module Terminal-Icons -ErrorAction SilentlyContinue
Import-Module z -ErrorAction SilentlyContinue
Import-Module PSReadLine -ErrorAction SilentlyContinue
Import-Module PSFzf -ErrorAction SilentlyContinue

Set-PSReadLineOption -PredictionSource History -ErrorAction SilentlyContinue
Set-PSReadLineOption -PredictionViewStyle ListView -ErrorAction SilentlyContinue
Set-PSReadLineOption -EditMode Windows -ErrorAction SilentlyContinue
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward -ErrorAction SilentlyContinue
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward -ErrorAction SilentlyContinue

if (Get-Command Set-PsFzfOption -ErrorAction SilentlyContinue) {
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r' -ErrorAction SilentlyContinue
}

Set-Alias -Name ch -Value chezmoi

function dotsync {
    Push-Location "$env:USERPROFILE\.local\share\chezmoi"
    git add -A
    git commit -m "update: $(Get-Date -Format yyyy-MM-dd)"
    git pull --rebase
    git push
    Pop-Location
}
