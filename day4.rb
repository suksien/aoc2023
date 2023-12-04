=begin
Input:
  - each line is a card
  - on each line, winning numbers and numbers you have, separated by a vertical bar
  
Output: Integer
  - total points 

Rules:
- Figure out which of the numbers you have appear in the winning numbers
- The first match makes the card worth one point and each match after the first doubles the point value of that card.

Examples:
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
-> win card: 83, 86, 17, 48
-> points: 1 * 2 * 2 * 2 = 8

Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
-> win cards: 61, 32
-> points: 1 * 2 = 2

Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
-> win cards: 21, 1
-> points = 1 * 2 = 2

Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11

- total points = 8 + 2 + 2 + 1 = 13

Data:
- array of integers

Algo:
0. Init empty array `card_points`
1. Loop each line
  - get the array of winning numbers (`winning_num`)
  - get the array of numbers you have (`my_num`)
  
  - from `my_num`, select the numbers that are found in `winning_num`
    - init a var `card_value` to 0
    - loop through each num with index (offset by 1)
      - if index is 1, reassign `card_value` to 1
      - if index is > 1, multiple `card_value` by 2
    - append `card_value` to `card_points`
2. Sum all numbers in `card_points` adn return it. 
=end

def get_numbers(str)
  win_num, num = str.split(': ')[-1].split(" | ")
  win_num = win_num.split.map(&:to_i)
  num = num.split.map(&:to_i)
  return win_num, num
end

def compute_card_points(filename)
  lines_arr = File.read(filename).split("\n")
  card_points = []
  lines_arr.each do |line|
    winning_num, my_num = get_numbers(line)
    # my_num_winning = my_num.select do |num|
    #   winning_num.include?(num)
    # end
    my_num_winning = winning_num & my_num
    card_value = 0
    my_num_winning.each.with_index(1) do |num, index|
      card_value = (index == 1 ? 1 : card_value * 2) 
    end
    card_points << card_value
  end
  card_points.sum
end

p compute_card_points('input_day4.txt') # 32001

=begin
Data: 
- hsh 
  - key (int): card number
  - value (int): total count of that card number

{1: 1, 2: 1, 3: 1, 4:1, 5:1 , 6: 1}

Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
-> 4 match -> card 2, 3, 4, 5
-> {1: 1, 2: 2, 3: 2, 4: 2, 5: 2 , 6: 1}

Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
-> 2 match -> card 3, 4
-> {1: 1, 2: 2, 3: 4, 4: 4, 5: 2 , 6: 1}

Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
-> 2 match -> card 4, 5
-> {1: 1, 2: 2, 3: 4, 4: 8, 5: 6 , 6: 1}

Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
-> 1 match -> card 5
-> {1: 1, 2: 2, 3: 4, 4: 8, 5: 14 , 6: 1}

Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11

-> final hsh = {1: 1, 2: 2, 3: 4, 4: 8, 5: 14 , 6: 1}
- 1 + 2 + 4 + 8 + 14 + 1 = 30

Algo:
0. Init `card_hsh`
 -  keys (int): 1 to total number of lines
 -  values (int): 1
 
1. Loop each line with index (offset by 1)
  - get the array of winning numbers (`winning_num`)
  - get the array of numbers you have (`my_num`)
  - from `my_num`, get count of numbers that are found in `winning_num`
  - init `copies_arr` to be an array from current index + 1 up to current_index + total count
    [2, 3, 4, 5]
  - update hash with `copies_arr` (helper)
2. Get all the values of hash and add up the numbers
3. Return the sum
 
Helper: update_hsh(int, hsh, arr)
1. Get the count of card of current card (`current_card_count`)
2. Loop each elem of `arr`
  - increase the value of key by `current_card_count`
=end

def update_hsh(current_card, card_hsh, card_copies)
  current_card_count = card_hsh[current_card]
  card_copies.each do |card|
    card_hsh[card] += current_card_count
  end
end

def compute_total_scratchcards(filename)
  lines_arr = File.read(filename).split("\n")
  card_hsh = Array(1..lines_arr.size).zip(Array.new(lines_arr.size, 1)).to_h
  
  lines_arr.each.with_index(1) do |line, card_num|
    winning_num, my_num = get_numbers(line)
    #n_matches = my_num.count { |num| winning_num.include?(num) }
    n_matches = (winning_num & my_num).size
    card_copies = Array(card_num+1 .. card_num + n_matches)
    update_hsh(card_num, card_hsh, card_copies)
  end

  card_hsh.values.sum
end


p compute_total_scratchcards('input_day4.txt') # 5037841