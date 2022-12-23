#!/usr/bin/env ruby

# Sample input
# Parsing this seems more difficult than hardcoding it
# Monkey 0:
#   Starting items: 79, 98
#   Operation: new = old * 19
#   Test: divisible by 23
#     If true: throw to monkey 2
#     If false: throw to monkey 3

# Monkey 1:
#   Starting items: 54, 65, 75, 74
#   Operation: new = old + 6
#   Test: divisible by 19
#     If true: throw to monkey 2
#     If false: throw to monkey 0

# Monkey 2:
#   Starting items: 79, 60, 97
#   Operation: new = old * old
#   Test: divisible by 13
#     If true: throw to monkey 1
#     If false: throw to monkey 3

# Monkey 3:
#   Starting items: 74
#   Operation: new = old + 3
#   Test: divisible by 17
#     If true: throw to monkey 0
#     If false: throw to monkey 1
sample = {
  0 => { items: [79, 98], operation: ->(o) { o * 19 }, div: 23, t: 2, f: 3, inspected: 0 },
  1 => { items: [54, 65, 75, 74], operation: ->(o) { o + 6 }, div: 19, t: 2, f: 0, inspected: 0 },
  2 => { items: [79, 60, 97], operation: ->(o) { o * o }, div: 13, t: 1, f: 3, inspected: 0},
  3 => { items: [74], operation: ->(o) { o + 3 }, div: 17, t: 0, f: 1, inspected: 0 },
}
# Monkey 0:
#   Starting items: 91, 54, 70, 61, 64, 64, 60, 85
#   Operation: new = old * 13
#   Test: divisible by 2
#     If true: throw to monkey 5
#     If false: throw to monkey 2

# Monkey 1:
#   Starting items: 82
#   Operation: new = old + 7
#   Test: divisible by 13
#     If true: throw to monkey 4
#     If false: throw to monkey 3

# Monkey 2:
#   Starting items: 84, 93, 70
#   Operation: new = old + 2
#   Test: divisible by 5
#     If true: throw to monkey 5
#     If false: throw to monkey 1

# Monkey 3:
#   Starting items: 78, 56, 85, 93
#   Operation: new = old * 2
#   Test: divisible by 3
#     If true: throw to monkey 6
#     If false: throw to monkey 7

# Monkey 4:
#   Starting items: 64, 57, 81, 95, 52, 71, 58
#   Operation: new = old * old
#   Test: divisible by 11
#     If true: throw to monkey 7
#     If false: throw to monkey 3

# Monkey 5:
#   Starting items: 58, 71, 96, 58, 68, 90
#   Operation: new = old + 6
#   Test: divisible by 17
#     If true: throw to monkey 4
#     If false: throw to monkey 1

# Monkey 6:
#   Starting items: 56, 99, 89, 97, 81
#   Operation: new = old + 1
#   Test: divisible by 7
#     If true: throw to monkey 0
#     If false: throw to monkey 2

# Monkey 7:
#   Starting items: 68, 72
#   Operation: new = old + 8
#   Test: divisible by 19
#     If true: throw to monkey 6
#     If false: throw to monkey 0
real = {
    0 => { items: [91, 54, 70, 61, 64, 64, 60, 85], operation: ->(o) { o * 13 }, div: 2, t: 5, f: 2, inspected: 0 },
    1 => { items: [82], operation: ->(o) { o + 7 }, div: 13, t: 4, f: 3, inspected: 0 },
    2 => { items: [84, 93, 70], operation: ->(o) { o + 2 }, div: 5, t: 5, f: 1, inspected: 0 },
    3 => { items: [78, 56, 85, 93], operation: ->(o) { o * 2 }, div: 3, t: 6, f: 7, inspected: 0 },
    4 => { items: [64, 57, 81, 95, 52, 71, 58], operation: ->(o) { o * o }, div: 11, t: 7, f: 3, inspected: 0 },
    5 => { items: [58, 71, 96, 58, 68, 90], operation: ->(o) { o + 6 }, div: 17, t: 4, f: 1, inspected: 0 },
    6 => { items: [56, 99, 89, 97, 81], operation: ->(o) { o + 1 }, div: 7, t: 0, f: 2, inspected: 0 },
    7 => { items: [68, 72], operation: ->(o) { o + 8 }, div: 19, t: 6, f: 0, inspected: 0 },
}

def iterate(monkies, rounds, worry_operation)
  monkies.keys.sort.cycle(rounds) do |num|
    while monkies[num][:items].any?
      monkies[num][:inspected] += 1

      w = monkies[num][:items].shift
      w = monkies[num][:operation].call(w)
      w = worry_operation.call(w)
      new_monkey = w % monkies[num][:div] == 0 ? monkies[num][:t] : monkies[num][:f]
      monkies[new_monkey][:items] << w
    end
  end

  monkies.map { |(k, v)| v[:inspected] }.sort.last(2).reduce(:*)
end

def part1(monkies)
  iterate(monkies, 20, ->(w) { (w / 3.0).floor })
end

def part2(monkies)
  # Did not figure this out myself. Knew where the problem was but just checked the megathread
  div_all = monkies.map { |(k, v)| v[:div] }.reduce(1, :*)
  iterate(monkies, 10_000, ->(w) { w % div_all })
end

if ARGV[0] == 'sample'
  data = sample
else
  data = real
end

if ARGV[1] == '1'
  p part1(data)
else
  p part2(data)
end
