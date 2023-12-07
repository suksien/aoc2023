=begin
RULES:
1. Get a list of hands, goal is to order the "hands" based on the strength of each hand
2. A hand consists of any 5 cards from: A, K, Q, J, T, 9, 8, 7, 6, 5, 4, 3, or 2
  - Strength of hand follows the order above (i.e. A strongest and 2 weakest)
3. Every hand is exactly one type. From strongest to weakest:

  - five of a kind (AAAAA) -> 1 uniq cards
  - four of a kind (AA8AA) -> 2 uniq cards
  - full house (33322) -> 2 uniq cards
      - three cards have the same label, and the remaining two cards share a different label
  - three of a kind (TTT98) -> 3 uniq cards
      - three cards have the same label, and remaining 2 cards diff label than the rest
  - two pair (22334) -> 3 uniq cards
  - one pair (AA234) -> 4 uniq cards
      - remaining 3 cards different label from the pair and each other
  - high card (23456) -> 5 uniq cards

4. Hands are primarily ordered based on type
  - e.g. every full house is stronger than any three of a kind.

INPUT: "hand bid_amount"
  - if there are "n" hands, weakest hand has rank 1, strongest hand rank n
  - each hand wins an amount = bid * rank 
OUTPUT: total winnings

ALGO:
1. Given a hand, find its type
  - helper: five_of_kind?, four_of_kind? .. high_card?

2. Find all high card and sort bid amount [bid1, bid2.. bid_n]
  - sort all high card

3. Find all one pair card and sort them [bid1, bid2.. bid_n, bid_m, ...]
3. Find all two pair card and sort them 

=end

# 32T3K 765 -> 4 uniq -> one pair
# T55J5 684 -> 3 uniq -> 3 of a kind
# KK677 28 -> 3 uniq -> 2 pair
# KTJJT 220 -> 3 uniq -> 2 pair
# QQQJA 483 -> 3 uniq -> 3 of a kind

def parse(filename)
  hands, bids = [], []
  lines_arr = File.read(filename).split("\n")
  lines_arr.each do |line|
    hands << line.split[0]
    bids << line.split[1].to_i
  end
  return hands, bids
end

def sort_hand(hands_hsh, joker_rule=false, verbose=false)
  if joker_rule
    hands_lowest_to_highest = %w(A K Q T 9 8 7 6 5 4 3 2 J).reverse
  else
    hands_lowest_to_highest = %w(A K Q J T 9 8 7 6 5 4 3 2).reverse
  end

  score = Array(1..hands_lowest_to_highest.size)
  sorting_hsh = hands_lowest_to_highest.zip(score).to_h

  if verbose
    p "before sort"
    p hands_hsh
  end

  sorted_hands = hands_hsh.sort_by do |hand, bid|
    card = hand.chars
    [sorting_hsh[card[0]], sorting_hsh[card[1]], sorting_hsh[card[2]], sorting_hsh[card[3]], sorting_hsh[card[4]]]
  end
  
  if verbose
    p "after sort"
    p sorted_hands
  end

  sorted_hands.to_h.values
end

def categorize_hands_one_type(hands_hsh, nuniq)
  selected_hands = hands_hsh.select do |hand, bid|
    hand.chars.uniq.size == nuniq
  end

  if nuniq == 3
    three_kind, two_pair = selected_hands.partition do |hand, bid|
      uniq_chars = hand.chars.uniq
      uniq_chars.any? do |char|
        hand.count(char) == 3
      end
    end
    return three_kind.to_h, two_pair.to_h

  elsif nuniq == 2
    four_kind, full_house = selected_hands.partition do |hand, bid|
      uniq_chars = hand.chars.uniq
      uniq_chars.any? do |char|
        hand.count(char) == 4
      end
    end
    return four_kind.to_h, full_house.to_h

  else
    return selected_hands
  end
end

def order_bids(hands_type_hsh, joker_rule=false, verbose=false)
  hand_type_weakest_to_strongest = %w(five_kind four_kind full_house three_kind two_pair one_pair high_card).reverse
  ordered_bids = []
  hand_type_weakest_to_strongest.each do |str|
    if verbose
      puts "\n"
      puts str
    end
    ordered_bids << sort_hand(hands_type_hsh[str], joker_rule=joker_rule, verbose=verbose)
  end
  ordered_bids.flatten!
