#!/usr/bin/env ruby
# -*- coding: binary -*-
# Code by Green-m
# Test  on ruby 2.3.3


$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'env'


Compilers::compilers_check

options = Starter::Console.new.start
#options[:debug] = true

if options[:file] 
    bin = File.binread(options[:file] )
    shellcode = Encoder::bin_to_cshellcode(bin)
else
    options[:shellcode] = MsfRunner.new(options).run
end

begin
	if options[:service]
		code = PayloadMaker.new(options).compile_service
	else
		code = PayloadMaker.new(options).compile_random
	end
	ExeMaker.new(code).ramdom_compiler
rescue Exception => e
  	output_bad e.message
  	output_line e.backtrace.inspect

end


