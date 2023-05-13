param(
    $version,
    $setting,
    [switch]$validate
)

if (-not $version){
    $version = Read-Host 'Which version are you installing? (19.2)'
}
if (-not $setting){
    $setting = Read-Host 'Are you installing for client or server?'
}

$json_path = "$PSScriptRoot\new-mods.json"

$mods = Get-Content -Raw -Path $json_path| ConvertFrom-Json

$minecraft_dir = Split-Path $PSScriptRoot -Parent

$mod_dir = "$minecraft_dir\mods"
$rp_dir = "$minecraft_dir\resourcepacks"

if (Test-Path "$minecraft_dir\versions\1.19.2-forge*") {
    'forge is installed'|Out-Host
} else {
    try {
        if (-not (Test-Path "$PSScriptRoot\forge.jar")){
            $ProgressPreference = 'SilentlyContinue'
            Invoke-WebRequest -Uri $mods.loader[0].'19.2'.url -OutFile "$PSScriptRoot\forge.jar"
            $ProgressPreference = 'Continue'
        }
        Start-Process java "-jar $PSScriptRoot\forge.jar" -NoNewWindow -Wait
    }
    catch {
        throw 'An error happened when trying to install Forge. Do you have java installed? Is java in the PATH?'

    }

}
"`n`n`n ##### Installing Mods ##### `n`n`n" | Out-Host
$n_mods = $mods.mods.Length
$i = 1
foreach ($_ in $mods.mods) {
    $per_complete = [math]::Round($i/$n_mods * 100,2)
    $i = $i + 1
    if (($_.client -eq $true) -and $setting -eq 'client') {
        "$per_complete% : Installing $($_.name)" | Out-Host
        $out_path = "$minecraft_dir\mods\$($_.name).jar"
        if ((Test-Path $out_path) -and (-not($validate))){
            "$per_complete% : $($_.name) already installed" | Out-Host
            continue
        }

        if(($version -eq '19.2') -and ($null -ne $_.'19.2')) {
            $ProgressPreference = 'SilentlyContinue'
            Invoke-WebRequest -Uri $_.'19.2'.url -OutFile $out_path
            $ProgressPreference = 'Continue'
            
        } else {
            "$per_complete% : $($_.name) Does not have to correct version"
        }
    }
}

"`n`n`n ##### Installing Resource Packs ##### `n`n`n" | Out-Host

$n_resourcepacks = $mods.resourcepacks.Length
$i = 1

foreach ($_ in $mods.resourcepacks) {
    $per_complete = [math]::Round($i/$n_resourcepacks* 100,2)
    $i = $i + 1
    if (($_.client -eq $true) -and $setting -eq 'client') {
        "$per_complete% : Installing $($_.name)" | Out-Host
        $out_path = "$minecraft_dir\resourcepacks\$($_.name).jar"
        if ((Test-Path $out_path) -and (-not($validate))){
            "$per_complete% : $($_.name) already installed" | Out-Host
            continue
        }
        if(($version -eq '19.2') -and ($null -ne $_.'19.2')) {
            $ProgressPreference = 'SilentlyContinue'
            Invoke-WebRequest -Uri $_.'19.2'.url -OutFile $out_path
            $ProgressPreference = 'Continue'

        } else {
            "$per_complete% : $($_.name) Does not have to correct version"
        }
    }
}