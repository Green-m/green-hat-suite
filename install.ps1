
# ask for admin rights
$name = $PSScriptRoot + "\" + $MyInvocation.MyCommand.Name
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$name`"" -Verb RunAs; exit }

write-host "Checking if ruby installed"
ruby -v
if(!$?){
	write-host "Downloading ruby"
	(New-Object System.Net.WebClient).DownloadFile('https://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.3.3-x64.exe','c:\windows\temp\rubyinstaller-2.3.3-x64.exe')
	start-Process -FilePath 'c:\windows\temp\rubyinstaller-2.3.3-x64.exe' -wait
	Remove-item -path c:\windows\temp\rubyinstaller-2.3.3-x64.exe -force
}


gem install os

write-host "Checking if MSF installed"
msfconsole -v
if(!$?){
	write-host "Downloading metasploit framework..."
	(New-Object System.Net.WebClient).DownloadFile('https://windows.metasploit.com/metasploitframework-latest.msi','c:\windows\temp\metasploitframework-latest.msi')
	start-Process  msiexec.exe -ArgumentList '/i','c:\windows\temp\metasploitframework-latest.msi' -wait
	Remove-item -path c:\windows\temp\metasploitframework-latest.msi -force
}


write-host "Downloading tdm-gcc..."
(New-Object System.Net.WebClient).DownloadFile('https://excellmedia.dl.sourceforge.net/project/tdm-gcc/TDM-GCC%20Installer/tdm-gcc-5.1.0-3.exe','c:\windows\temp\tdm-gcc-5.1.0-3.exe')
start-Process -FilePath 'c:\windows\temp\tdm-gcc-5.1.0-3.exe' -wait
Remove-item -path c:\windows\temp\tdm-gcc-5.1.0-3.exe -force


write-host "Downloading Visualcppbuildtools..."
(New-Object System.Net.WebClient).DownloadFile('https://download.microsoft.com/download/5/f/7/5f7acaeb-8363-451f-9425-68a90f98b238/visualcppbuildtools_full.exe','c:\windows\temp\visualcppbuildtools_full.exe')
start-Process -FilePath 'c:\windows\temp\visualcppbuildtools_full.exe' -wait
Remove-item -path c:\windows\temp\visualcppbuildtools_full.exe -force


#write-host "Downloading mingw-w64..."
#(New-Object System.Net.WebClient).DownloadFile('https://downloads.sourceforge.net/mingw-w64/x86_64-5.3.0-release-posix-seh-rt_v4-rev0.7z', 'c:\windows\temp\x86_64-5.3.0-release-posix-seh-rt_v4-rev0.zip')

#$ZipFile = 'c:\windows\temp\x86_64-5.3.0-release-posix-seh-rt_v4-rev0.zip'
#$InstallPath = 'C:\Program Files\mingw'
#if(!(Test-Path $InstallPath))
#{
#    mkdir $InstallPath
#}
#$shellApp = New-Object -ComObject Shell.Application
#$files = $shellApp.NameSpace($ZipFile).Items()
#$shellApp.NameSpace($TargetFolder).CopyHere($files)
#
#Remove-item -path $ZipFile -force

write-host "Install End"