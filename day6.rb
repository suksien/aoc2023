=begin

1. time allowed for each race and the best distance for that race
Time:      7  15   30
Distance:  9  40  200
-> 3 races
- time allowed per race is 7, 15, 30
- best distance per race is 9, 40, 200

2. to win: have to go further in each race than current record holder

3. holding down the button charges the boat; releasing the button allows the boat to move
  - boats move faster if button held longer, but at the expense of time. 
  - can only hold the button at the start of race

4. Starting speed is 0 
  - for each ms you hold the button, boat speed increases by 1 mm/ms
    - e.g. if hold for 3 ms, boat speed is 3 mm/ms after releasing, after which it travels at that constant speed

for race 1 where t=7, several options:
1) hold for 1 ms, boat speed is 1 ms -> travel for 6 s and reach 6 ms
2) hold 2 ms, boat speed 2 ms -> travel 7-2 = 5 and reach 10 mm
3) hold 3 ms, boat speed 3 ms -> travel 7-3 = 4 and reach 12 mm
4) hold 4 ms, boat speed 4 mm/ms -> travel 3 and reach 12 mm
5) hold 5 ms, boat speed 5 mm/ms -> travel 2 sec and reach 10 mm
6) hold 6 ms, boat speed 6 mm/ms -> travel 1 sec and reach 6 mm
7) hold 7ms, boat speed 7 mm/ms -> travel 0 sec and reach 0 mm
-> to win: options 2, 3, 4, 5 -> 4 ways to win
-> hold for 2 <= t <= 5

Output: Integer = product of the number of ways to win for all race
  - for test input, 4 * 8 * 9 = 288

Algo: 
1. Given a hold time and total race time, calculate the total distance traveled
  - travel time = total race time - hold Time
  - boat speed = hold Time
  - distance = boat speed * travel Time

2. Get the total number of distnaces that are larger than current record holder for each race. 

=end

def calc_distance(hold_time, race_time)
  travel_time = race_time - hold_time
  boat_speed = hold_time
  boat_speed * travel_time
end

def min_max_holdtime(time, distance)
  min_holdtime = (time - Math.sqrt(time ** 2 - 4 * distance)) / 2
  max_holdtime = (time + Math.sqrt(time ** 2 - 4 * distance)) / 2

  min_holdtime = min_holdtime.to_i == min_holdtime ? min_holdtime + 1 : min_holdtime.ceil
  max_holdtime = max_holdtime.to_i == max_holdtime ? max_holdtime - 1 : max_holdtime.floor
  return min_holdtime, max_holdtime
end

def part1(filename)
  lines_arr = File.read(filename).split("\n")
  tot_time = lines_arr[0].split("Time: ")[-1].split.map(&:to_i)
  record_dist = lines_arr[1].split("Distance: ")[-1].split.map(&:to_i)
  n_ways_to_win = []
  tot_time.each_index do |index|
    this_tot_time = tot_time[index]
    this_record = record_dist[index]
    n = 0
    (1..this_tot_time).each do |hold_time|
      dist = calc_distance(hold_time, this_tot_time)
      n +=1 if dist > this_record
    end
    n_ways_to_win << n
  end
  n_ways_to_win.reduce(:*)
end

p part1("test_input_day6.txt")
p part1("input_day6.txt") # 345015

def part2(filename)
  lines_arr = File.read(filename).split("\n")
  tot_time = lines_arr[0].split("Time: ")[-1].split.map(&:to_i)
  record_dist = lines_arr[1].split("Distance: ")[-1].split.map(&:to_i)
  n_ways_to_win = []
  tot_time.each_index do |index|
    this_tot_time = tot_time[index]
    this_record = record_dist[index]
    min_holdtime, max_holdtime = min_max_holdtime(this_tot_time, this_record)
    nways = (max_holdtime - min_holdtime + 1).to_i
    n_ways_to_win << nways
  end
  n_ways_to_win.reduce(:*)
end

p part2("test_input_day6_part2.txt") # 71503
p part2("input_day6_part2.txt") # 42588603