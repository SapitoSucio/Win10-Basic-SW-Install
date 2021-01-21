function QuickPrivilegesElevation {
	# Used from https://stackoverflow.com/a/31602095 because it preserves the working directory!
	if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
}
# Your script here

function InstallChocolatey {

    # Description:
    # This script will use Windows package manager to bootstrap Chocolatey and
    # install a list of packages. Script will also install Sysinternals Utilities
    # into your default drive's root directory.

    $Packages = @(
        "notepadplusplus.install"
        "peazip.install"
        #"7zip.install"
        #"aimp"
        #"audacity"
        #"autoit"
        #"classic-shell"
        #"filezilla"
        #"firefox"
        "gimp"
        #"google-chrome-x64"
        #"imgburn"
        #"keepass.install"
        #"paint.net"
        #"putty"
        #"python"
        "qbittorrent"
        #"speedcrunch"
        #"sysinternals"
        #"thunderbird"
        "vlc"
        #"windirstat"
        #"wireshark"
    )

    # Adapted From https://github.com/W4RH4WK/Debloat-Windows-10/blob/master/utils/install-basic-software.ps1
    Write-Host "Setting up Chocolatey software package manager"
    Get-PackageProvider -Name chocolatey -Force

    Write-Host "Setting up Full Chocolatey Install"
    Install-Package -Name Chocolatey -Force -ProviderName chocolatey
    $ChocoPath = (Get-Package chocolatey | ?{$_.Name -eq "chocolatey"} | Select @{N="Source";E={((($a=($_.Source -split "\\"))[0..($a.length - 2)]) -join "\"),"Tools\chocolateyInstall" -join "\"}} | Select -ExpandProperty Source)
    & $ChocoPath "upgrade all -y"
    choco install chocolatey-core.extension --force

    Write-Host "Installing Packages"
    foreach ($Package in $Packages) {
        Write-Host "Installing: $Package"
        choco install $Package --force -y
    }

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