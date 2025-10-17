oh-my-posh init pwsh --config https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/refs/heads/main/themes/catppuccin_mocha.omp.json | Invoke-Expression
Invoke-Expression (& { (zoxide init powershell | Out-String) })

Set-Alias -Name ch -Value chezmoi

function dotsync {
    Push-Location "$env:USERPROFILE\.local\share\chezmoi"
    git add -A
    git commit -m "update: $(Get-Date -Format yyyy-MM-dd)"
    git pull --rebase
    git push
    Pop-Location
}
