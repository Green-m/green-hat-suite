#!/usr/bin/env ruby
# -*- coding: binary -*-
# Code by Green-m
# Test  on ruby 2.3.3

$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'output'
require 'utils'

# return anti sandbox code 
module AntiSandBox


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