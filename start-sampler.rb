#!/usr/bin/env ruby

# usage: start-sampler.rb "-o dac -M0 -b16"
require 'highline'
require 'open3'

def process_running? pid
  Process.getpgid pid
  true
rescue Errno::ESRCH
  false
end

def translate_uk300_keypad keypad_string
  answer.sub('^[[', '')
        .sub('A', '8')
        .sub('C', '6')
        .sub('E', '5')
        .sub('F', '4')
        .sub('2', '0')
        .sub('B', '2')
        .sub('5', '9')
        .sub('1', '7')
        .sub('6', '3')
        .sub('4', '1')
end

pid = nil
im_done = nil
valid_set_id = true
cli = HighLine.new
csound_flags = '-o dac -Mhw:2,0,0 -b32' unless ARGV[0]

until im_done
  answer = cli.ask 'Set number:'

  if answer.start_with? '^[['
    answer = translate_uk300_keypad answer
  end

  Process.kill('SIGHUP', pid) if (pid && process_running?(pid))

  sleep 2

  case answer
  when '123'
    filename = 'midi-sampler-player.csd'
  when '456'
    filename = 'midi-sampler-player-kit-2.csd'
  when '000'
    im_done = true
    valid_set_id = false
    puts 'see ya'
  else
    puts 'not a valid set id'
    valid_set_id = false
  end

  if valid_set_id
    pi, po, pe, wait_thr = Open3.popen3 "csound #{filename} #{csound_flags}"
    pid = wait_thr[:pid]
    po.close
    puts pid
  end

  valid_set_id = true
end

Process.kill('SIGHUP', pid) if (pid && process_running?(pid))
