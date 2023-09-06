if ($isWindows) {
    chcp 65001
}

Import-Module PSReadLine
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Chord Ctrl+j -Function AcceptLine
Set-PSReadLineKeyHandler -Chord Ctrl+Enter -Function AcceptLine
if (Get-Module -Name PSFzf) {
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
}


# ENVIRONMENT VARIABLES
# for vim to be able to detect powershell
$env:WINTERM = "pwsh"

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


function shred-file {
    Param(
        [Alias("Path")]
        [Parameter(Mandatory)]
        [ValidateScript(
            {if (Test-Path $_ -PathType Leaf) { $true }
            else {throw "There is no file: $_"}})]
        $srcpath
    )
    $obj = Get-Item $srcpath
    $replacement = [Byte[]]::new($obj.Length)
    $rnd = [System.Random]::new()
    $rnd.NextBytes($replacement)
    [System.IO.File]::WriteAllBytes($obj.FullName, $replacement)
}


function shred-dir {
    Param(
        [Alias("Path")]
        [Parameter(Mandatory)]
        [ValidateScript(
            {if (Test-Path $_ -PathType Container) { $true }
            else {throw "There is no directory: $_"}})]
        $srcpath
    )
    foreach ($item in Get-ChildItem $srcpath -Recurse) {
        if (Test-Path $item -PathType Leaf) {
            shred-file -Path $item
        }
    }
}


function encrypt-dir {
    Param(
        [Alias("Path")]
        [Parameter(Mandatory)]
        [ValidateScript(
            {if (Test-Path $_ -PathType Container) { $true }
            else {throw "There is no directory: $_"}})]
        [string]$srcpath
    )
    $dest = $srcpath.TrimEnd("\/") + ".zip"
    Compress-Archive -Path $srcpath -Destination $dest -Force
    if (!$?) {
        Write-Host "error while compressing"
        return;
    }
    gpg -c $dest 
    if (!$?) {
        Write-Host "error while encrypting ${srcpath}"
        Remove-Item $dest
        return;
    }

    shred-dir $srcpath
    Remove-Item $srcpath -Recurse
    Remove-Item $dest
}


function decrypt-dir {
    Param(
        [Alias("Path")]
        [Parameter(Mandatory)]
        [ValidateScript(
            {if ($_.EndsWith(".zip.gpg") -and (Test-Path $_ -PathType Leaf)) { $true }
            else {throw "There is no encrypted dir file: $_"}})]
        [string]$srcpath
    )
    $pathArchive = (Get-Item $srcpath).BaseName
    gpg -d -o $pathArchive $srcpath
    if (!$?) {
        Write-Host "error while decrypting ${srcpath}"
        return;
    }
    Expand-Archive -Path $pathArchive -Destination . -Force
    if (!$?) {
        Write-Host "error while extracting archive $pathArchive"
        return;
    }
    Remove-Item $srcpath
    Remove-Item $pathArchive
}

function command-exists {
    Param(
        [Alias("Name")]
        [Parameter(Mandatory)]
        $cmd
    )
    if (Get-Command $cmd -ErrorAction SilentlyContinue) {
        return $true
    }
    $false
}


if (command-exists zoxide) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}