end

def calc_total_wins(ordered_bids)
  prod = 0
  ordered_bids.each_with_index do |bid, index|
    rank = index + 1
    prod += bid * rank
  end
  prod
end

def part1(filename)
  hands, bids = parse(filename)
  hands_hsh = hands.zip(bids).to_h

  five_kind = categorize_hands_one_type(hands_hsh, 1)
  four_kind, full_house = categorize_hands_one_type(hands_hsh, 2)
  three_kind, two_pair = categorize_hands_one_type(hands_hsh, 3)
  one_pair = categorize_hands_one_type(hands_hsh, 4)
  high_card = categorize_hands_one_type(hands_hsh, 5)

  hands_type_hsh = {"five_kind" => five_kind, "four_kind" => four_kind, "full_house" => full_house, 
                    "three_kind" => three_kind, "two_pair" => two_pair, "one_pair" => one_pair, 
                    "high_card" => high_card}

  ordered_bids = order_bids(hands_type_hsh, joker_rule=false, verbose=false)
  calc_total_wins(ordered_bids)
end

p part1("input_day7.txt") == 250453939

# high (5) -> one pair (4) -> two pair (3) -> three kind (3) -> full house (2) -> four kind (2) -> five kind (1)

=begin
QJJQ2 -> QQQQ2
-> uniq: Q, J, 2 -> nuniq = 3 (two pair)
-> J in uniq? 
  -> count of uniq: 2, 2, 1
  -> uniq char with highest count: Q (2)
  -> convert all J to Q: QQQQ2
    -> uniq: Q, 2 (four kind)

T55J5 -> T5555
-> uniq: T, 5, J -> nuniq = 3 (two pair)
-> J in uniq? 
  -> count of uniq: 2, 3, 1
  -> uniq char with highest count: 5 (3)
  -> convert all J to 5: T5555
    -> uniq: T, 5 (four kind)

T55JT -> T555T
-> uniq: T, 5, J -> nuniq = 3 (two pair)
-> J in uniq? 
  -> count of uniq: 2, 2, 1
  -> uniq char with highest count: T (2)
  -> convert all T to 5: T55TT
    -> uniq: T, 5 (full house)

 
=end

def replace_joker(current_hand)
  uniq_chars = current_hand.chars.uniq
  if uniq_chars.include?("J")
    uniq_chars.sort_by! do |char|
      current_hand.count(char)
    end
    if uniq_chars.size > 1
      replace_joker_with = uniq_chars[-1] == "J" ? uniq_chars[-2] : uniq_chars[-1]
      current_hand = current_hand.gsub("J", replace_joker_with)
    end
  end
  current_hand
end

def categorize_one_hand(current_hand)
  new_hand = replace_joker(current_hand)
  nuniq = new_hand.chars.uniq.size
  if nuniq == 1
    "five_kind"
  elsif nuniq == 2
    new_hand.chars.any? { |char| new_hand.count(char) == 4 } ? "four_kind" : "full_house"
  elsif nuniq == 3
    new_hand.chars.any? { |char| new_hand.count(char) == 3 } ? "three_kind" : "two_pair"
  elsif nuniq == 4
    "one_pair"
  else
    "high_card"
  end
end

def part2(filename)
  hands, bids = parse(filename)
  hands_hsh = hands.zip(bids).to_h
  hands_type_hsh = {"five_kind" => {}, "four_kind" => {}, "full_house" => {}, 
                    "three_kind" => {}, "two_pair" => {}, "one_pair" => {}, 
                    "high_card" => {}}

  hands_hsh.each do |hand, bid|
    type = categorize_one_hand(hand)
    hands_type_hsh[type][hand] = bid
  end

  ordered_bids = order_bids(hands_type_hsh, joker_rule=true, verbose=false)
  calc_total_wins(ordered_bids)
end

p part2("test_input_day7.txt") == 5905
p part2("input_day7.txt") == 248652697
