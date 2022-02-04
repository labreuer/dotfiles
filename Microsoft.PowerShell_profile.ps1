Set-Alias st 'C:\Program Files\Sublime Text 3\sublime_text.exe'
Set-Alias bk Open-Book
Set-Alias op 'C:\Program Files\GPSoftware\Directory Opus\dopus.exe'
Set-Alias setc Set-Clipboard
Set-Alias getc Get-Clipboard
function cpl { (Get-History -Count 1).CommandLine | Set-Clipboard }
function pwdc { $pwd.Path | Set-Clipboard }

Set-Alias filt C:\Users\labreuer\Dropbox\Disqus\spam.ps1
function Parse-ViafouraTwitterLink() {
    $uri = [System.Uri](Get-Clipboard)
    if ($uri.Query -match '[?&]text=([^&#]+)') {
        $text = [System.Web.HttpUtility]::UrlDecode($Matches[1]);
        if ($text -match "http\S+") {
            $uri2 = [System.Uri]$Matches[0];
            # $($uri2.scheme)
            # for some reason Viafoura chooses http over https here; force https
            $link = "https://$($uri2.Host)$($uri2.LocalPath)$($uri2.Fragment)";
            Write-Host $link -ForegroundColor Green
            $link | Set-Clipboard
        } else {
            Write-Error "Could not parse text.";
        }

    } else {
        Write-Error "Could not parse URI query.";
    }
}

function helper() { st '~\DropBox\helper_scripts.js' }


function vim([string]$name) {
    $name = [Regex]::Replace($name, '^([a-zA-Z]):', { param($m) "/mnt/" + $m.Groups[1].Value.ToLower() })
    $name = $name -replace '\\', '/'
    $name = $name -replace ' ', '\ '
    #$name
    bash -c "vim '$name'"
}

function last($pattern) { 
    if ($pattern -notmatch '\*') { $pattern += '*'}
    (ls $pattern | sort LastWriteTime | select -last 1).FullName
}

function stl($pattern) {
    $l = last $pattern
    if ($l) {
        st $l
    } else {
        Write-Error "No files matched $pattern"
    }
}

function proj ([int]$n=17) { cd "~/Documents/Visual Studio 20$n/Projects" }
$profile_console = '~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1'
function Edit-Profile([switch]$console) { if (-not $console) { vim $profile } else { vim $profile_console } }
function Edit-Vimrc { vim ~\.vimrc }

function Summarize-Directory($dir=".") {
    ls $dir |
        % {
            $f = $_;
            ls -r $_.FullName |
                Measure-Object -Property Length -Sum |
                Select @{ Name = "Name"; Expression = { $f } }, Sum }
}

Set-Alias du Summarize-Directory

function duh($dir=".") {
    du | 
        sort Sum -descending | 
        ft @{n="Name";e={$_.Name};w=20}, 
           @{n="MB";e={($_.Sum/1MB)};f="0.00";w=10;a="right"; }
}

function Open-Book([switch]$listOnly=$false, [switch]$save=$false) {
    # instead of the following argument list: $filename_part, [int]$idx=-1
    # allow quotation marks to be excluded in searches; if the last parsed
    # argument is an integer, use it as $idx
    [int]$idx = -1;
    [int]$len = $args.Length;
    if ([int]::TryParse($args[-1], [ref]$idx)) {
        $len -= 1;
    } else {
        $idx = -1; # TryParse always writes to the [out] parameter
    }
    $filename_part = $args[0..($len-1)] -join " ";

    $files = @(Search-Index -filePattern "*$filename_part*" -path "C:\Users\labreuer\Dropbox\");
    if ($listOnly) {
        Write-Output $files
        return
    }
    if ($files.Length -eq 1) {
        & $files[0]
    } elseif (0 -le $idx -and $idx -lt $files.Length) {
        if ($save) {
            Save-PreferredBook $files $idx
        }
        & $files[$idx]
    } else {
        $preferred = Find-PreferredBook $files
        if ($preferred) {
            & $preferred
        } else {
            $files | % {$i=0} { "{0}  {1}" -f ($i++, $_) }
        }
    }
}

function Save-PreferredBook($set, $idx) {
    $f = "$PSScriptRoot\Open-Book_priorities.config"
    $files | % {$i=0} { "{0}{1}  {2}" -f (($i -eq $idx ? ">" : ""), $i++, $_) } >> $f
    "" >> $f
}

function Find-PreferredBook($set) {
    $f = "$PSScriptRoot\Open-Book_priorities.config"
    $x = @()
    $preferred = $null
    foreach ($line in cat $f) {
        if ($line -and $line -match '^(>)?(?:\d+\s+)?(.*)') {
            $x += @($matches[2])
            if ($matches[1]) {
                $preferred = $matches[2]
            }
        } else {
            if (!(Compare-Object $set $x)) {
                return $preferred
            }
            $x = @()
        }
    }
    if ($x.Length -gt 0) {
        Write-Error "$f should end in two newlines"
    }
}

function To-Hashtable {
    begin { $h = @{} }
    process { $h[$_.ToString()] = $true }
    end { return $h }
}

# https://mmwps.wordpress.com/2014/08/20/170/#more-170
function To-HashSet {
    # https://stackoverflow.com/a/12875189/2328341
    return New-Object System.Collections.Generic.HashSet[string] (,[string[]]@($input))
}

## B&C ##
function web4 {
    if (!$global:labreuer) { $global:labreuer = Get-Credential }
    Enter-PSSession -ComputerName web4 -Authentication Kerberos -Credential $labreuer
}


function head($f, $n = 10) {
    cat $f | select-object -first $n
}
