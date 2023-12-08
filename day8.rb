# Output: Integer - how many steps to go from AAA to ZZZ
# Rules:
# AAA is where you are now
# ZZZ is where you want to go
# - follow the LR directions until you reach ZZZ
#
# EXAMPLES:
# Each node of network:
# RL -> have to start R, then L, then repeat
#
# AAA = (BBB, CCC) -> AAA = (right, left)
# BBB = (DDD, EEE)
# CCC = (ZZZ, GGG)
# DDD = (DDD, DDD)
# EEE = (EEE, EEE)
# GGG = (GGG, GGG)
# ZZZ = (ZZZ, ZZZ
#
# Following the instructions:
# 1. go R of AAA -> CCC
# 2. go L of CCC -> ZZZ
# --> reach ZZZ in 2 steps
#
# LLR -> sequence of directions
#
# AAA = (BBB, BBB)
# BBB = (AAA, ZZZ)
# ZZZ = (ZZZ, ZZZ)
# 1. go L of AAA -> BBB
# 2. go L of BBB -> AAA
# 3. go R of AAA -> BBB
#
# 4. go L of BBB -> AAA
# 5. go L of AAA -> BBB
# 6. go R of BBB -> ZZZ
# --> reach in 6 steps
#
# DATA:
# - array of int (instructions) where L=0, right=1
# - hash of node
#   - key (str): AAA
#   - value (arr): [BBB, BBB]
#
# ALGO:
# (helper)
# 1. Get the array of instructions (`instr_arr`)
# 2. Create the node Hash
#
# 3. INit start_node='AAA', end_node=nil
# 4. Init counter=0
# 5. init nloop_instr = 1
# 4. while end_node is not ZZZ
#    - get current instruction; 0
#    - get value of start_node key; ["BBB", "CCCC"]
#    - get the next node based on instruction; "BBB"
#    - set end_node to this next node
#    - increment counter
#    - if counter >= size of instruction
#     - increment nloop_instr
#     - reset counter to 0
# 5. Get total number of steps to be nloop_instr * counter
#
#

def parse(filename)
  lines_arr = File.read(filename).split("\n")
  instr_arr = lines_arr[0].chars.map do |char|
    char == 'L' ? 0 : 1
  end
  node_hsh = {}
  lines_arr[2..-1].each do |line|
    key = line.split(' = ')[0]
    l = line.split(' = ')[1]
    ind1 = l.index('(')
    ind2 = l.index(')')
    val = [l[ind1 + 1, 3], l[ind2 - 3...ind2]]
    node_hsh[key] = val
  end
  [instr_arr, node_hsh]
end

def part1(filename)
  instr_arr, node_hsh = parse(filename)
  start_node = 'AAA'
  nsteps = 0
  counter = 0
  until start_node == 'ZZZ'
    instr = instr_arr[counter]
    start_node = node_hsh[start_node][instr]
    counter += 1
    counter = 0 if counter > instr_arr.size - 1
    nsteps += 1
  end
  nsteps
end

p part1('test_input_day8_1.txt')
p part1('test_input_day8_2.txt')
p part1('input_day8.txt')
p "--------"

# * start at every node that ends with A
# * want all starting node to end in Z
# * If only some of the nodes you're on end with Z, they act like any other node and you continue as normal.
#
# 1. Get all starting nodes ending with A, store asn array?
# [11a, 22a]
# 2. Init end_node_arr = [nil, nil]
# 3. While start_node_arr does not all end in "Z"
#

def get_all_start_nodes(node_hsh)
  node_hsh.keys.select do |node|
    node.end_with?('A')
  end
end

def part2(filename)
  instr_arr, node_hsh = parse(filename)
  start_nodes = get_all_start_nodes(node_hsh)
  nsteps_all = []

  start_nodes.each do |node|
    nsteps = 0
    counter = 0
    until node.end_with?('Z')
      instr = instr_arr[counter]
      end_node = node_hsh[node][instr]
      node = end_node
      counter += 1
      counter = 0 if counter > instr_arr.size - 1
      nsteps += 1
    end
    nsteps_all << nsteps
  end

  p nsteps_all
  nsteps_all.reduce(:lcm)
  # num_max = nsteps_all.max
  # found_num = (600_000_000 .. 900_000_000).find do |num|
  #     arr.all? do |n|
  #       (num * num_max) % n == 0
  #     end
  #   end # 661313383
  # num_max * found_num
end

p part2('test_input_day8_3.txt')
p part2('input_day8.txt') # 13740108158591
