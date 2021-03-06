﻿$apps = 'adb','liberica11-full','maven','nodejs-lts','git'
function CheckPoint-Scoop {
    $scoop = [Environment]::GetEnvironmentVariable('SCOOP', 'User')
    $scoopPath = 'D:\Scoop'
    if ($scoop -ne $scoopPath) {
        [Environment]::SetEnvironmentVariable("SCOOP", $scoopPath, 'User')
    }
    $scoopShims = 'D:\Scoop\shims'
    $path = [Environment]::GetEnvironmentVariable('PATH', 'User')
    if (!$path.Contains($scoopShims)) {
        $scoopShims += ';' + $scoopShims + ';'
        $path += $scoopShims
        [Environment]::SetEnvironmentVariable("PATH", $path, 'User')
    }
    $scoopDir = [System.IO.Path]::Combine('D:', 'Scoop')
    $scoopExist = Test-CommandExists scoop
    if (!$scoopExist) {
        if (![System.IO.Directory]::Exists($scoopDir)) {
            New-Item -ItemType "directory" -Path $scoopPath
            Set-ExecutionPolicy RemoteSigned -scope CurrentUser
            Invoke-WebRequest -useb get.scoop.sh | Invoke-Expression
        }
    }
    
}

#CheckPoint-Path;

Function Test-CommandExists
{

    Param ($command)

    $oldPreference = $ErrorActionPreference

    $ErrorActionPreference = ‘stop’

    try { if (Get-Command $command) { RETURN $true } }

    Catch { Write-Host “$command does not exist”; RETURN $false }

    Finally { $ErrorActionPreference = $oldPreference }

}

function CheckPoint-software($command, $name,$appPath, $set){
    $iswork = Test-CommandExists $command
    $scoopPath = [Environment]::GetEnvironmentVariable('SCOOP', 'User')
    if (!$iswork) {
        #if (!(Test-Path [System.IO.Path]::Combine($scoopPath, 'app', 'nodejs-lts'))) {
        if (!(Test-Path [System.IO.Path]::Combine($scoopPath, 'app', $appPath))) {
            #scoop install nodejs-lts
            scoop install $name
            $set
            #set-nodejs
        }
        else {
            $hasNodejs = scoop list 6>&1 | where-Object {$_.ToString().Contains($name)}
            if($null -ne $hasNodejs){
                scoop install $name
                $set
            }
        }
    }
}
function set-nodejs {
    npm config set prefix "D:\package\nodejs\modules"
    npm config set cache "D:\package\nodejs\cache"
    npm config set registry "https://registry.npm.taobao.org"
    # 然后将prefix的路径加入到Path中
    $path = [System.Environment]::GetEnvironmentVariable('Path', 'User')
    $newpath = $path + ";D:\package\nodejs\modules"
    [Environment]::SetEnvironmentVariable("Path", $newpath, 'User')
}

function set-nuget {
    #nuget路径设置 默认配置在  %AppData%\NuGet\NuGet.Config
    nuget config -set globalPackagesFolder=D:\package\nuget\packages # 使用 NUGET_PACKAGES 代替
    #nuget config -set http-cache=D:\package\nuget\v3-cache # 使用 NUGET_HTTP_CACHE_PATH 代替
    #nuget config -set plugins-cache=D:\package\nuget\plugins-cache # 使用 NUGET_PLUGINS_CACHE_PATH 代替
    #nuget config -set temp=D:\package\nuget\NuGetScratch # 无
    
}
function  test {
    Write-Host $?;
    scooq;
    Write-Host $?;
}