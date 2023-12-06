def get_seed_numbers(str)
  arr = str.split(': ')[-1].split.map(&:to_i)
  seed_start_num, seed_range = arr.partition.with_index do |num, index|
    index.even?
  end
  return seed_start_num, seed_range
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

  min_loc_num = nil
  seed_start = [seed_start_num[0]]

  seed_start_num.each_with_index do |num, index|
    nseed = seed_range[index]
    nseed.times do 
      soil_num = get_variable_number(lines_seed2soil, num)
      fert_num = get_variable_number(lines_soil2fert, soil_num)
      water_num = get_variable_number(lines_fert2water, fert_num)
      light_num = get_variable_number(lines_water2light, water_num)
      temp_num = get_variable_number(lines_light2temp, light_num)
      humid_num = get_variable_number(lines_temp2humid, temp_num)
      loc_num = get_variable_number(lines_humid2loc, humid_num)
      p loc_num if nseed == nseed / 2
      if min_loc_num.nil? 
        min_loc_num = loc_num
      else
        min_loc_num = loc_num if loc_num < min_loc_num
      end
      num += 1
    end
  end
  p min_loc_num
end

#p function('test_input_day5.txt')
function('input_day5.txt')