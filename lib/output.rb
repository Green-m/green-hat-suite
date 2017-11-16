#!/usr/bin/ruby  
#coding=utf-8



def red(text)
    "\e[31m#{text}\e[0m" 
end

def green(text)
    "\e[32m#{text}\e[0m"
end

def yellow(text)
    "\e[33m#{text}\e[0m"
end

def blue(text)
    "\e[36m#{text}\e[0m"
end


def output_bad(text)
    puts red("[!] Error: #{text}")
end

def output_good(text)
    puts green("[+] Success: #{text}")
end

def output_warning(text)
    puts yellow("[-] Warning: #{text}")
end

def output_line(text)
    puts ("[*] ") + text
end

def output_status(text)
    puts blue("[~] ") + text
end

def output_choose(text)
    puts green("[?] ") + text
end