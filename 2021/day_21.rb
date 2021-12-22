#!/usr/bin/env ruby

def part1(p1, p2)
  die = Enumerator.new do |e|
    (1..100).cycle.each_with_index do |n, i|
      h = { roll: n, total_rolls: i }
      e.yield h
    end
  end

  state = {
    p1: { score: 0, position: p1 },
    p2: { score: 0, position: p2 },
    turn: Enumerator.new { |e| [:p1, :p2].cycle { |p| e.yield p } }
  }

  loop do
    player = state[:turn].next

    turn_score = 3.times.map { die.next[:roll] }.sum
    new_position = (state[player][:position] + turn_score) % 10

    state[player][:position] = new_position == 0 ? 10 : new_position
    state[player][:score] += state[player][:position]


    if state[player][:score] >= 1000
      other_player = state[:turn].next
      total_rolls = die.next[:total_rolls]

      return state[other_player][:score] * total_rolls
    end
  end
end

ROLLS = [1,2,3]
POSSIBLE_ROLL_TOTALS = ROLLS.product(ROLLS, ROLLS).map(&:sum).tally

MEMO = {}
def part2(p1_start, p2_start, p1_score = 0, p2_score = 0)
  key = [p1_start, p2_start, p1_score, p2_score]
  v = MEMO[key]
  return v unless v.nil?

  if p1_score >= 21
    return MEMO[key] = [1, 0]
  end

  if p2_score >= 21
    return MEMO[key] = [0, 1]
  end

  p1_wins_total = 0
  p2_wins_total = 0

  POSSIBLE_ROLL_TOTALS.each do |roll_total, possible_ways|
    new_pos = (p1_start + roll_total) % 10
    new_pos = new_pos == 0 ? 10 : new_pos

    new_score = p1_score + new_pos
    p2_wins, p1_wins = part2(p2_start, new_pos, p2_score, new_score)

    p1_wins_total += p1_wins * possible_ways
    p2_wins_total += p2_wins * possible_ways
  end

  return MEMO[key] = [p1_wins_total, p2_wins_total]
end

data = IO.readlines(ARGV[0], chomp: true)

p1_start = data[0].split(":")[1].to_i
p2_start = data[1].split(":")[1].to_i


puts "Part1: #{part1(p1_start, p2_start)}"
wins = part2(p1_start, p2_start)
puts "Part2: #{wins}: #{wins.max}"
