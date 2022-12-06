#!/usr/bin/env ruby

def pos_of_first_uniq_run_length(data, len)
  data.map do |string|
    _, pos = string.chars.each_cons(len).each_with_index.find do |last_run, i|
      last_run.uniq.length == len
    end

    [string, pos + len]
  end
end

data = IO.readlines(ARGV[0], chomp: true)

pp pos_of_first_uniq_run_length(data, 4)
pp pos_of_first_uniq_run_length(data, 14)
