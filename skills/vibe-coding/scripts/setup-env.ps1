# Detect the tools this phase needs and install only what is missing.
# Official archives are unpacked into the user directory. winget is not used.
# Does not install MySQL, Redis, or Elasticsearch.
param(
    [switch]$Server,
    [switch]$Web,
    [switch]$Admin,
    [switch]$Docker
)

$ErrorActionPreference = "Continue"
$script:Fail = $false
$script:PathNote = @()
$LocalRoot = Join-Path $env:USERPROFILE ".local"

function Record([string]$Name, [string]$State, [string]$Detail) {
    Write-Output "$Name`t$State`t$Detail"
    if ($State -eq "fail") { $script:Fail = $true }
}

function Add-PathNote([string]$Dir) {
    if (-not $Dir) { return }
    if ($script:PathNote -notcontains $Dir) { $script:PathNote += $Dir }
    $env:Path = "$Dir;$env:Path"
}

function Refresh-Path {
    $machine = [Environment]::GetEnvironmentVariable("Path", "Machine")
    $user = [Environment]::GetEnvironmentVariable("Path", "User")
    $env:Path = "$machine;$user"
    foreach ($dir in @(
        (Join-Path $LocalRoot "bin"),
        (Join-Path $LocalRoot "go\bin"),
        (Join-Path $LocalRoot "node"),
        (Join-Path $LocalRoot "mingit\cmd"),
        "C:\Program Files\Git\cmd",
        "C:\Program Files\Go\bin",
        "C:\Program Files\nodejs",
        "C:\Program Files\Docker\Docker\resources\bin"
    )) {
        if (Test-Path $dir) { $env:Path = "$dir;$env:Path" }
    }
}

function Has([string]$CommandName) {
    return [bool](Get-Command $CommandName -ErrorAction SilentlyContinue)
}

function VersionOf([string]$Exe, [string[]]$Args) {
    try {
        $out = & $Exe @Args 2>$null | Select-Object -First 1
        return "$out".Trim()
    } catch {
        return ""
    }
}

function Get-Zip([string]$Url, [string]$Dest) {
    $tmp = Join-Path $env:TEMP ("setup-env-" + [guid]::NewGuid().ToString("N"))
    New-Item -ItemType Directory -Force -Path $tmp | Out-Null
    $zip = Join-Path $tmp "pkg.zip"
    Invoke-WebRequest -Uri $Url -OutFile $zip -UseBasicParsing
    if (Test-Path $Dest) { Remove-Item -Recurse -Force $Dest }
    New-Item -ItemType Directory -Force -Path (Split-Path $Dest) | Out-Null
    Expand-Archive -Path $zip -DestinationPath $Dest -Force
    Remove-Item -Recurse -Force $tmp
}

function Install-GitLocal {
    $rel = Invoke-RestMethod -Uri "https://api.github.com/repos/git-for-windows/git/releases/latest" -UseBasicParsing
    $pattern = if ($env:PROCESSOR_ARCHITECTURE -eq "ARM64") { "MinGit-*-arm64.zip" } else { "MinGit-*-64-bit.zip" }
    $asset = $rel.assets | Where-Object { $_.name -like $pattern -and $_.name -notlike "*busybox*" } | Select-Object -First 1
    if (-not $asset) { return $false }
    $dest = Join-Path $LocalRoot "mingit"
    Get-Zip $asset.browser_download_url $dest
    Add-PathNote (Join-Path $dest "cmd")
    return (Has "git")
}

function Install-GoLocal {
    $text = (Invoke-WebRequest -Uri "https://go.dev/VERSION?m=text" -UseBasicParsing).Content
    $ver = ($text -split "`n")[0].Trim()
    $cpu = if ($env:PROCESSOR_ARCHITECTURE -eq "ARM64") { "arm64" } else { "amd64" }
    $parent = $LocalRoot
    $dest = Join-Path $parent "go"
    if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
    New-Item -ItemType Directory -Force -Path $parent | Out-Null
    $tmp = Join-Path $env:TEMP ("setup-env-go-" + [guid]::NewGuid().ToString("N"))
    New-Item -ItemType Directory -Force -Path $tmp | Out-Null
    $zip = Join-Path $tmp "go.zip"
    Invoke-WebRequest -Uri "https://go.dev/dl/$ver.windows-$cpu.zip" -OutFile $zip -UseBasicParsing
    Expand-Archive -Path $zip -DestinationPath $parent -Force
    Remove-Item -Recurse -Force $tmp
    Add-PathNote (Join-Path $dest "bin")
    return (Has "go")
}

function Install-NodeLocal {
    $index = Invoke-RestMethod -Uri "https://nodejs.org/dist/index.json" -UseBasicParsing
    $lts = $index | Where-Object { $_.lts } | Select-Object -First 1
    $cpu = if ($env:PROCESSOR_ARCHITECTURE -eq "ARM64") { "win-arm64" } else { "win-x64" }
    $ver = $lts.version
    $tmp = Join-Path $env:TEMP ("setup-env-node-" + [guid]::NewGuid().ToString("N"))
    New-Item -ItemType Directory -Force -Path $tmp | Out-Null
    $zip = Join-Path $tmp "node.zip"
    Invoke-WebRequest -Uri "https://nodejs.org/dist/$ver/node-$ver-$cpu.zip" -OutFile $zip -UseBasicParsing
    Expand-Archive -Path $zip -DestinationPath $tmp -Force
    $extracted = Get-ChildItem $tmp -Directory | Select-Object -First 1
    $dest = Join-Path $LocalRoot "node"
    if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
    Move-Item $extracted.FullName $dest
    Remove-Item -Recurse -Force $tmp
    Add-PathNote $dest
    return (Has "node")
}

