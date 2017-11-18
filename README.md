# Green-hat-suite
-------------------------------------------
Green-hat-suite is a tool to make meterpreter evade antivirus.  

Put this green hat on others head.

## Install on Kali
```
apt-get install metasploit-framework
gem install os   
apt-get install mingw-w64
apt-get install wine

# install tdm-gcc from sourceforge
TMP=`mktemp /tmp/XXXXXXXXX.exe` && wget https://sourceforge.net/projects/tdm-gcc/files/latest/download -O $TMP && wine $TMP && rm $TMP
```

Notice:
Please use ruby 2.2.x or above,otherwise it could cause some error.  


## Start green-hat-suite  
***You must install metasploit before start!***
```
git clone https://github.com/Green-m/green-hat-suite.git
cd green-hat-suite
ruby greenhat.rb

```

![image](https://github.com/Green-m/green-hat-suite/blob/master/image/pic1.png)

Upload to virustotal   

![image](https://github.com/Green-m/green-hat-suite/blob/master/image/pic2.png)

