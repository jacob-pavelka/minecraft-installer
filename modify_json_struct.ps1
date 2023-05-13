$json_path = "$PSScriptRoot\mods.json"
$out_path = "$PSScriptRoot\new-mods.json"


$mods = Get-Content -Raw -Path $json_path| ConvertFrom-Json

$new_mods = @{datapacks = @(); resourcepacks = @();mods = @()}
$mods.mods | forEach-Object {

    $new_mod = @{}
    $new_mod['19.2'] = @{'url'=$_.url}
    $new_mod['name'] = $_.name
    $new_mod['server'] = $_.server
    $new_mod['client'] = $_.client
    $new_mod['type'] = $_.type
    $new_mods.mods += $new_mod

}
$mods.datapacks | forEach-Object {
    $new_mod = @{}
    $new_mod['19.2'] = @{'url'=$_.url}
    $new_mod['name'] = $_.name
    $new_mod['server'] = $_.server
    $new_mod['client'] = $_.client
    $new_mod['type'] = $_.type
    $new_mods.datapacks += $new_mod

}
$mods.resourcepacks | forEach-Object {

    $new_mod = @{}
    $new_mod['19.2'] = @{'url'=$_.url}
    $new_mod['name'] = $_.name
    $new_mod['server'] = $_.server
    $new_mod['client'] = $_.client
    $new_mod['type'] = $_.type
    $new_mods.resourcepacks += $new_mod

}



$new_mods | ConvertTo-Json -depth 10| Out-File $out_path