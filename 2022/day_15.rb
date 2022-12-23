#!/usr/bin/env ruby

def manhattan(sensor) = (sensor.point.x - sensor.closest.x).abs + (sensor.point.y - sensor.closest.y).abs

# The idea is the find where each sensor range intersects the target.
# If it does, then we know the breadth where there are no beacons as the area
# extends outsides in a pyramid?.
# E.g if we are targeting 2. we can see that we have a breadth of 3 where
# there are no beacons based on this sensor. We know where the breadth starts
# based on the sensor (-1 for every row, i.e distance)
# 1      #
# 2     ###
# 3    #####
# 4   ###S###
def not_on_row(data, y_target)
  no_beacon_runs_on_target = []
  data.each do |sensor|
    distance = (y_target - sensor.point.y).abs
    if sensor.manhattan >= distance
      breadth_at_y = ((sensor.manhattan - distance) * 2) + 1
      start_x_at_y = sensor.point.x - (sensor.manhattan - distance)

      no_beacon_runs_on_target << [start_x_at_y, breadth_at_y]
    end
  end

  # Once we have the runs we can sort and merge them together as we could have
  # start: 3, breadth: 10 & start: 5, breadth: 10
  # which should can be simplified to start:3, breadth: 12
  # and further to start:3, end:15
  sorted_runs = no_beacon_runs_on_target.sort_by { |(start, _)| start }
  merged_runs = []

  current_run_start = nil
  current_run_end = nil
  sorted_runs.each do |(start, len)|
    if current_run_start.nil?
      current_run_start = start
    end

    if current_run_end.nil?
      current_run_end = (current_run_start + len) - 1
    end

    if start <= current_run_end && ((start + len - 1) > current_run_end)
      current_run_end = (start + len) - 1
    end

    if start > current_run_end
      merged_runs << [current_run_start, current_run_end]
      current_run_end = nil
      current_run_start = nil
    end
  end
  unless current_run_start.nil?
    merged_runs << [current_run_start, current_run_end]
  end

  merged_runs
end

def part1(data, y_target)
  v = not_on_row(data, y_target)
  v[0][1] - v[0][0]
end

# Had a look around when I saw this part as I thought brute force would be too
# slow but its < 1min so its fine
def part2(data, y_target)
  answer = nil
  0.upto(y_target) do |y|
    v = not_on_row(data, y)
    if v.length > 1
      answer = [v[1][0] - 1, y]
      break
    end
  end

  answer[0] * y_target + answer[1]
end


data = IO.readlines(ARGV[0], chomp: true)

PATTERN = /x=(-?\d+), y=(-?\d+):.*x=(-?\d+), y=(-?\d+)/
Point = Struct.new(:x, :y)
Sensor = Struct.new(:point, :closest, :manhattan)

data = data.map do |line|
  captures = line.match(PATTERN).captures
  s = Sensor.new(
    Point.new(captures[0].to_i, captures[1].to_i),
    Point.new(captures[2].to_i, captures[3].to_i),
    0
  )
  s.manhattan = manhattan(s)
  s
end

if ARGV[0].include?('example')
  p1_target = 10
  p2_target = 20
else
  p1_target = 2_000_000
  p2_target = 4_000_000
end

p part1(data, p1_target)
p part2(data, p2_target)
