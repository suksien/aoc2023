=begin
Input:
  - each line is the history of a single value
  - numbers can be positive, negative, and zero

Output: SUM of all predicted values for all lines

Rules:
- make a new sequence of the (absolute) differences, and keep repeating until all the numbers in 
the sequence is all zeros
- can only extrapolate once reach an all-zero sequence

Examples:
1  3  6  10 15 21    (28)               
  2  3  4  5  6    7
    1 1   1  1   1
     0  0   0  0
     
return 18 + 28 + 68 = 114

Algo:
1. Get the new value for each line (helper)
  - store new value in array (`predictions`)
2. Return the sum of all numbers in `predictions`

Helper: get_prediction(str)
0. Init empty arr (`last_nums`)
1. Convert input str to array of integers (`nums`)
  - append last number to `last_nums`
[21]

2. While `nums` is not all zeros
  - Implement np.diff method for `nums` (`diff`)
    - loop from 0 to nums.size - 2
      - get current and next elem
      - get the diff  
  - reassign `nums` to `diff`

  - append the last number from `nums` to `last_nums`
[21, 6, 1]

3. Sum all `last_nums` and return it

=end

def diff(arr)
  (0..arr.size-2).map do |index|
    this_elem, next_elem = arr[index], arr[index+1]
    next_elem - this_elem
  end
end

def get_prediction(str, back_in_time=false)

  indx = (back_in_time ? 0 : -1)

  store_nums = []
  nums = str.split.map(&:to_i)
  store_nums << nums[indx]
  
  until nums.all? { |num| num == 0 }
    nums = diff(nums)
    store_nums << nums[indx]
  end

  if back_in_time
    reversed_arr = store_nums.reverse
    reversed_arr.reduce { |diff, n| n - diff }
  else
    store_nums.sum
  end
end

# part 1: 40 min
def function(filename, back_in_time)
  lines_arr = File.read(filename).split("\n")
  predictions = lines_arr.map do |line|
    get_prediction(line, back_in_time=back_in_time)
  end
  predictions.sum
end

p function('test_input_day9.txt', false)
p function('input_day9.txt', false) # 1904165718

=begin
0  1  3  6  10 15 21    (28)               
  1  2  3  4  5  6    7
   1  1 1   1  1   1
     0  0   0  0
=end

# part 2: 30 min
p function('test_input_day9.txt', back_in_time=true)
p function('input_day9.txt', back_in_time=true) # 964

# TODO: implement recursive solution...? Apparently this is a way
