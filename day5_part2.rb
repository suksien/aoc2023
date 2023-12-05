def get_seed_numbers(str)
  arr = str.split(': ')[-1].split.map(&:to_i)
  seed_start_num, seed_range = arr.partition.with_index do |num, index|
    index.even?
  end
  return seed_start_num, seed_range
end

def get_variable_number_reverse(lines_for_mapping, num)
  line = lines_for_mapping.select do |line|
    src_start, dest_start, len = line.split.map(&:to_i)
    src_end, dest_end = src_start + len - 1, dest_start + len - 1
    src_start <= num && src_end >= num
  end
  
  return num if line.empty? 
  
  src_start, dest_start, _ = line[0].split.map(&:to_i)
  offset_from_start = num - src_start
  dest_start + offset_from_start
end

def function(filename)
  lines_arr = File.read(filename).split("\n")
  seed_start_num, seed_range = get_seed_numbers(lines_arr[0])
  
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

  (0..).each do |loc_num|
    humid_num = get_variable_number_reverse(lines_humid2loc, loc_num)
    temp_num = get_variable_number_reverse(lines_temp2humid, humid_num)
    light_num = get_variable_number_reverse(lines_light2temp, temp_num)
    water_num = get_variable_number_reverse(lines_water2light, light_num)
    fert_num = get_variable_number_reverse(lines_fert2water, water_num)
    soil_num = get_variable_number_reverse(lines_soil2fert, fert_num)
    seed_num = get_variable_number_reverse(lines_seed2soil, soil_num)

    next if seed_start_num.min > seed_num 

    seed_start_num.each_index do |index|
      start_num, end_num = seed_start_num[index], seed_start_num[index] + seed_range[index] - 1
      return loc_num if (start_num..end_num).include?(seed_num)
    end
  end
end

p function('input_day5.txt') # 9622622