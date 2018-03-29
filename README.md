# Green-hat-suite
-------------------------------------------
```
  ____                       _           _               _ _       
 / ___|_ __ ___  ___ _ __   | |__   __ _| |_   ___ _   _(_) |_ ___ 
| |  _| '__/ _ \/ _ \ '_ \  | '_ \ / _` | __| / __| | | | | __/ _ \
| |_| | | |  __/  __/ | | | | | | | (_| | |_  \__ \ |_| | | ||  __/
 \____|_|  \___|\___|_| |_| |_| |_|\__,_|\__| |___/\__,_|_|\__\___|
                                                                   
```

Green-hat-suite is a tool to make meterpreter evade antivirus.  

Put this green hat on others head. 

## To do 
- [ ] Add windows meterpreter service. 
- [ ] Add installation automatically script on windows. 
- [ ] Add more document.


## Install on Kali/ubuntu/debian
```
# msf installed default on kali
# apt-get install metasploit-framework 
gem install os   
apt-get install mingw-w64
apt-get install wine

# install tdm-gcc from sourceforge
TMP=`mktemp /tmp/XXXXXXXXX.exe` && wget https://sourceforge.net/projects/tdm-gcc/files/latest/download -O $TMP && wine $TMP && rm $TMP
```

## Install on windows   

To install Green-hat-suite on windows is a little complicated, but it is recommanded to use it on windows for best result.  

So follow me step by step . 

- **Install ruby**  

  Download and install RubyInstallers from https://rubyinstaller.org/downloads/  

  Notice: Please use `ruby 2.2.x ` or above,otherwise it could cause some error.  

- **Install  Metasploit-framework**  

  Download and install metasploit-framework from https://windows.metasploit.com/  

- **Install Compilers**  

  `Be sure at least one of below compliers installed.`

  Download and install tdm-gcc from https://sourceforge.net/projects/tdm-gcc/  
  
  Download and install mingw32 from https://sourceforge.net/projects/mingw-w64/    
  
  (**Recommanded**) Download and install windows command line compiler  http://landinghub.visualstudio.com/visual-cpp-build-tools 



If warning says no mingw32, add enviroment varible in mingw32 root path like below.  
```
SET mingwpath=%~dp0mingw\mingw32\bin\
setx PATH "%PATH%;%mingwpath%; " 
```

If you download all of these installer in the same  directory, you can run the install.bat to install it .


The installation will last several hours, be patient. 

## Start green-hat-suite  

```
git clone https://github.com/Green-m/green-hat-suite.git
cd green-hat-suite
ruby greenhat.rb

```

![image](https://github.com/Green-m/green-hat-suite/blob/master/image/pic1.png)

```
Set other option if you have 
```

set other advanced option, its format is like below :

```
EnableStageEncoding=true StagerEncoder=x86/fnstenv_mov 
```


All the advanced options according to metasploit. 

![image](https://github.com/Green-m/green-hat-suite/blob/master/image/image.png) 

```
Payload advanced options (windows/meterpreter/reverse_tcp):

   Name                         Current Setting  Required  Description
   ----                         ---------------  --------  -----------
   AutoLoadStdapi               true             yes       Automatically load the Stdapi extension
   AutoRunScript                                 no        A script to run automatically on session creation.
   AutoSystemInfo               true             yes       Automatically capture system information on initialization.
   AutoVerifySession            true             yes       Automatically verify and drop invalid sessions
   AutoVerifySessionTimeout     30               no        Timeout period to wait for session validation to occur, in seconds
   EnableStageEncoding          false            no        Encode the second stage payload
   EnableUnicodeEncoding        false            yes       Automatically encode UTF-8 strings as hexadecimal
   HandlerSSLCert                                no        Path to a SSL certificate in unified PEM format, ignored for HTTP transports
   InitialAutoRunScript                          no        An initial script to run on session creation (before AutoRunScript)
   PayloadBindPort                               no        Port to bind reverse tcp socket to on target system.
   PayloadProcessCommandLine                     no        The displayed command line that will be used by the payload
   PayloadUUIDName                               no        A human-friendly name to reference this unique payload (requires tracking)
   PayloadUUIDRaw                                no        A hex string representing the raw 8-byte PUID value for the UUID
   PayloadUUIDSeed                               no        A string to use when generating the payload UUID (deterministic)
   PayloadUUIDTracking          false            yes       Whether or not to automatically register generated UUIDs
   PrependMigrate               false            yes       Spawns and runs shellcode in new process
   PrependMigrateProc                            no        Process to spawn and run shellcode in
   ReverseAllowProxy            false            yes       Allow reverse tcp even with Proxies specified. Connect back will NOT go through proxy but directly to LHOST
   ReverseListenerBindAddress                    no        The specific IP address to bind to on the local system
   ReverseListenerBindPort                       no        The port to bind to on the local system if different from LPORT
   ReverseListenerComm                           no        The specific communication channel to use for this listener
   ReverseListenerThreaded      false            yes       Handle every connection in a new thread (experimental)
   SessionCommunicationTimeout  300              no        The number of seconds of no activity before this session should be killed
   SessionExpirationTimeout     604800           no        The number of seconds before this session should be forcibly shut down
   SessionRetryTotal            3600             no        Number of seconds try reconnecting for on network failure
   SessionRetryWait             10               no        Number of seconds to wait between reconnect attempts
   StageEncoder                                  no        Encoder to use if EnableStageEncoding is set
   StageEncoderSaveRegisters                     no        Additional registers to preserve in the staged payload if EnableStageEncoding is set
   StageEncodingFallback        true             no        Fallback to no encoding if the selected StageEncoder is not compatible
   StagerRetryCount             10               no        The number of times the stager should retry if the first connect fails
   StagerRetryWait              5                no        Number of seconds to wait for the stager between reconnect attempts
   VERBOSE                      false            no        Enable detailed status messages
   WORKSPACE                                     no        Specify the workspace for this module

```


Run metasploit to find more details.  

Upload to virustotal   

![image](https://github.com/Green-m/green-hat-suite/blob/master/image/pic2.png)


Contact to me If you have any question .
