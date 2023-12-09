#!/usr/bin/env ruby


def part1(data)
  cards_to_values = %w[A K Q J T 9 8 7 6 5 4 3 2].reverse.each.with_index(2).map { |c, i| [c, i] }.to_h

  x = data.group_by do |h|
    h[:hand_values] = h[:orig_hand].chars.map(&cards_to_values.to_proc)

    case h[:hand_groups].values.map(&:size).sort
    when [5] then :five_of_a_kind
    when [1, 4] then :four_of_a_kind
    when [2, 3] then :full_house
    when [1, 1, 3] then :three_of_a_kind
    when [1, 2, 2] then :two_pair
    when [1, 1, 1, 2] then :one_pair
    when [1, 1, 1, 1, 1] then :high_card
    end
  end

  x = x.transform_values do |v|
    # Sorts each group by their cards value and turns them into a hash of
    # { 1 => Hand }
    v.sort do |a, b|
      a = a[:hand_values]
      b = b[:hand_values]

      a <=> b
    end.each.with_index(1) { |h, i| h[:rank] = i }
  end

  cards_below_ranks = x.transform_values(&:size)
  cards_below_ranks.default_proc = ->(h, k) { h[k] = 0 }
  hand_types = [:five_of_a_kind, :four_of_a_kind, :full_house, :three_of_a_kind, :two_pair, :one_pair, :high_card]
  hand_types.each.with_index(1) do |hand_type, index|
    cards_below_ranks[hand_type] = cards_below_ranks.values_at(*hand_types[index..]).compact.reduce(:+)
  end

  winnings = 0

  x.each_pair do |hand_type, hands|
    hands.each do |h|
      h[:rank] += cards_below_ranks[hand_type] if hand_type != :high_card
      puts "#{h[:orig_hand]} -> #{hand_type} -> #{h[:rank]}"
      winnings += h[:bid] * h[:rank]
    end
  end

  winnings
end

def part2(data)
  cards_to_values = %w[A K Q T 9 8 7 6 5 4 3 2 J].reverse.each.with_index(2).map { |c, i| [c, i] }.to_h

  x = data.group_by do |h|
    h[:hand_values] = h[:orig_hand].chars.map(&cards_to_values.to_proc)
    joker_count = h[:hand_values].count(2)

    case [h[:hand_groups].values.map(&:size).sort, joker_count]
    in [[5], _] | [[1, 4], 1|4] | [[2, 3], 2|3]
      :five_of_a_kind
    in [[1, 4], 0] | [[1, 1, 3], 1|3] | [[1, 2, 2], 2]
      :four_of_a_kind
    in [[2, 3], 0] | [[1, 2, 2], 1]
      :full_house
    in [[1, 1, 3], 0] | [[1, 1, 1, 2], 1|2]
      :three_of_a_kind
    in [[1, 2, 2], 0]
      :two_pair
    in [[1, 1, 1, 2], 0] | [[1, 1, 1, 1, 1], 1]
      :one_pair
    in [[1, 1, 1, 1, 1], 0]
      :high_card
    end
  end

  x = x.transform_values do |v|
    # Sorts each group by their cards value and turns them into a hash of
    # { 1 => Hand }
    v.sort do |a, b|
      a = a[:hand_values]
      b = b[:hand_values]

      a <=> b
    end.each.with_index(1) { |h, i| h[:rank] = i }
  end

  cards_below_ranks = x.transform_values(&:size)
  cards_below_ranks.default_proc = ->(h, k) { h[k] = 0 }
  hand_types = [:five_of_a_kind, :four_of_a_kind, :full_house, :three_of_a_kind, :two_pair, :one_pair, :high_card]
  hand_types.each.with_index(1) do |hand_type, index|
    cards_below_ranks[hand_type] = cards_below_ranks.values_at(*hand_types[index..]).compact.reduce(:+)
  end
  puts cards_below_ranks

  winnings = 0

  x.each_pair do |hand_type, hands|
    hands.each do |h|
      h[:rank] += cards_below_ranks[hand_type] if hand_type != :high_card
      puts "#{h[:orig_hand]} -> #{hand_type} -> #{h[:rank]}"
      winnings += h[:bid] * h[:rank]
    end
  end

  winnings
end

data = IO.readlines(ARGV[0], chomp: true).map do |l|
  hand, bid = l.split

  {
    orig_hand: hand,
    hand_groups: hand.chars.group_by(&:itself),
    bid: bid.to_i,
    rank: nil,
  }
end


#p part1(data)
p part2(data)
