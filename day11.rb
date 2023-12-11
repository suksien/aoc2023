=begin
Input:
  - empty space: .
  - galaxies: #
  - (N X N) grid

Sum of lengths of shortest part between every pair of galaxies
- can only step up, down, left, or right exactly one "." or "#" at a time
- the shortest path between a pair can cross another galaxy

Rules:
- only some space expands
  - i.e. rows or columns that have NO galaxies is 2x as big
    - one row -> 2 rows (add down?)
    - one col -> 2 cols (add right?)
- count each pair only once; order within pair doesn't matter

1, 2, 3..9
-> 12, 13, 14, 15, 16, 17, 18, 19 (8)
-> 23, 24, 25, 26, 27, 28, 29 (7)
-> 34, 35, 36, 37, 38, 39 (6)
-> 45, 46, 47, 48, 49 (5)
-> 56, 57, 58, 59 (4)
-> 67, 68, 69 (3)
-> 78, 79 (2)
-> 89 (1)

Algo:
1. Expand the space
  - find rows with empty space
  - find cols with empty space

2. Create a hash of galaxies
  - key (int): 1, 2, 3...
  - value (array): [row, col]

=end


def expand_space(arr, rate=2)
  new_arr = []
  arr.each do |line|
    if line.all? { |char| char == '.' }
      rate.times { |_| new_arr << line }
    else
      new_arr << line
    end
  end
  new_arr
end

def number_galaxies(arr)
  nstart = 1
  arr.map! do |line|
    line.each_index do |index|
      char = line[index]
      if char == "#"
        line[index] = nstart.to_s 
        nstart += 1
      end
    end
  end
end

def create_galaxy_catalog(arr)
  hsh = {}
  nstart = 1
  arr.each_index do |row|
    line = arr[row]
    line.each_index do |col|
      char = line[col]
      if char == "#"
        hsh[nstart] = [row, col] 
        nstart += 1
      end
    end
  end
  hsh
end

def parse(filename)
  lines_arr = File.read(filename).split("\n")
  lines_arr.map(&:chars)
end

def part1(filename)
  lines_arr = parse(filename)
  rate = 2
  expanded_space = expand_space(lines_arr, rate)
  expanded_space = expand_space(expanded_space.transpose, rate).transpose
  gal_hsh = create_galaxy_catalog(expanded_space)

  gal_ids = gal_hsh.keys
  p "There are #{gal_ids.size} galaxies"
  
  distances = gal_ids.each_index.map do |index|
    this_gal_id = gal_ids[index]
    slice = gal_ids[index+1..-1]
    slice.map do |pair_id|
      gal1 = gal_hsh[this_gal_id]
      gal2 = gal_hsh[pair_id]
      dist = (gal1[0] - gal2[0]).abs + (gal1[1] - gal2[1]).abs
    end
  end

  sum_distances = distances.flatten.sum
  p sum_distances
end

part1('test_input_day11.txt') # 374
part1('input_day11.txt') # 9639160

=begin

...#...... -> [0, 3] -> [0, 3+1] = [0, 4]
.......#.. -> [1, 7] -> [1, 7+2] = [1, 9]
#......... -> [2, 0] -> [2, 0]
.......... 
......#... -> [4, 6] -> [4+1, 6+2] = [5, 8]
.#........ -> [5, 1] -> [5+1, 1] = [6, 1]
.........# -> [6, 9] -> [6+1, 9+3] = [7, 12]
..........
.......#.. -> [8, 7] -> [8+2, 7+2] = [10, 9]
#...#..... -> [9, 0], [9, 4] -> [9+2, 0], [9+2, 4+1] = [11, 0], [11, 5]

empty_space -. [3, 7], [2, 5, 8]

=end

def get_empty_space(lines_arr)
  empty_row_index = lines_arr.each_index.select do |index|
    line = lines_arr[index]
    line.all? { |char| char == '.' }
  end

  empty_col_index = lines_arr.transpose.each_index.select do |index|
    line = lines_arr.transpose[index]
    line.all? { |char| char == '.' }
  end

  [empty_row_index, empty_col_index]
end

def transform_galaxy_coord(gal_hsh, empty_row_index, empty_col_index, rate)
  gal_hsh.each_key do |gal|
    row, col = gal_hsh[gal]
    nrow_to_add = empty_row_index.count { |indx| row > indx }
    ncol_to_add = empty_col_index.count { |indx| col > indx }
    gal_hsh[gal] = [row + nrow_to_add * (rate-1), col + ncol_to_add * (rate-1)]
  end
end

def part2(filename, rate)
  lines_arr = parse(filename)
  gal_hsh = create_galaxy_catalog(lines_arr)
  empty_row_index, empty_col_index = get_empty_space(lines_arr)

  transform_galaxy_coord(gal_hsh, empty_row_index, empty_col_index, rate)

  gal_ids = gal_hsh.keys
  distances = gal_ids.each_index.map do |index|
    this_gal_id = gal_ids[index]
    slice = gal_ids[index+1..-1]
    slice.map do |pair_id|
      gal1 = gal_hsh[this_gal_id]
      gal2 = gal_hsh[pair_id]
      dist = (gal1[0] - gal2[0]).abs + (gal1[1] - gal2[1]).abs
    end
  end

  sum_distances = distances.flatten.sum
  p sum_distances
  
end

part2('input_day11.txt', 2)
part2('test_input_day11.txt', 100) # 8410
part2('input_day11.txt', 1_000_000) # 752936133304