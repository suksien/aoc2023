=begin

PROBLEM: figure out where the mirrors are

Input:
- patterns of ash (.) and rocks (#)
- one block one pattern

Output: number
  - (ncol to the LEFT of all vertical lines) + 100 * (nrow to the TOP to all horizontal lines)
  - ncol and nrow including non-reflected lines

Rules:
- for each pattern, find the line of reflection (either horizontal or vertical)
  - one line of reflection per pattern?
  
- ONE MIRROR PER PATTERN

EXAMPLES:

#.##..##.

..#.##.#.
##......#
---------
##......#
..#.##.#.

..##..##.
#.#.##.#. (2 reflections)

# .##.|.##.
. .#.#|#.#.
# #...|...#
# #...|...#
. .#.#|#.#.
. .##.|.##.
# .#.#|#.#. (4 reflections; choose this)
#...## ..#


#...##..#

#....#..#
..##..###
#####.##.
------------
#####.##.
..##..###
#....#..# (3 reflections)

5 + 4*100 = 405

ALGO:
1. Extract all pattern blocks
[[#.##..##.], 
 [..#.##.#.], 
 [##......#],

 [##......#] 
 [..#.##.#.], 
 [..##..##.], 
 [#.#.##.#.]]

2. For each pattern, find if there is a horizontal reflection line
  - mirror = {}

  - loop from index=1 to last index

    - top_half = slice from index=0 to current index - 1
    - bottom_half = slice from current index to end of array
    - n_elem = min number of elems in top_half vs bottom_half

    - n_reflect = 0
    - loop for n_elem time
      - top_half[-1] vs. bottom_half[0], then n_reflect += 1
        top_half[-2] vs. bottom_half[1], ...
      - break if encounter first non-matching
    
    - if n_reflect > 0
      - set key=current index, value = n_reflect

    - return `mirror`

=end

def find_horizontal_mirror(pattern)
  mirror = {}
  pattern = pattern.map(&:join)

  (1..pattern.size-1).each do |index|
    top_half = pattern[0..index-1]
    bottom_half = pattern[index..-1]

    n_elem = [top_half.size, bottom_half.size].min
    top_half.reverse!
    if (0..n_elem-1).all? { |i| top_half[i] == bottom_half[i] }
      mirror[index] = n_elem
    end 
  end
  mirror
end

def pick_perfect_mirror(row_mirrors, col_mirrors)
  
  best_row_mirror = row_mirrors.key(row_mirrors.values.max)
  best_col_mirror = col_mirrors.key(col_mirrors.values.max)

  if best_col_mirror.nil? 
    return ["row", best_row_mirror]
  elsif best_row_mirror.nil? 
    return ["col", best_col_mirror]
  else
    if row_mirrors[best_row_mirror] > col_mirrors[best_col_mirror]
      ["row", best_row_mirror]
    else
      ["col", best_col_mirror]
    end
  end
end

def parse(filename)
  patterns =  File.read(filename).split("\n\n")
  patterns.map do |pattern|
    pattern.split("\n").map(&:chars)
  end
end

def part1(filename)
  patterns =  parse(filename)
  ncol, nrow = 0, 0

  patterns.each do |pattern|
    row_mirrors = find_horizontal_mirror(pattern)
    col_mirrors = find_horizontal_mirror(pattern.transpose)
    direction, mirror_index = pick_perfect_mirror(row_mirrors, col_mirrors)

    ncol += mirror_index if direction == "col"
    nrow += mirror_index if direction == "row"
  end
  p (ncol + nrow * 100)
end

part1("test_input_day13.txt") # 405
part1("input_day13.txt") # 29165

=begin
ALGO:

one line mismatch
one spot mismatch
1. Find smudge
2. Fix smudge
3. Find potential mirrors

brute force: find potential mirrors after inverting every char of pattern
=end

def reshape(arr, ncol)
  arr.each_slice(ncol).to_a
end

def invert_one_char(pattern, irow_char, icol_char)
  pattern = pattern.map do |row|
    row.map do |char|
      char.dup
    end
  end

  char = pattern[irow_char][icol_char]
  pattern[irow_char][icol_char] = (char == '.' ? '#' : '.')
  pattern
end

def find_horizontal_mirror_smudge(pattern, irow_smudge)
  mirror = {}
  pattern = pattern.map(&:join)

  (1..pattern.size-1).each do |index|
    top_half = pattern[0..index-1]
    bottom_half = pattern[index..-1]

    n_elem = [top_half.size, bottom_half.size].min
    top_half.reverse!
    if (0..n_elem-1).all? { |i| top_half[i] == bottom_half[i] }
      first_reflected_row_index = index - n_elem
      last_reflected_row_index = index + n_elem - 1
      #p "range", [first_reflected_row_index, last_reflected_row_index, irow_smudge]
      mirror[index] = n_elem if (first_reflected_row_index..last_reflected_row_index).include?(irow_smudge)
    end 
  end
  mirror
end

def part2(filename)
  patterns =  parse(filename)
  ncol, nrow = 0, 0

  patterns.each do |pattern|
    all_mirrors = []
    nrow_pattern, ncol_pattern = pattern.size, pattern[0].size

    nrow_pattern.times do |irow_smudge|
      ncol_pattern.times do |icol_smudge|
        new_pattern = invert_one_char(pattern, irow_smudge, icol_smudge)
        row_mirrors = find_horizontal_mirror_smudge(new_pattern, irow_smudge)
        col_mirrors = find_horizontal_mirror_smudge(new_pattern.transpose, icol_smudge)
        direction, mirror_index = pick_perfect_mirror(row_mirrors, col_mirrors)
        all_mirrors << [direction, mirror_index] unless mirror_index.nil? || all_mirrors.include?([direction, mirror_index])
      end
    end
    all_mirrors = all_mirrors.flatten
    direction, mirror_index = all_mirrors[0], all_mirrors[1]
    ncol += mirror_index if direction == "col"
    nrow += mirror_index if direction == "row"
  end
  p (ncol + nrow * 100)
end

part2("test_input_day13.txt") # 400
part2("input_day13.txt") # 32192