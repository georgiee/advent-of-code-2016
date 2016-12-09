#http://stackoverflow.com/questions/17894340/parse-string-with-nested-brackets

#10762972448 < x < 20762972448

require 'strscan'
def parse input, sum = 0

  scanner = StringScanner.new input
  opened = false
  result = []

  while not scanner.eos?
    string = scanner.scan(/[^()]+/)
    result << string
    case scanner.scan /[()]+/
    when '('
      opened = true
      marker = scanner.scan(/[^()]+/).split('x')
      length = marker[0].to_i
      cycle = marker[1].to_i
      scanner.pos = scanner.pos + 1
      #puts "length #{length}"
      new_content = scanner.peek(length) * cycle
      result << new_content
      #puts "new_content: #{new_content}"
      sum = sum + new_content.length
      scanner.pos = scanner.pos + length
      #puts scanner.rest
      opened = false
    when ')'
      opened = false
      #puts "closed:"      
      result << string
      sum = string.length
    else
      result << string
      sum = string.length
    end
  end

  return result * ""
end


file = File.open("input.txt", "r")
#inputs = parse "X(8x2)(3x3)ABCY"
inputs = parse file.read
puts inputs.length
