=begin
Input: engine schematic
  - 140 lines
  - each line 140 chars long

Output: integer
  - sum of part numbers

Rules:
- any number next to a symbol (even diagonally) is a part number
  - periods are not considered symbols

Examples:

467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
-> not part numbers: 114, 58
-> sum of all part numbers 4361

Data:
- strings, integers
- array of integers

Algo:
- for each number, check if it is adjacent to any symbol
- for each symbol, get the adjacent numbers

0. Init empty array (`part_numbers`)
1. Loop each line of file
- loop each number
  - search for symbol around the number (helper)
  - if there is adjacent symbol, convert number to integer, store to `part_numbers`
2. Sum all numbers of `part_numbers` and return the sum

Helper: numbers_adj_to_symbols(str, arr)
0. Init empty array
1. get an array of all numbers in input string (`num_arr`)
2. return empty array if `num_arr` is empty

3. Else, loop each number in `num_arr`
  - find the index of the number in input string
  - define an array of indices indicating locations to search for symbols on current line
    - index_current = [index-1, index + lenght of number ]
    - loop each elem of `index_current`
      - if char on current line is NOT number and NOT period
        - convert number to integer and store in array

  - define an array of indices indicating locations to search for symbols on previous and next line
    - index_prev_next = [index-1 .. index + length of number]
  
3. Return array

=end

def get_number_and_index(str)
  num_arr = []
  ind_arr = []

  num = ''
  tmp_arr = []
  str.chars.each_with_index do |char, index|
    if char =~ /[0-9]/
      num += char
      tmp_arr << index
      if index == str.size - 1
        num_arr << num
        ind_arr << tmp_arr[0]
      end
    else
      if !num.empty?
        num_arr << num
        ind_arr << tmp_arr[0]
        num = ''
        tmp_arr = []
      end
    end
  end
  return num_arr, ind_arr
end

def numbers_adj_to_symbols(str, arr)
  num_arr, ind_arr = get_number_and_index(str)
  return [] if num_arr.empty?

  out_arr = []
  num_arr.each_with_index do |num, i|
    ind = ind_arr[i]
    ind_current = [ind-1, ind + num.size]
    if ind_current.any? { |index| str[index] =~ /[^0-9.]/ }
      out_arr << num.to_i
    else 
      ind_prev_next = (ind-1 < 0) ? ind .. ind + num.size : ind-1 .. ind + num.size
      out_arr << num.to_i  if arr.any? { |line| line[ind_prev_next].match?(/[^0-9.]/) }
    end
  end
  out_arr
end

def sum_part_numbers(filename)
  lines_arr = File.read(filename).split("\n")
  parts_number = []

  lines_arr.each_index do |index|
    this_line = lines_arr[index]
    if index == 0
      arr = [lines_arr[index+1]]
    elsif index == lines_arr.size - 1
      arr = [lines_arr[index-1]]
    else
      arr = [lines_arr[index-1], lines_arr[index+1]]
    end
    parts_number << numbers_adj_to_symbols(this_line, arr)
  end
  parts_number.flatten.sum
end

p sum_part_numbers("test_input_day3.txt") == 4361
p sum_part_numbers("input_day3.txt")
