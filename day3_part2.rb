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
  return [], [] if num_arr.empty?

  out_arr = []
  selected_ind_arr = []
  num_arr.each_with_index do |num, i|
    ind = ind_arr[i]
    ind_current = [ind-1, ind + num.size]
    if ind_current.any? { |index| str[index] =~ /[^0-9.]/ }
      out_arr << num.to_i
      selected_ind_arr << ind
    else 
      ind_prev_next = (ind-1 < 0) ? ind .. ind + num.size : ind-1 .. ind + num.size
      if arr.any? { |line| line[ind_prev_next].match?(/[^0-9.]/) }
        out_arr << num.to_i 
        selected_ind_arr << ind
      end
    end
  end
  return out_arr, selected_ind_arr
end

# Algo:
# 1. Get the part numbers and their row + col index as a hash
#   - key (int): row_index
#   - value (nested arr): [[part, col], [part, col]]

# 0: [[467, 0], [114, 5]]

def get_part_numbers(filename)
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

    num_arr, ind_arr = numbers_adj_to_symbols(this_line, arr)
    if !num_arr.empty?
      num_arr.each_with_index do |num, ind|
        parts_number << [num, index, ind_arr[ind]]
      end
    end
  end
  parts_number
end

=begin
Algo:
2. Get the row AND column index where a char is equal is "*" 
3. Define the index of the boundary around the gear 
  - [row-1, col-1], [row-1, col], [row-1, col+1]
  - [row, col-1], [row, col+1]
  - [row+1, col-1], [row+1, col], [row+1, col+1]

4. For each row index, get the value of the hash
  - loop each subarr
    - check if the col index of the part number overlaps with any of [col-1, col, col+1]
      - if yes, select the the part number and store in output array

2. If the array has 2 elems, multiple the 2 numbers together
3. Store the product in `sum_arr`
4. Return the sum of all numbers in `sum_arr`

=end

def find_adjacent_part_numbers(boundary, parts_number)
  out_arr = []
  boundary.each do |one_side|
    row, col = one_side
    parts_number.each do |subarr|
      pn, val = subarr[0], subarr[1..-1]
      col_ind = Array(val[1]..val[1] + pn.digits.size - 1)
      out_arr << pn if row == val[0] && col_ind.include?(col) && !out_arr.include?(pn)
    end
  end
  out_arr
end

def gear_ratio(filename)
  lines_arr = File.read(filename).split("\n")
  parts_number = get_part_numbers(filename)
  sum_arr = []

  lines_arr.each_with_index do |line, row_index|
    line.chars.each_with_index do |char, col_index|
      if char == '*'
        boundary = [[row_index, col_index - 1], [row_index, col_index + 1]]
        if row_index == 0
          boundary << [row_index + 1, col_index - 1] << [row_index + 1, col_index] << [row_index + 1, col_index + 1]
        elsif row_index == lines_arr.size - 1
          boundary << [row_index - 1, col_index - 1] << [row_index - 1, col_index] << [row_index - 1, col_index + 1]
        else
          boundary << [row_index + 1, col_index - 1] << [row_index + 1, col_index] << [row_index + 1, col_index + 1]
          boundary << [row_index - 1, col_index - 1] << [row_index - 1, col_index] << [row_index - 1, col_index + 1]
        end

        found_parts_number = find_adjacent_part_numbers(boundary, parts_number)
        if found_parts_number.size == 2
          sum_arr << found_parts_number[0] * found_parts_number[1] 
        end
      end
    end
  end
  sum_arr.sum
end

p gear_ratio('test_input_day3.txt')
p gear_ratio('input_day3.txt')