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
if (Get-Alias curl -ErrorAction SilentlyContinue) {
    remove-item alias:curl
}

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


# simple variation of where from cmd or which from sh
function which {
    
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
        $srcpath,

        [Alias("BufferSize")]
        [UInt32]$Bufsize = 4096,

        [switch]$Remove
    )
    $buffer = [Byte[]]::new($Bufsize)
    $obj = Get-Item $srcpath
    $leftToWrite = $obj.Length
    $rnd = [System.Random]::new()
    $fileStream = New-Object IO.FileStream($obj, [IO.FileMode]::Open)
    while ($leftToWrite -gt $bufsize) {
        $rnd.NextBytes($buffer)
        $fileStream.Write($buffer, 0, $buffer.Length)
        $leftToWrite -= $Bufsize
    }
    if ($leftToWrite -ne 0) {
        $buffer = [Byte[]]::new($leftToWrite)
        $rnd.NextBytes($buffer)
        $fileStream.Write($buffer, 0, $buffer.Length)
    }
    $fileStream.Close()
    if ($Remove) {
        Remove-Item $obj
    }
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
        if (Test-Path $dest) {
            shred-file $dest -Remove
        }
        return;
    }

    shred-dir $srcpath
    Remove-Item $srcpath -Recurse
    shred-file $dest -Remove
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
    $tmpDst = $pathArchive.substring(0, $pathArchive.Length - 4)
    if (Test-Path $tmpDst) {
        $cd = [System.Management.Automation.Host.ChoiceDescription]
        $answer = $Host.UI.PromptForChoice(
            "Something in the path $tmpDst already exists.",
            "Remove it and continue?",
            @(
             $cd::new("y", "Remove existing $tmpDst and begin decrypting"),
             $cd::new("n", "Stop and leave everything as is")
            ),
            1
        )
        if ($answer -eq 1) {
            return;
        }
        Remove-Item $tmpDst -Recurse
    }
    gpg -d -o $pathArchive $srcpath
    if (!$?) {
        Write-Host "error while decrypting ${srcpath}"
        return;
    }
    Expand-Archive -Path $pathArchive -Destination . -Force
    if (!$?) {
        Write-Host "error while extracting archive $pathArchive"
        shred-file $pathArchive -Remove
        if (Test-Path $tmpDst) {
            shred-dir $tmpDst
            Remove-Item $tmpDst -Recurse
        }
        return;
    }
    Remove-Item $srcpath
    shred-file $pathArchive -Remove
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
