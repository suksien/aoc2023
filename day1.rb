=begin

PROBLEM
Input: textfile
  - each line has at least 1 integer

Output: Integer
  - sum of the calibration value from all lines

Rules:
- to decipler the calibration value, combine the 1st and last digit to form a 2-digit number
  - if a line only has 1 number, then the first and last digit is repeated to form a 2-digit number

EXAMPLES
two1nine -> two, 1, nine -> 29
eightwothree -> eight, three -> 83
abcone2threexyz -> one, 2, three -> 13
xtwone3four -> two, 3, four -> 24
4nineeightseven2 -> 4, nine, eight, seven, 2 -> 42
zoneight234 -> one, 2, 3, 4-> 14
7pqrstsixteen -> 7, six -> 76

In this example, the calibration values are 29, 83, 13, 24, 42, 14, and 76. Adding these together produces 281.

DATA
- file, string (input)
- integer (output)
- array 

ALGO
* order of digit matters
* want the first and last digit

1. Read in the input file
  - Return an array of strings from input file, where each string is a line from the input file (`lines_arr`)
2. Init a Hash
  - key (str): one, two...nine
  - value (int): 1, 2...9
3. Init an empty Array (`calibration_value`)
4. Loop each string of `lines_arr`
  - find all digits (helper method)
  - get the first and last digit
    - if any digit is a letter digit, get the numerical digit 
  - concat the first and last digit
  - convert string to Integer and store to `calibration_value`
 
4. Add up all the numbers in `calibration_value`
5. Return the sum

find_digits(str)
- init an array of letter digits (one, two, three...)
- get an array of chars from input str
- init empty array
- init counter to 0
- loop
  - loop each index of chars arr
    - if current char is a numerical digit, append current char to Array
      - delete char at current index
      - break 
    - else, loop from 3 to size of Array
      - slice from current index with current len, rejoin strings
      - if the string is found in letter digits
        - append string to Array
        - delete chars from index=0 to current index + current len - 1
        - break

=end

LETTER_DIGITS = %w(one two three four five six seven eight nine)
NUM_DIGITS = %w(1 2 3 4 5 6 7 8 9)
HSH = LETTER_DIGITS.zip(NUM_DIGITS).to_h

def find_digits(str)
  arr = []
  counter = 0
  loop do
    if str[counter].to_i.to_s == str[counter]
      arr << str[counter]
    else
      slice_str = str[counter..-1]
      (3..5).each do |len|
        substr = slice_str[0, len]
        if LETTER_DIGITS.include?(substr)
          arr << HSH[substr]
          break
        end
      end
    end
    counter += 1
    break if counter >= str.size
  end
  arr
end

def sum_calibration(inputfile)
  lines_arr = File.read(inputfile).split("\n")
  calibration_value = lines_arr.map do |str|
    #arr = str.scan(/[0-9]/)
    arr = find_digits(str)
    (arr[0] + arr[-1]).to_i
  end
  calibration_value.sum
end

p sum_calibration("input_day1.txt")