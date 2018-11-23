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

pid = nil
imdone = nil
cli = HighLine.new

until imdone
  answer = cli.ask 'Set number:'

  Process.kill('SIGHUP', pid) if (pid && process_running?(pid))

  sleep 2

  case answer
  when '123'
    filename = 'midi-sampler-player.csd'
  when '456'
    filename = 'midi-sampler-player-hh.csd'
  when '000'
    imdone = true
    puts 'see ya'
  end

  pi, po, pe, wait_thr = Open3.popen3 "csound #{filename} #{ARGV[0]}"
  pid = wait_thr[:pid]
  po.close
  puts pid
end

Process.kill('SIGHUP', pid) if (pid && process_running?(pid))
