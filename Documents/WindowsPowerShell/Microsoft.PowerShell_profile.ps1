function set-locationrepos {
	Set-location C:\Users\$env:USERNAME\source\repos
}
function Invoke-Profile {
	nvim $profile
}
function Invoke-hosts {
	nvim C:\windows\system32\drivers\etc\hosts
}
function New-File([string]$Name) {
	New-Item $name -itemType file
}

function realpath([string]$Name) {
	(Get-Item $Name).fullname
}

function ..() {
	cd ..
}

function ...() {
	cd ..
	cd ..
}

function ....() {
	cd ..
	cd ..
	cd ..
}

Set-alias hosts invoke-hosts
Set-alias pp Invoke-Profile
Set-alias repos Set-LocationRepos
Set-alias touch New-File
Set-alias grep findstr	

$ENV:STARSHIP_CONFIG = "$HOME\.starship\starship.toml"
Invoke-Expression (&starship init powershell)

# oh-my-posh init pwsh | invoke-expression

# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/atomic.omp.json" | invoke-expression
