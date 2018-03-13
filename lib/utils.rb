#!/usr/bin/ruby  
# -*- coding: binary -*-

require 'securerandom'
require 'os'
require 'open3'

module Options

    if OS.windows?
        PLATFORM = 'windows'
    else 
        PLATFORM = 'linux'
    end

#    COMPILERS_WINDOWS = ['cl','clang','mingw32','tdm_gcc']
    COMPILERS_WINDOWS = ['cl','mingw32','tdm_gcc']
    COMPILERS_LINUX = ['mingw32','tdm_gcc']
end

class String
  def blank?
    if strip.empty?
        return true
    else
        return false
    end
  end
end

class NilClass
  def blank?
    return true
  end
end

def random_hex(range=(1..10000))
    lenth = rand(range)
    SecureRandom.hex(lenth)
end

def random_one_alpha
    chars = [('a'..'z').to_a, ('A'..'Z').to_a].join()
    random_char = chars[rand(chars.size)]
end

def random_funcname(range=(3..15))
    return random_one_alpha+random_hex(range)
end

def random_number(range)
    #SecureRandom.random_number(range)
    #for compatible we use rand rather than SecureRandom
    rand(range)
end


def tempname(extension=nil)
    
    tempfile = Dir.pwd + '/' + SecureRandom.hex(8)
    if extension 
        tempfile << ".#{extension}"
    end
    tempfile
end

def random_split_str(str,chunks=nil)
    chunks = chunks|| rand(2..6)
    new_str_array = []

    lindex = 0
    n = chunks - 1
    while 0 <= n do 

        remain_lenth = str.length - lindex - n 
        if n == 0
            rand_lenth = remain_lenth
        else
            rand_lenth = rand(1..remain_lenth)
        end
        new_str_array << str[lindex...(lindex+rand_lenth)]
        lindex = lindex + rand_lenth
        n -= 1
    end  

    new_str_array.map!{|x|x.is_a?(Array) ? x.join : x }
end


module Encoder 

    def self.bin_to_cshellcode(binshellcode)
        binshellcode.delete!("\n")
        shellcode = binshellcode.unpack('H*')[0]
        shellcode_array = shellcode.scan(/.{2}/)
        shellcode_array.map!{|x|%Q{"\\x#{x}"}}
        shellcode = shellcode_array.join.delete!('"')

        shellcode = c_shellcode_format(shellcode)
        shellcode = "unsigned char buf[] = \n" + shellcode
        return shellcode
    end

    # convert c shellcode to array, like ['\xaa','\xbb']
    def self.cshellcode_pretreat(shellcode)
        shellcode.sub!('unsigned char buf[] = ',"")
        shellcode.delete!("\n").delete!('";')
        shellcode = shellcode.scan(/\\x.{2}/)
    end

    def shellcode_xor(shellcode,key=nil)
        key = key||SecureRandom.hex
        shellcode = hex_xor_hex(hex_strip_prefix(shellcode),key)
        hex_to_rubyshellcode shellcode

    end



    # format "\xbe\xd1" transform to ""bed1"
    def self.hex_strip_prefix(str)
        str.unpack('H*')[0]
        str.force_encoding(Encoding::ASCII_8BIT)
    end

    # reverse of the hex_strip_prefix , add "\x" as prefix
    def self.hex_to_rubyshellcode(str)
        str.split.pack('H*').force_encoding(Encoding::ASCII_8BIT)
    end



    # return ruby format shellcode array
    def self.c_to_ruby_shellcode(shellcode)
        shellcode.sub!('unsigned char buf[] = ',"")
        shellcode = shellcode.split("\n").join().delete('";x').delete('\\')
        shellcode = shellcode.split.pack("H*")
        shellcode.force_encoding(Encoding::ASCII_8BIT)
    end

    def self.c_shellcode_format(shellcode)
        shellcode.force_encoding(Encoding::ASCII_8BIT)
        shellcode.delete!("\n")
        shellcode_array = shellcode.scan(/.{1,60}/)
        shellcode_array.map!{|x|%Q{"#{x}"}}
        shellcode = shellcode_array.join("\n")
        shellcode << ";"

    end

    # return c format shellcode array
    def self.ruby_to_c_shellcode(shellcode)
        shellcode.force_encoding(Encoding::ASCII_8BIT)

        shellcode.delete!("\n")
        shellcode_array = shellcode.scan(/.{1,15}/)
        shellcode_array.map!{|x|x.unpack("H*")[0]}
        #shellcode = shellcode.unpack("H*")[0]

        tmp_array = []
        shellcode_array.each do |shellcode|
            tmp = ""
            i = 0
            while i < shellcode.length-1 do 
                tmp << '\x' + shellcode[i..i+1]
                i += 2
            end
            tmp_array << tmp
        end

        tmp_array.map! do |shellcode|
            shellcode = %Q{"#{shellcode}"}
        end
        tmp_array = tmp_array.join("\n")
        tmp_array << ';'

    end

    # hexstring have the format like "bed1066772dac3"
    def self.hex_xor_hex(hexstring, keyhex)
        (hexstring.hex ^ keyhex.hex).to_s(16)
    end
end
