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

Run metasploit to find more details.  

Upload to virustotal   

![image](https://github.com/Green-m/green-hat-suite/blob/master/image/pic2.png)


Contact to me If you have any question .
