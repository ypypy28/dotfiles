if ($isWindows) {
    chcp 65001
}

Import-Module PSReadLine
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Chord Ctrl+j -Function AcceptLine
Set-PSReadLineKeyHandler -Chord Ctrl+Enter -Function AcceptLine


# ENVIRONMENT VARIABLES
# for vim to be able to detect powershell
$env:TERM = "posh"

# remove curl alias, because windows already have regular curl
# remove-item alias:curl

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
            # if we somewhere else usual prompt
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


# running vim without .vimrc settings
function vi {
$t = [string]::Join(" ", $args)

vim -u NONE $t
}

function encrypt-dir {
    $path = $args[0]
    $dest = $args[0].TrimEnd("\/") + ".zip"
    Compress-Archive -Path $path -Destination $dest -Force
    Remove-Item $path -Recurse
    gpg -c $dest 
    Remove-Item $dest
}

function decrypt-dir {
    $path = $args[0]
    $pathArchive = $path.SubString(0, $path.Length - 4)
    gpg -d -o $pathArchive $path
    Expand-Archive -Path $pathArchive -Destination . -Force
    Remove-Item $path
    Remove-Item $pathArchive
}
