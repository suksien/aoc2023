=begin

Input: initialization sequence
  - comma-separated string of chars (one step)
    e.g. "rn=1,cm-,qp=3" are 3 steps

Run the HASH algo on each step 
- start from current = 0
- loop each char of str
  - get the ascii code for current char
  - current += ascii_code
  - current *= 17
  - current %= 256

=end

def run_hash_algo(str)
  current = 0
  str.chars.each do |char|
    current += char.ord
    current *= 17
    current %= 256
  end
  current
end

def part1(filename)
  sequence = File.read(filename).split(",")
  hash_output_arr = sequence.map do |step|
    no_newline_step = step.split("\n")[0]
    run_hash_algo(no_newline_step)
  end
  p hash_output_arr.sum
end

#part1("test_input_day15.txt") # 1320
#part1("input_day15.txt") # 517551

=begin

PROBLEM: perform each step in the initialization sequence (hashmap)
Output: sum of focusing power of ALL lenses

RULES:
boxes numbered from 0 to 255
inside each box is a lens 
  - the side of each box has a panel that allows one to insert/remove lenses as needed

focal length from 1 to 9

dash
- go to the relevant box 
- remove the lens with the given label (rn, pq etc), if present in the box

equal
- followed by a number indicating the focal length of the lens that needs to go into the relevant box
- if existing lens with same label, update the focal length
- if not same lens, add lens to the end

order of lenses in the box MATTERS

To get focusing power of a lens:
- (1 + box number) * (slot number of lens) * focal length of lens
- box number is the output of HASH algo
- slot number starts from 1, 2...

There will be 256 boxes

EXAMPLES:

rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
  30,253,  97,

"rn=1"
each step of sequence
- sequence of letters that indicate the label of the lens on which the step operates, "rn"
- running the HASH algorithm on the label indicates the correct box for that step, "rn" --> 0

=end

# boxes = {0 => [{rn: 9}, {pc: 1}, {}], 2=> []...}
# boxes = [0 => ["rn 9", "pc 1", "..."], 2 => ] (chosen)

def remove_lens!(boxes, box_num, new_lens_label)
  lenses_in_this_box = boxes[box_num]

  unless lenses_in_this_box.nil? || lenses_in_this_box.empty?
    lenses_in_this_box.each_index do |index|
      this_lens = lenses_in_this_box[index]
      this_label, this_fp = this_lens.split(" ")
      if this_label == new_lens_label
        lenses_in_this_box.delete_at(index)
        break
      end
    end
  end
end

def update_lens!(boxes, box_num, new_lens_label, new_lens_fl)
  lenses_in_this_box = boxes[box_num] # ["rn 9", "pc 1", "..."]
  new_lens = "#{new_lens_label} #{new_lens_fl}"
  
  if lenses_in_this_box.nil? || lenses_in_this_box.empty?
    boxes[box_num] = [new_lens]
  else
    lenses_in_this_box.each_index do |index|
      this_lens = lenses_in_this_box[index]
      this_label, this_fp = this_lens.split(" ")
        if this_label == new_lens_label
          lenses_in_this_box[index] = new_lens
          break
        end
        lenses_in_this_box << new_lens if index == lenses_in_this_box.size - 1
    end
  end
end

def calc_fp(boxes)
  total_fp = 0
  boxes.each do |box_num, all_lenses|
    unless all_lenses.nil? || all_lenses.empty?
      all_lenses.each_index do |index|
        this_label, this_fp = all_lenses[index].split(" ")
        total_fp += ((1 + box_num) * (index + 1) * this_fp.to_i)
      end
    end
  end
  total_fp
end

def part2(filename)
  boxes = Array(0..255).zip(Array.new(256,nil)).to_h
  sequence = File.read(filename).split(",")
  all_lenses = []

  sequence.map do |step|
    step = step.split("\n")[0]
    #puts "Before #{step}"

    if step.end_with?("-")
      lens_label = step.split("-")[0]
      box_num = run_hash_algo(lens_label)
      #puts "Box #{box_num}: #{boxes[box_num]}"
      remove_lens!(boxes, box_num, lens_label) # perform dash operation
      
    else
      lens_label, focal_length = step.split("=")[0], step.split("=")[1]
      box_num = run_hash_algo(lens_label)
      #puts "Box #{box_num}: #{boxes[box_num]}"
      update_lens!(boxes, box_num, lens_label, focal_length)
    end

    all_lenses << lens_label unless all_lenses.include?(lens_label)
    # puts "  After #{step}"
    # puts "  Box #{box_num}: #{boxes[box_num]}"
    # puts "\n"
  end

  p tot_fp = calc_fp(boxes)
  
end


part2("test_input_day15.txt") # 145
part2("input_day15.txt") # 286097 too low