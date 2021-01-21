# Win10 Basic SW Install
This was made to install all needed softwares on a Post-Install Windows.
You can modify it as you want.

The best part is, if a Software was installed with Chocolatey,
in this specific case, they'll upgrade automatically.

## Download Latest Version

The code is always on the `main` branch, this is the *Bleeding-Edge* but always functional version.

- [Download [Zip]](https://github.com/LeDragoX/Win10-Basic-SW-Install/archive/main.zip)

## Usage Requirements

The `Installer.ps1` do not make everything automatically, follow these steps.

- Open `OpenPowershellHere.cmd` (For beginners) or the Powershell as admin on its folder.
- Enable execution of PowerShell scripts and Unblock PowerShell scripts and modules within this directory.

### Easy way (Prepare and Run once):

- Copy and Paste this entire line below on **Powershell**:
```Powershell
Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force; ls -Recurse .ps1 | Unblock-File; .\"Installer.ps1"
```

## Softwares that'll be Installed:

- Obviously, [Chocolatey](https://chocolatey.org/why-chocolatey) !!!
- The Lastest Graphics driver of your GPU; (Except AMD. See [Intel](https://chocolatey.org/packages/intel-graphics-driver) and [NVIDIA](https://chocolatey.org/packages/geforce-game-ready-driver))
- [7-Zip](https://chocolatey.org/packages/7zip);
- [Google Chrome](https://chocolatey.org/packages/GoogleChrome);
- [Notepad++](https://chocolatey.org/packages/notepadplusplus.install);
- [ONLYOffice Editors](https://chocolatey.org/packages/onlyoffice);
- [qBitTorrent](https://chocolatey.org/packages/qbittorrent);
- [uBlock Origin for Chrome](https://chocolatey.org/packages/ublockorigin-chrome);
- [WinRAR](https://chocolatey.org/packages/winrar) ( English only :/ );
- [VLC](https://chocolatey.org/packages/vlc);
- [Java SE Runtime Environment](https://chocolatey.org/packages/jre8). (This matches with your Windows Architecture and install the XX-bits only)

### [Optional] If you do play Games on PC, you'll want this (probably):

- [DirectX](https://chocolatey.org/packages/directx);
- [Discord](https://chocolatey.org/packages/discord.install);
- [Microsoft .NET Framework](https://chocolatey.org/packages/dotnetfx) (Latest); 
- [Parsec](https://chocolatey.org/packages/parsec);
- [Steam](https://chocolatey.org/packages/steam);
- [Microsoft Visual C++ 2005 SP1 Redistributable Package](https://chocolatey.org/packages/vcredist2005);
- [Microsoft Visual C++ 2008 SP1 Redistributable Package](https://chocolatey.org/packages/vcredist2008);
- [Microsoft Visual C++ 2010 Redistributable Package](https://chocolatey.org/packages/vcredist2010);
- [Microsoft Visual C++ 2012 Redistributable Package](https://chocolatey.org/packages/vcredist2012);
- [Visual C++ Redistributable Packages for Visual Studio 2013](https://chocolatey.org/packages/vcredist2013)
- [Microsoft Visual C++ Redistributable for Visual Studio 2015-2019](https://chocolatey.org/packages/vcredist140);

### These listed now are OPTIONAL, if you want to install them, just remove the # ( DIY ;D ).

- [Audacity](https://chocolatey.org/packages/audacity);
- [Brave](https://chocolatey.org/packages/brave/1.19.86);
- [Firefox](https://chocolatey.org/packages/Firefox);
- [ImgBurn](https://chocolatey.org/packages/imgburn);
- [OBS Studio](https://chocolatey.org/packages/obs-studio);
- [Paint.NET](https://chocolatey.org/packages/paint.net);
- [Python](https://chocolatey.org/packages/python/) (Latest);
- [Spotify](https://chocolatey.org/packages/spotify);
- [Sys Internals](https://chocolatey.org/packages/sysinternals);
- [Wireshark](https://chocolatey.org/packages/wireshark).

## LICENSE

    MIT License

    Copyright (c) 2021 Plínio Larrubia

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
