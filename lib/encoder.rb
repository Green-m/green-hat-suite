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
end
