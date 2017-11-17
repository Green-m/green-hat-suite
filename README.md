# Green-hat-suite
-------------------------------------------
Green-hat-suite is a tool to make meterpreter evade antivirus.  

Put this green hat on others head.

## Install on Kali
```
gem install os   
apt-get install mingw-w64
apt-get install wine

# install tdm-gcc from sourceforge
TMP=`mktemp /tmp/XXXXXXXXX.exe` && wget https://sourceforge.net/projects/tdm-gcc/files/latest/download -O $TMP && wine $TMP && rm $TMP
```

Notice:
Please use ruby 2.2.x or above,otherwise it could cause some error.  
***You must install metasploit before start!***

## Start green-hat-suite
```
git clone https://github.com/Green-m/green-hat-suite.git
cd green-hat-suite
ruby greenhat.rb

```
