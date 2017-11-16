#!/usr/bin/env ruby
# -*- coding: binary -*-
# Code by Green-m
# Test  on ruby 2.3.3
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'skeleton'


class ExeMaker

    def initialize(code,compiler='cl')
        @code = code
        @compiler = compiler
    end


    def ramdom_compiler
        tempfile = tempname('c')
        tempobj = tempfile.chomp('c') + 'obj'
        File.open(tempfile, 'w') { |file| file.write(@code) }
        tempexe = tempname('exe')

        compilers_type = []
        Compilers::compilers_exist.each{|k,v|compilers_type << k.to_s if v == true}

        compiler_type = compilers_type.sample
        compiler = Compilers::getCompilerCommand(compiler_type,tempfile,tempexe)

        begin
        
            output_line "Compiler be used is  " + compiler_type

            output_status "Compiling Code To Exe.."
            if system(compiler)
                output_good "Generate at #{tempexe}"
            end

        rescue Exception => e
            output_bad e.message
            output_line e.backtrace.inspect
        ensure
            #output_status "Cleaning tempfile #{tempfile}"
            output_status "Cleaning tempfile.."
            File.delete(tempfile)
            File.delete(tempobj) if File.exist?(tempobj)
        end

    end
 
end
