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
    Param(
        [Alias("Path")]
        [ValidateScript({if ($_) { Test-Path $_}})]
        [string]$srcpath
    )
    $dest = $srcpath.TrimEnd("\/") + ".zip"
    Compress-Archive -Path $srcpath -Destination $dest -Force
    if (!$?) {
        Write-Host "error while compressing"
        return;
    }
    Remove-Item $srcpath -Recurse
    gpg -c $dest 
    if (!$?) {
        Write-Host "error while encrypting ${srcpath}"
        return;
    }
    Remove-Item $dest
}

function decrypt-dir {
    Param(
        [Alias("Path")]
        [ValidateScript({if ($_) { Test-Path $_}})]
        [string]$srcpath
    )
    $pathArchive = $srcpath.SubString(0, $srcpath.Length - 4)
    gpg -d -o $pathArchive $srcpath
    if (!$?) {
        Write-host "error while decrypting ${srcpath}"
    }
    Expand-Archive -Path $pathArchive -Destination . -Force
    if (!$?) {
        Write-Host "error while extracting archive $pathArchive"
        return;
    }
    Remove-Item $srcpath
    Remove-Item $pathArchive
}
