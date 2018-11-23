#!/usr/bin/env ruby

# usage: start-sampler.rb "-o dac -M0 -b16"
# note: list midi devices on pi w/ `amidi -l`
require 'highline'
require 'open3'

def process_running? pid
  Process.getpgid pid
  true
rescue Errno::ESRCH
  false
end

def translate_uk300_keypad keypad_string
  encoding_options = {
    :invalid           => :replace,
    :undef             => :replace,
    :replace           => '',
    :universal_newline => true
  }
  ascii_encoded_keypad_string = keypad_string.encode(Encoding.find('ASCII'), encoding_options)

  keypad_string.gsub(/\u001B/, '')
               .gsub(/\[/, '')
               .gsub('A', '8')
               .gsub('C', '6')
               .gsub('E', '5')
               .gsub('D', '4')
               .gsub('2~', '0')
               .gsub('B', '2')
               .gsub('5~', '9')
               .gsub('1~', '7')
               .gsub('6~', '3')
               .gsub('4~', '1')
end

pid = nil
im_done = nil
valid_set_id = true
cli = HighLine.new
csound_flags = '-o dac -Mhw:2,0,0 -b32' unless ARGV[0]

until im_done
  answer = cli.ask 'Set number:'

  if answer.include? "\u001B"
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
