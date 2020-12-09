
function InstallJDKVersion($javaVersion, $jdkVersion, $url, $fileName, $jdkPath, $jrePath) {
    Write-Host "Installing $javaVersion..." -ForegroundColor Cyan

    # download
    Write-Host "Downloading installer"
    $exePath = "$env:USERPROFILE\$fileName"
    $logPath = "$env:USERPROFILE\$fileName-install.log"
    [System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
    $client = New-Object Net.WebClient
    $client.Headers.Add('Cookie', 'gpw_e24=http://www.oracle.com; oraclelicense=accept-securebackup-cookie')
    $client.DownloadFile($url, $exePath)

    # install
    Write-Host "Installing JDK to $jdkPath"
    Write-Host "Installing JRE to $jrePath"

    if($jdkVersion -eq 6) {
        $arguments = "/c start /wait $exePath /s ADDLOCAL=`"ToolsFeature,PublicjreFeature`" INSTALLDIR=`"\`"$jdkPath\`"`""
    } elseif ($jdkVersion -eq 7) {
        $arguments = "/c start /wait $exePath /s ADDLOCAL=`"ToolsFeature,PublicjreFeature`" /INSTALLDIR=`"$jdkPath`" /INSTALLDIRPUBJRE=`"\`"$jrePath\`"`""
    } else {
        $arguments = "/c start /wait $exePath /s ADDLOCAL=`"ToolsFeature,PublicjreFeature`" INSTALLDIR=`"$jdkPath`" /INSTALLDIRPUBJRE=`"$jrePath`""
    }
    $proc = [Diagnostics.Process]::Start("cmd.exe", $arguments)
    $proc.WaitForExit()

    # cleanup
    del $exePath
    Write-Host "$javaVersion installed" -ForegroundColor Green
}

if($java7) {
    Write-Host "Latest Java 7 already installed" -ForegroundColor Green
} else {
    InstallJDKVersion "JDK 1.7 x64" 7 "https://storage.googleapis.com/appveyor-download-cache/jdk/jdk-7u80-windows-x64.exe" "jdk-7u80-windows-x64.exe" "$env:ProgramFiles\Java\jdk1.7.0" "$env:ProgramFiles\Java\jre7"
}


# Set Java home
[Environment]::SetEnvironmentVariable("JAVA_HOME", "C:\Progra~1\Java\jdk1.7.0", "machine")
$env:JAVA_HOME="C:\Progra~1\Java\jdk1.7.0"

# Set Java home
[Environment]::SetEnvironmentVariable("JRE_HOME", "C:\Progra~1\Java\jre7", "machine")
$env:JRE_HOME="C:\Progra~1\Java\jre7"


# Add Inbound Firewall rules for Port 8081, 5896
New-NetFirewallRule -DisplayName "In-TCP-8081" -Direction Inbound -Protocol TCP -LocalPort 8081 -Action Allow
New-NetFirewallRule -DisplayName "In-TCP-5896" -Direction Inbound -Protocol TCP -LocalPort 5896 -Action Allow

Copy-Item -Path "C:\temp\hosts*" -Destination "C:\Windows\System32\drivers\hosts" -Recurse
Copy-Item -Path "C:\temp\*.jar" -Destination "C:\Program Files\Java\jre7\lib\security" -Recurse

md C:\Windows\system32\config\systemprofile\AppData\Local\Temp