function Install-DockerLocal {
    $page = (Invoke-WebRequest -Uri "https://download.docker.com/win/static/stable/x86_64/" -UseBasicParsing).Content
    $names = [regex]::Matches($page, "docker-[0-9]+\.[0-9]+\.[0-9]+\.zip") | ForEach-Object { $_.Value }
    $name = $names | Sort-Object | Select-Object -Last 1
    if (-not $name) { return $false }
    $tmp = Join-Path $env:TEMP ("setup-env-docker-" + [guid]::NewGuid().ToString("N"))
    New-Item -ItemType Directory -Force -Path $tmp | Out-Null
    $zip = Join-Path $tmp "docker.zip"
    Invoke-WebRequest -Uri "https://download.docker.com/win/static/stable/x86_64/$name" -OutFile $zip -UseBasicParsing
    Expand-Archive -Path $zip -DestinationPath $tmp -Force
    $bin = Join-Path $LocalRoot "bin"
    New-Item -ItemType Directory -Force -Path $bin | Out-Null
    Copy-Item (Join-Path $tmp "docker\docker.exe") (Join-Path $bin "docker.exe") -Force
    $rel = Invoke-RestMethod -Uri "https://api.github.com/repos/docker/compose/releases/latest" -UseBasicParsing
    $pluginDir = Join-Path $env:USERPROFILE ".docker\cli-plugins"
    New-Item -ItemType Directory -Force -Path $pluginDir | Out-Null
    $compose = $rel.assets | Where-Object { $_.name -eq "docker-compose-windows-x86_64.exe" } | Select-Object -First 1
    if ($compose) {
        Invoke-WebRequest -Uri $compose.browser_download_url -OutFile (Join-Path $pluginDir "docker-compose.exe") -UseBasicParsing
    }
    Remove-Item -Recurse -Force $tmp
    Add-PathNote $bin
    return (Has "docker")
}

Refresh-Path

if (Has "git") {
    Record "git" "keep" (VersionOf "git" @("--version"))
} else {
    try { Install-GitLocal | Out-Null } catch { Record "sudo" "manual" "下载 MinGit 失败: https://github.com/git-for-windows/git/releases/latest" }
    Refresh-Path
    if (Has "git") { Record "git" "install" (VersionOf "git" @("--version")) }
    else { Record "git" "fail" "MinGit 未解压到 $LocalRoot\mingit" }
}

if ($Server) {
    if (Has "go") {
        Record "go" "keep" (VersionOf "go" @("version"))
    } else {
        try { Install-GoLocal | Out-Null } catch { Record "sudo" "manual" "下载 Go 官方 zip 失败: https://go.dev/dl/" }
        Refresh-Path
        if (Has "go") { Record "go" "install" (VersionOf "go" @("version")) }
        else { Record "go" "fail" "Go 未解压到 $LocalRoot\go" }
    }
} else {
    Record "go" "skip" ""
}

if ($Web -or $Admin) {
    if ((Has "node") -and (Has "npm")) {
        Record "node" "keep" (VersionOf "node" @("-v"))
        Record "npm" "keep" (VersionOf "npm" @("-v"))
    } else {
        try { Install-NodeLocal | Out-Null } catch { Record "sudo" "manual" "下载 Node.js 官方 zip 失败: https://nodejs.org/dist/" }
        Refresh-Path
        if (Has "node") { Record "node" "install" (VersionOf "node" @("-v")) }
        else { Record "node" "fail" "Node.js 未解压到 $LocalRoot\node" }
        if (Has "npm") { Record "npm" "install" (VersionOf "npm" @("-v")) }
        else { Record "npm" "fail" "npm 没有随 Node.js 解压出来" }
    }
} else {
    Record "node" "skip" ""
    Record "npm" "skip" ""
}

if ($Docker) {
    if (-not (Has "docker")) {
        try { Install-DockerLocal | Out-Null } catch { Record "sudo" "manual" "下载 Docker 客户端失败: https://download.docker.com/win/static/stable/x86_64/" }
        Refresh-Path
    }
    if (Has "docker") {
        & docker info *> $null
        if ($LASTEXITCODE -eq 0) {
            Record "docker" "keep" (VersionOf "docker" @("version", "--format", "{{.Client.Version}}"))
        } else {
            Record "docker" "daemon-down" "客户端已可用。Windows 的守护进程不随压缩包启动，打开已安装的 Docker"
        }
        & docker compose version *> $null
        if ($LASTEXITCODE -eq 0) {
            Record "compose" "keep" (VersionOf "docker" @("compose", "version"))
        } else {
            Record "compose" "fail" "docker compose 插件没有放到 $env:USERPROFILE\.docker\cli-plugins"
        }
    } else {
        Record "docker" "fail" "Docker 客户端未解压到 $LocalRoot\bin"
        Record "compose" "fail" "docker compose 未安装"
    }
} else {
    Record "docker" "skip" ""
    Record "compose" "skip" ""
}

if ($script:PathNote.Count -gt 0) {
    $joined = $script:PathNote -join ";"
    Write-Output "path`tadd`t`$env:Path = `"$joined;`$env:Path`""
}

if ($script:Fail) {
    Write-Output "setup-env`tfailed"
    exit 1
}
Write-Output "setup-env`tok"
exit 0
