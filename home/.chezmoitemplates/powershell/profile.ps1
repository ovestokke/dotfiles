oh-my-posh init pwsh --config https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/catppuccin_mocha.omp.json | Invoke-Expression
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
