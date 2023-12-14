#
# -L|F7
# 7S-7|
# L|7||
# -L-J|
# L|-JF
#
# ALGO:
# 0. prev_pipe, this_pipe, next_pipe?
#
# 1. Find location of S
# 2. Find the shape of pipe underneath S (needed to know which are the connecting pipes)
#   - if S is |, does it connect TB?
#   - if S is |, does it connect LR?
#   - if S is 7, does it L-B?
#   - if S is L, does it connect TR? etc
#   - if yes, choose the next pipe to proceed (either one)
#     S = F, next pipe is either bottom (row index - 1) or right (col index + 1)
#
#     prev_pipe = F, this_pipe = |
#
# 2. If next pipe is |
#   - check if previous pipe is up or down
#     - if prev pipe is up, then next pipe is going down
#
#     prev_pipe = |, this_pipe = L
#
# If next pipe is -, check if prev pipe is left or right
# If next pipe is 7, check if prev pipe is L or B
# If next pipe is L, check if prev pipe is R or T
# If next pipe is F, check if prev pipe is R or B
#

def parse(filename)
  lines_arr = File.read(filename).split("\n")
  lines_arr.map do |line|
    line.chars
  end
end

def create_pipe_hsh
  ok_left_pipes = %w[- L F]
  ok_right_pipes = %w[- J 7]
  ok_top_pipes = %w[| 7 F]
  ok_bottom_pipes = %w[| J L]

  pipes_hsh = { '|' => [[], [], ok_top_pipes, ok_bottom_pipes],
                '-' => [ok_left_pipes, ok_right_pipes, [], []],
                'L' => [ok_left_pipes, ok_right_pipes, ok_top_pipes, ok_bottom_pipes],
                'J' => [ok_left_pipes, ok_right_pipes, ok_top_pipes, ok_bottom_pipes],
                '7' => [ok_left_pipes, ok_right_pipes, ok_top_pipes, ok_bottom_pipes],
                'F' => [ok_left_pipes, ok_right_pipes, ok_top_pipes, ok_bottom_pipes] }
end

PIPES_HSH = create_pipe_hsh
LEFT = 0
RIGHT = 1
TOP = 2
BOTTOM = 3

def find_animal(arr)
  char = 'S'
  row_index = arr.index do |row|
    row.include?(char)
  end
  col_index = arr[row_index].index(char)
  [row_index, col_index]
end

def get_surrounding_pipes(arr, pipe)
  row_index, col_index = pipe
  left = (col_index - 1 < 0 ? nil : arr[row_index][col_index - 1])
  right = (col_index + 1 > arr.size - 1 ? nil : arr[row_index][col_index + 1])
  top = (row_index - 1 < 0 ? nil : arr[row_index - 1][col_index])
  bottom = (row_index + 1 > arr.size - 1 ? nil : arr[row_index + 1][col_index])

  pipes = [left, right, top, bottom]
  pipes_index = [[row_index, col_index - 1], [row_index, col_index + 1],
                 [row_index - 1, col_index], [row_index + 1, col_index]]
  [pipes, pipes_index]
end

def move(pipe, direction)
  row, col = pipe
  case direction
  when 'left' then [row, col - 1]
  when 'right' then [row, col + 1]
  when 'top' then [row - 1, col]
  when 'bottom' then [row + 1, col]
  end
end

def part1(filename)
  arr = parse(filename)
  this_pipe = find_animal(arr)
  surr_pipes_shapes, = get_surrounding_pipes(arr, this_pipe)

  left, right, top, bottom = surr_pipes_shapes
  prev_pipe = this_pipe
  
  if PIPES_HSH['|'][TOP].include?(top) && PIPES_HSH['|'][BOTTOM].include?(bottom)
    this_pipe = move(prev_pipe, 'bottom')

  elsif PIPES_HSH['-'][LEFT].include?(left) && PIPES_HSH['-'][RIGHT].include?(right)
    this_pipe = move(prev_pipe, 'right')
    
  elsif PIPES_HSH['L'][RIGHT].include?(right) && PIPES_HSH['L'][TOP].include?(top)
    this_pipe = move(prev_pipe, 'top')

  elsif PIPES_HSH['7'][LEFT].include?(left) && PIPES_HSH['7'][BOTTOM].include?(bottom)
    this_pipe = move(prev_pipe, 'bottom')

  elsif PIPES_HSH['F'][RIGHT].include?(right) && PIPES_HSH['F'][BOTTOM].include?(bottom)
    this_pipe = move(prev_pipe, 'bottom')

  elsif PIPES_HSH['J'][TOP].include?(top) && PIPES_HSH['J'][LEFT].include?(left)
    this_pipe = move(prev_pipe, 'left')
  end

  this_pipe_shape = arr[this_pipe[0]][this_pipe[1]]
  nstep = 1
  
  until this_pipe_shape == "S"
    case this_pipe_shape
    when '|'
      next_pipe = (prev_pipe[0] < this_pipe[0] ? move(this_pipe, 'bottom') : move(this_pipe, 'top'))

    when '-'
      next_pipe = (prev_pipe[1] < this_pipe[1] ? move(this_pipe, 'right') : move(this_pipe, 'left'))

    when 'L'
      next_pipe = (prev_pipe[1] == this_pipe[1] ? move(this_pipe, 'right') : move(this_pipe, 'top'))

    when '7'
      next_pipe = (prev_pipe[1] == this_pipe[1] ? move(this_pipe, 'left') : move(this_pipe, 'bottom'))

    when 'F'
      next_pipe = (prev_pipe[1] == this_pipe[1] ? move(this_pipe, 'right') : move(this_pipe, 'bottom'))

    when 'J'
      next_pipe = (prev_pipe[1] == this_pipe[1] ? move(this_pipe, 'left') : move(this_pipe, 'top'))
    end
 
    prev_pipe = this_pipe
    this_pipe = next_pipe
    nstep += 1
    this_pipe_shape = arr[this_pipe[0]][this_pipe[1]]
    
    #p arr[prev_pipe[0]][prev_pipe[1]]
    #p arr[this_pipe[0]][this_pipe[1]]
    #puts "\n"
  end

  p "nstep = #{nstep}"
  p nstep / 2
end

part1('test_input_day10_1.txt')
part1('input_day10.txt')
