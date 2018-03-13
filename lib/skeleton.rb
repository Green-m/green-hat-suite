#!/usr/bin/env ruby
# -*- coding: binary -*-
# Code by Green-m
# Test  on ruby 2.3.3
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'output'
require 'utils'
require 'find'

module Compilers
    @@compilers_exist = {}
    @@compilers_path = {}

    def self.compilers_path
        @@compilers_path
    end

    def self.compilers_exist
        @@compilers_exist
    end

    def self.getCompilerCommand(compiler_type,tempfile,tempexe)
        compiler_command = ""

        case compiler_type 
            
        when 'clang'
            compiler_command = "clang-cl.exe /EHsc #{tempfile} /link /SUBSYSTEM:windows /ENTRY:mainCRTStartup /out:#{tempexe} "

        when 'mingw32'
            if Options::PLATFORM == 'linux'
                compiler_command = "i686-w64-mingw32-gcc -m32 -Wl,-subsystem,windows  #{tempfile} -o #{tempexe}  -lwsock32 -lpsapi"
            else
                compiler_command = %Q{%comspec% /c "i686-w64-mingw32-gcc.exe -m32 -Wl,-subsystem,windows  #{tempfile} -o #{tempexe}  -lwsock32 -lpsapi"}
            end

        when 'tdm_gcc'
            if Options::PLATFORM == 'windows'
                compiler_command = "gcc.exe -m32 -Wl,-subsystem,windows #{tempfile} -o #{tempexe} -lwsock32 -lpsapi"
            else
                compiler_command = "wine gcc.exe -m32 -Wl,-subsystem,windows #{tempfile} -o #{tempexe} -lwsock32 -lpsapi"
            end
            
        when 'cl'
           
            # compiler_command =  '%comspec% /c ""C:\Program Files (x86)\Microsoft Visual C++ Build Tools\vcbuildtools.bat" x86 && cl.exe /EHsc '
            # compiler_command << "#{tempfile} /link /SUBSYSTEM:windows /ENTRY:mainCRTStartup /out:#{tempexe} " + '"'
            
            compiler_command = %Q{%comspec% /c ""#{@@compilers_path[:cl]}" x86 && cl.exe /EHsc #{tempfile} /link /SUBSYSTEM:windows /ENTRY:mainCRTStartup /out:#{tempexe} " }
        else
            output_bad "Cann't recognize compiler type #{compiler_type}"
        end

        compiler_command
    end

    def self.getCompilerType(compiler_command)
        compiler_type = ""

        if compiler_command.include?('clang')
            compiler_type = 'clang'
        elsif compiler_command.include?('mingw32')
            compiler_type = 'mingw32'
        elsif compiler_command.include?('gcc.exe')
            compiler_type = 'tdm_gcc'
        elsif compiler_command.include?('cl.exe')
            compiler_type = 'cl'
        else
            compiler_type = 'unknown'
        end
        compiler_type
        
    end

    def self.cl_command_check
        vs_install_path = []
        cl_path = []

        begin
            # find vs install path
            ENV.each {|k,v| vs_install_path << v if k =~ /^VS\d*COMNTOOLS/}

            # change to visual C++ path
            vs_install_path.map!{|dir|dir = File.expand_path('../..',dir) + '/VC/' }

            # find vc command 
            vs_install_path.each do |dir|
                Find.find(dir) do |path|
                    cl_path << path if path.include?('vcvarsall.bat')
                end
            end


            #@@compilers_path[:cl] = cl_path
            cl_path.each do |path|
                if command_check(%Q{%comspec% /c ""#{path}" x86 && cl.exe"})
                    @@compilers_path[:cl] = path
                    break
                end
            end


        
        rescue Exception => e
            output_bad e.message
            output_bad e.backtrace.inspect
        end
        output_warning("Visual C++ build tools not found, highly recommended to install it to get better results ! ") unless @@compilers_path[:cl]
        @@compilers_path[:cl] ? true : false

    end


    def self.command_check(cmd)
        val = true
        begin
            stdin, stdout, stderr  = Open3.popen3(cmd)
            stderr = stderr.read.downcase!||""
            stdout = stdout.read.downcase!||""

            #  check compiler exist if use wine to run it 
            if  stderr.include?('wine') && stderr.include?('cannot find')  
                output_warning "#{Compilers.getCompilerType(cmd)} compiler not found"
                val = false 
            elsif stdout.include?('error') 
                val = false
                    
            end

        rescue SystemCallError 
            output_warning "#{Compilers.getCompilerType(cmd)} compiler not found"
            val = false
        rescue Exception => e
            output_line e.message
            output_line e.backtrace.inspect

        end
        val
    end

    def self.compilers_check 
        compilers_exist = @@compilers_exist

        output_status "Checking Compilers.........."

        if Options::PLATFORM == 'linux'
            compilers_exist[:mingw32] = command_check('i686-w64-mingw32-gcc --version')
            compilers_exist[:tdm_gcc] = command_check('wine gcc.exe --version')
        else 
            
            compilers_path = @@compilers_path

            compilers_exist[:tdm_gcc] = command_check('gcc.exe --version')
            compilers_exist[:cl] = self.cl_command_check

            #compilers_exist[:clang] = command_check('clang.exe --version')
            compilers_exist[:mingw32] = command_check("i686-w64-mingw32-gcc.exe --version")
        end

        @@compilers_exist = compilers_exist
        compilers_exist.each{|k,v|output_line "#{k} founded. " if v }

        #output_line ".............Checking Compilers End.........."

    end


end
