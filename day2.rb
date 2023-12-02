=begin

Input: input file
  - each line is a game
    - each set of cube separated by ";"

Output: integer
  - sum of all game IDs that are possible 

Rules:
- given 12 red cubes, 13 green cubes, and 14 blue cubes

Examples:
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
-> blue = 9, red = 5, green = 5 (possible)

Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
-> blue = 6, red = 1, green = 6 (possible)

Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
-> blue = 11, red = 20 (>12) (impossible)

Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
-> blue = 21 (> 14) (impossible)

Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green

Data:
- array of integers (game IDs that are possible)

Algo:
* each game is possible if sum of red in 3 sets <= 12 AND sum of green in 3 sets <= 13
 AND sum fo blue in 3 sets <= 14

1. Create constant vars `MAX_RED`, `MAX_GREEN`, `MAX_BLUE` = 12, 13, 14
2. Init empty array (`possible_game_id`)
3. Read input file and store each line as an array element
4. Loop each elem of array
  - get the game_id as the current index + 1
  - check if current game is possible (helper)
  - append game id to `possible_game_id` if it is a possible game

5. Sum all numbers in `possible_game_id`
6. Return the sum

Helper2: possible_game?(str) --incomplete algo
1. Split input string by ": " and get the last element
2. Split the string by "; " (`game_sets`)
3. init a hash
    - key (str): red, green, blue
    - value (int): 0, 0, 0
4. Loop each string of `game_sets`
  - split curretn string by ", "
  - loop each elem of the returned array
    - split curretn elem by whitespace
    - update the value of hash[key] where key is the last element of the split string
5. Return hsh

=end

MAX_RED, MAX_GREEN, MAX_BLUE = 12, 13, 14

def possible_game?(str)
  game_sets = str.split(": ")[-1].split("; ")
  game_sets.all? do |set|
    hsh = %w(red green blue).zip(Array.new(3, 0)).to_h
    arr = set.split(", ")
    arr.each do |cube|
      n, color = cube.split[0], cube.split[1]
      hsh[color] += n.to_i
    end
    hsh['red'] <= MAX_RED && hsh['blue'] <= MAX_BLUE && hsh['green'] <= MAX_GREEN
  end
end

def sum_game_id(filename)
  possible_game_id = []
  lines_arr = File.read(filename).split("\n")
  lines_arr.each_with_index do |line, index|
    game_id = index + 1
    possible_game_id << game_id if possible_game?(line)
  end
  possible_game_id.sum
end

p sum_game_id('input_day2.txt')

=begin
Algo:
* min set for each game is the max of each cube color

1. Init empty array for each for red, blue, green
2. For each set, append the number of red, blue, green cube to corr array
3. Return the maximum number for red array, blye array, and green array
=end

def get_minimum_set(str)
  game_sets = str.split(": ")[-1].split("; ")
  hsh = %w(red green blue).zip([[], [], []]).to_h
  game_sets.each do |set|
    arr = set.split(", ")
    arr.each do |cube|
      n, color = cube.split[0], cube.split[1]
      hsh[color] << n.to_i
    end
  end
  hsh.values.map { |arr| arr.max }
end

def power_minimum_set(filename)
  tot = 0
  lines_arr = File.read(filename).split("\n")
  lines_arr.each_with_index do |line, index|
    min_set = get_minimum_set(line)
    tot += min_set.reduce(:*)
  end
  tot
end

p power_minimum_set('input_day2.txt')