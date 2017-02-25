chcp 1251

# ENVIRONMENT VARIABLES
# for vim to be able to detect powershell
$env:TERM = "posh"

# fixed prompt - path shortend when too long
function prompt {

    $location = (Get-Location)

    # if cannot determine drive name (e.g after piping cd )
    if (!$location.Drive.Name) {
        $splitted_path = $location.Path -Split "::"

        if ($splitted_path[0] -eq "Microsoft.PowerShell.Core\FileSystem") {
            # if we in the FileSystem simply cd to the actual location
            cd ($location.Path -Split "::")[1]
            $location = (Get-Location)
        } else {
            # if we somewhere else usual promt
        "PS " + $location + "> "
        }
    }

    $p_arr = $location -Split "\\"
    $drive_name = $location.Drive.Name
    $depth = $p_arr.length

    if ($depth -gt 4) {

        "PS " + $drive_name + ":\|~" + ($depth-3) + "d~|\" + $p_arr[-2] + "\" + $p_arr[-1] + "> "
    }

    "PS " + $location + "> "
}

# simple variation of where from cmd
function whereis {
    
    foreach ($p in ((gci env: | where name -eq PATH).Value -Split ";" | select -Unique )) {

        if ($p) {
            if (test-path($p)) {
                ( gci $p | where Name -Match ("^"+$args[0]+"(?:\.exe|\.ps1|\.cmd)$") ).FullName
            }
        }
    }
    ""
}
