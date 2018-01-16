#!/usr/bin/env ruby
# -*- coding: binary -*-
# Code by Green-m
# Test  on ruby 2.3.3
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'output'
require 'utils'

module Encoder 

class Mixed
    def initialize(raw_code)
        @raw_code = raw_code
        @encoded_code = ""
        @decoded_code = ""
        @shellcode_name = ""
    end


    def generate

        return @encoded_code,@decoded_code,@shellcode_name

    end

end

class Xor
    def initialize(raw_code)
        @raw_code = raw_code
        @encoded_code = ""
        @decoded_code = ""
        @shellcode_name = ""
    end


    def generate
        raw_code = @raw_code
        raw_code_array = Encoder::cshellcode_pretreat(raw_code)
        @shellcode_name = random_funcname()
        xor_key_name = random_funcname()

        
        # generate xor keys 
        rand_xor_key_cformat = ""
        rand_xor_key_array = random_hex(5..15).scan(/.{1,2}/)
        rand_xor_key_array.each{|x|rand_xor_key_cformat << "\\x"+x}

        # do xor with ruby 
        xored_code_array = ""
        for i in 0...raw_code_array.length
            tmp = (raw_code_array[i][2..3].hex ^ rand_xor_key_array[i % rand_xor_key_array.length][0..1].hex).to_s(16)
            tmp = "0" + tmp if tmp.length == 1
            xored_code_array << "\\x" + tmp
        end

        xored_code_str = Encoder::c_shellcode_format(xored_code_array)

        # encoded code 
        @encoded_code = %Q{unsigned char #{@shellcode_name}[] = \n}
        @encoded_code << xored_code_str
        @encoded_code << "\n" + %Q{unsigned char #{xor_key_name}[] = "#{rand_xor_key_cformat}"; \n}
 
        # decoded code
        @decoded_code = %Q{for (int i=0; i<(sizeof(#{@shellcode_name})-1) ; i++)\n}
        @decoded_code << %Q{{#{@shellcode_name}[i] = #{@shellcode_name}[i] ^ #{xor_key_name}[i % (sizeof(#{xor_key_name}) - 1)];} \n}

        return @encoded_code,@decoded_code,@shellcode_name

    end

end
















end
