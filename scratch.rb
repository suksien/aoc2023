=begin

#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

one line mismatch
one spot mismatch

"====="
"..##..##."
"====="
"####..##."
"====="
"#..#..##."
"====="

=end

def find_horizontal_mirror_with_smudge(pattern)
  mirror = {}
  pattern = pattern.map(&:join)

  (1..pattern.size-1).each do |index|
    top_half = pattern[0..index-1]
    bottom_half = pattern[index..-1]

    n_elem = [top_half.size, bottom_half.size].min
    top_half.reverse!
    

    mismatch_index = (0..n_elem-1).select do |i| 
      top_half[i] != bottom_half[i]
    end

    if mismatch_index.size == 1
      indx = mismatch_index[0]
      top, bottom = top_half[indx], bottom_half[indx]
      
       (top.chars.each_index.select do |index|
        top[index] != bottom[index]
      end)
      p "===="
    end
  end
  
end