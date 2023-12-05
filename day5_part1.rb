# Input:
#   - each map has 3 numbers: the destination range start, the source range start, and the range length.
#
# Output: Integer
#   - lowest location number for the seeds
#
# Rules:
# 1. There are various categories
#   - seed, soil, fertilizer, water, light, temperature, humidity, location
#   - each category has a number
#   - same number can appear in different categories, but they're not related
#     - e.g. soil 123 not lreated to seed 123
#
# 2. Any source that is NOT mapped is automatically mapped to same destination
#   - e.g. seed 10 to soil 10
#
# Examples:
# 50 98 2
# -> dest: 50, 51 (soil)
# -> source: 98, 99 (seed)
# -> seed 98 maps to 50
#    seed 99 maps to 51
#
# 52 50 48
# -> dest: 52, 53,..99
# -> source: 50, 51, .. 97
# -> seed 50 maps to 52, 51 to 53, ... seed 53 to soil 55
#
# Data:
# - hash maps
#
# Algo:
# 1. Create empty hash:
#   - keys (str): seed, soil, fert, water, light, temp, humidity, loc
#
# 2. Init an array with the above hash
#
# 1. Parse file and get seed numbers as array of integers
# 2. Parse file and get the line index for where the line ends with a "map:" string
#   - store the line index in array `start_index_arr`
# [2, 6, 11, 17....]
#
# 3. Loop each elem with index of `line_index_arr`
#   - slice `lines_arr` from current elem to next elem-2
#   - process selected lines arr along with the corresponding arr from 1
#   (helper)
#
# Helper: populate_mapping(variable_arr, mapping_arr, index)
# 1. Init empty arr `variable`
# 2. Loop each elem of `mapping_arr`
#   - split current string and convert each elem to Integer

def get_seed_numbers(str)
  str.split(': ')[-1].split.map(&:to_i)
end

def get_variable_number(lines_for_mapping, num)
  line = lines_for_mapping.select do |line|
    dest_start, src_start, len = line.split.map(&:to_i)
    dest_end, src_end = dest_start + len - 1, src_start + len - 1
    src_start <= num && src_end >= num
  end
  
  return num if line.empty? 
  
  dest_start, src_start, len = line[0].split.map(&:to_i)
  offset_from_start = num - src_start
  dest_start + offset_from_start
end

def function(filename)
  lines_arr = File.read(filename).split("\n")
  seed_num = get_seed_numbers(lines_arr[0])
  start_index_arr = lines_arr.each_index.select do |index|
    lines_arr[index].end_with?('map:')
  end

  lines_seed2soil = lines_arr[start_index_arr[0] + 1 .. start_index_arr[1] - 2]
  lines_soil2fert = lines_arr[start_index_arr[1] + 1 .. start_index_arr[2] - 2]
  lines_fert2water = lines_arr[start_index_arr[2] + 1.. start_index_arr[3] - 2]
  lines_water2light = lines_arr[start_index_arr[3] + 1 .. start_index_arr[4] - 2]
  lines_light2temp = lines_arr[start_index_arr[4] + 1.. start_index_arr[5] - 2]
  lines_temp2humid = lines_arr[start_index_arr[5] + 1.. start_index_arr[6] - 2]
  lines_humid2loc = lines_arr[start_index_arr[6] + 1 .. lines_arr.size - 1]

  all_loc_num = []
  seed_num.each do |num|
    soil_num = get_variable_number(lines_seed2soil, num)
    fert_num = get_variable_number(lines_soil2fert, soil_num)
    water_num = get_variable_number(lines_fert2water, fert_num)
    light_num = get_variable_number(lines_water2light, water_num)
    temp_num = get_variable_number(lines_light2temp, light_num)
    humid_num = get_variable_number(lines_temp2humid, temp_num)
    loc_num = get_variable_number(lines_humid2loc, humid_num)
    all_loc_num << loc_num
  end
  all_loc_num.min
end

p function('input_day5.txt') # 510109797