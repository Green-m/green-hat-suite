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
            
        when 'mingw32'
            if Options::PLATFORM == 'linux'
                compiler_command = "i686-w64-mingw32-gcc -m32 -Wl,-subsystem,windows  #{tempfile} -o #{tempexe}  -lwsock32 -lpsapi"
            else
        
            end

        when 'tdm_gcc'

                compiler_command = "wine gcc.exe -m32 -Wl,-subsystem,windows #{tempfile} -o #{tempexe} -lwsock32 -lpsapi"
 
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

        output_status ".............Checking Compilers.........."

        if Options::PLATFORM == 'linux'
            compilers_exist[:mingw32] = command_check('i686-w64-mingw32-gcc --version')
            compilers_exist[:tdm_gcc] = command_check('wine gcc.exe --version')
        else 
            
            compilers_path = @@compilers_path

        end

        @@compilers_exist = compilers_exist
        compilers_exist.each{|k,v|output_line "#{k} founded. " if v }

        #output_line ".............Checking Compilers End.........."

    end


end
