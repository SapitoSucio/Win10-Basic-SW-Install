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
        Write-Host "Unfortunately, Chocolatey doesn't have a package for AMD"
        
	} elseif ($GPU.contains("Intel")) {

        BeautySectionTemplate -Text "Installing Intel drivers!"
        choco install "chocolatey-misc-helpers.extension" -y    # intel-dsa Dependency
        choco install "dotnet4.7" -y                            # intel-dsa Dependency
        choco install "intel-dsa" -y
        choco install "intel-graphics-driver" -y

    } elseif ($GPU.contains("NVIDIA")) {

        BeautySectionTemplate -Text "Installing NVIDIA drivers!"
        choco install "geforce-experience" -y
        choco feature enable -n=useRememberedArgumentsForUpgrades
        cinst geforce-game-ready-driver --package-parameters="'/dch'"
        choco install "geforce-game-ready-driver" -y

    }

    $EssentialPackages = @(
        "7zip.install"
        "googlechrome"
        "notepadplusplus.install"
        "onlyoffice"
        "qbittorrent"
        "ublockorigin-chrome"
        "winrar"                                # English only
        "vlc"

        # [DIY] Remove the # if you want to install something.

        #"audacity"
        #"brave"
        #"firefox"                              # The person may likes Chrome
        #"imgburn"
        #"obs-studio"
        #"paint.net"
        #"python"
        #"spotify"
        #"sysinternals"
        #"wireshark"
    )
    $TotalPackagesLenght = $EssentialPackages.Length+1

    BeautyTitleTemplate -Text "Installing Packages"
    foreach ($Package in $EssentialPackages) {
        TitleWithContinuousCounter -Text "Installing: $Package" -MaxNum $TotalPackagesLenght
        choco install $Package -y # --force
    }

    # For Java (JRE) correct installation
    if ($Architecture.contains("32-bits")) {
        TitleWithContinuousCounter -Text "Installing: jre8 (32-bits)"
        choco install "jre8" -PackageParameters "/exclude:64" -y
    } elseif ($Architecture.contains("64-bits")) {
        TitleWithContinuousCounter -Text "Installing: jre8 (64-bits)"
        choco install "jre8" -PackageParameters "/exclude:32" -y
    }
    
}

$Ask = "Do you plan to play Games on this Machine?
All important Gaming clients and Required Game Softwares to Run Games will be installed.
+ Discord included."
function InstallGamingPackages { # You Choose

    switch (ShowQuestion -Title "Read carefully" -Message $Ask) {
        'Yes' {

            Write-Host "You choose Yes."
            $GamingPackages = @(
                "directx"
                "discord.install"
                "dotnetfx"      # Microsoft .NET Framework (Latest)
                "parsec"
                "steam"
                "vcredist2005"  # Microsoft Visual C++ 2005 SP1 Redistributable Package
                "vcredist2008"  # Microsoft Visual C++ 2008 SP1 Redistributable Package
                "vcredist2010"  # Microsoft Visual C++ 2010 Redistributable Package
                "vcredist2012"  # Microsoft Visual C++ 2012 Redistributable Package
                "vcredist2013"  # Visual C++ Redistributable Packages for Visual Studio 2013
                "vcredist140"   # Microsoft Visual C++ Redistributable for Visual Studio 2015-2019
                
                # [DIY] Remove the # if you want to install something.

                #"origin"       # [DIY] I don't like Origin
            )
            $TotalPackagesLenght = $TotalPackagesLenght + $GamingPackages.Length
        
            BeautyTitleTemplate -Text "Installing Packages"
            foreach ($Package in $GamingPackages) {
                TitleWithContinuousCounter -Text "Installing: $Package" -MaxNum $TotalPackagesLenght
                choco install $Package -y # --force
            }

        }
        'No' {
            Write-Host "You choose No. (No = Cancel)"
        }
        'Cancel' { # With Yes, No and Cancel, the user can press Esc to exit
            Write-Host "You choose Cancel. (Cancel = No)"
        }
    }

}

QuickPrivilegesElevation                # Check admin rights
PrepareRun                              # Import modules from lib folder
UnrestrictPermissions                   # Unlock script usage
SetupConsoleStyle                       # Just fix the font on the PS console
$Architecture = CheckOSArchitecture     # Checks if the System is 32-bits or 64-bits or Something Else
$GPU = DetectVideoCard                  # Detects the current GPU
InstallChocolatey                       # Install Chocolatey on Powershell
InstallPackages                         # Install the Showed Softwares
InstallGamingPackages                   # Install the most important Gaming Clients and Required Softwares to Run Games
RestrictPermissions                     # Lock script usage
Taskkill /F /IM $PID                    # Kill this task by PID because it won't exit with the command 'exit'