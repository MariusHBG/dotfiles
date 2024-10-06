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

if ($env:uwscreen -eq "true")
{
	$Env:KOMOREBI_CONFIG_HOME = "C:\Users\$env:USERNAME\.komorebi\komorebi-uwscreen"
}
else
{
	$Env:KOMOREBI_CONFIG_HOME = "C:\Users\$env:USERNAME\.komorebi\komorebi-2-screens"
}

$Env:XDG_CONFIG_HOME = "$HOME/.config"

# Allows wezterm to correctly determine the current working directory
# See https://wezfurlong.org/wezterm/shell-integration.html#osc-7-on-windows-with-powershell-with-starship
$prompt = ""
function Invoke-Starship-PreCommand {
    $current_location = $executionContext.SessionState.Path.CurrentLocation
    if ($current_location.Provider.Name -eq "FileSystem") {
        $ansi_escape = [char]27
        $provider_path = $current_location.ProviderPath -replace "\\", "/"
        $prompt = "$ansi_escape]7;file://${env:COMPUTERNAME}/${provider_path}$ansi_escape\"
    }
    $host.ui.Write($prompt)
}
