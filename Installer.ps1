function QuickPrivilegesElevation {
	# Used from https://stackoverflow.com/a/31602095 because it preserves the working directory!
	if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
}
# Your script here

Function PrepareRun {

    Push-Location -Path .\lib
        Get-ChildItem -Recurse *.ps*1 | Unblock-File
    Pop-Location

    Import-Module -DisableNameChecking $PSScriptRoot\lib\"Check-OS-Info.psm1"
    Import-Module -DisableNameChecking $PSScriptRoot\lib\"Count-N-Seconds.psm1"
    Import-Module -DisableNameChecking $PSScriptRoot\lib\"Set-Script-Policy.psm1"
    Import-Module -DisableNameChecking $PSScriptRoot\lib\"Setup-Console-Style.psm1"
    Import-Module -DisableNameChecking $PSScriptRoot\lib\"Simple-Message-Box.psm1"
    Import-Module -DisableNameChecking $PSScriptRoot\lib\"Title-Templates.psm1"

    Write-Host "Current Script Folder $PSScriptRoot"
    Write-Host ""
    Push-Location $PSScriptRoot

}

function InstallChocolatey {

    # This function will use Windows package manager to bootstrap Chocolatey and install a list of packages.

    # Adapted From https://github.com/W4RH4WK/Debloat-Windows-10/blob/master/utils/install-basic-software.ps1
    Write-Host "Setting up Chocolatey software package manager"
    Get-PackageProvider -Name chocolatey -Force
    
    Write-Host "Setting up Full Chocolatey Install"
    Install-Package -Name Chocolatey -Force -ProviderName chocolatey
    $ChocoPath = (Get-Package chocolatey | ?{$_.Name -eq "chocolatey"} | Select @{N="Source";E={((($a=($_.Source -split "\\"))[0..($a.length - 2)]) -join "\"),"Tools\chocolateyInstall" -join "\"}} | Select -ExpandProperty Source)
    & $ChocoPath "upgrade all -y"
    choco install chocolatey-core.extension -y #--force
    
    Write-Host "Creating daily task to automatically upgrade Chocolatey packages"
    # adapted from https://blogs.technet.microsoft.com/heyscriptingguy/2013/11/23/using-scheduled-tasks-and-scheduled-jobs-in-powershell/
    $ScheduledJob = @{
        Name = "Chocolatey Daily Upgrade"
        ScriptBlock = {choco upgrade all -y}
        Trigger = New-JobTrigger -Daily -at 2am
        ScheduledJobOption = New-ScheduledJobOption -RunElevated -MultipleInstancePolicy StopExisting -RequireNetwork
    }
    Register-ScheduledJob @ScheduledJob
    
}

function InstallPackages {

    # Install GPU drivers first
    BeautyTitleTemplate -Text "Installing Graphics driver"
    if ($GPU.contains("AMD")) {
        BeautySectionTemplate -Text "Installing AMD drivers!"
        # TODO
	} elseif ($GPU.contains("Intel")) {
        BeautySectionTemplate -Text "Installing Intel drivers!"
        choco install "chocolatey-misc-helpers.extension" -y    # intel-dsa Dependency
        choco install "dotnet4.7" -y                            # intel-dsa Dependency
        choco install "intel-dsa" -y
    } elseif ($GPU.contains("NVIDIA")) {
        BeautySectionTemplate -Text "Installing NVIDIA drivers!"
        choco install "geforce-experience" -y
        choco install "geforce-game-ready-driver" -y
    }

    $Packages = @(
        "7zip.install"
        #"audacity"
        "directx"
        "discord"
        #"firefox"                              # The person may likes Chrome
        "googlechrome"
        #"imgburn"
        #"dotnet4.7"                            # intel-dsa Dependency
        "jre8"
        #"keepass.install"
        "notepadplusplus.install"
        #"obs-studio"
        "onlyoffice"
        #"origin"
        #"paint.net"
        "parsec"
        #"peazip.install"
        #"python"
        "qbittorrent"
        "steam"
        #"sysinternals"
        "ublockorigin-chrome"
        #"winrar"                               # English only
        "vlc"
        #"wireshark"
    )
    $TotalPackagesLenght = $Packages.Length+1

    BeautyTitleTemplate -Text "Installing Packages"
    foreach ($Package in $Packages) {
        TitleWithContinuousCounter -Text "Installing: $Package" -MaxNum $TotalPackagesLenght
        choco install $Package -y # --force
    }

    # For Java (JRE) correct installation
    if ($Architecture.contains("32-bits")) {
        choco install "jre8" -PackageParameters "/exclude:64"
    } elseif ($Architecture.contains("64-bits")) {
        choco install "jre8" -PackageParameters "/exclude:32"
    }
    
}

QuickPrivilegesElevation                # Check admin rights
PrepareRun                              # Import modules from lib folder
UnrestrictPermissions                   # Unlock script usage
$Architecture = CheckOSArchitecture     # Checks if the System is 32-bits or 64-bits or Something Else
$GPU = DetectVideoCard                  # Detects the current GPU
InstallChocolatey                       # Install Chocolatey on Powershell
InstallPackages                         # Install the Showed Softwares
RestrictPermissions                     # Lock script usage