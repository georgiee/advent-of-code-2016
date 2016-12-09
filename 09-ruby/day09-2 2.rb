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

    if scanner.peek(1) == '('
      scanner.pos = scanner.pos + 1
      marker = scanner.scan(/[^()]+/).split('x')

      length = marker[0].to_i
      cycle = marker[1].to_i

      scanner.pos = scanner.pos + 1
      content = scanner.peek(length) * cycle
      scanner.pos = scanner.pos + length

      result << content
    end
  end


  return result * ""
end


file = File.open("input.txt", "r")
inputs = parse file.read
#inputs = parse "A(2x2)BCD(2x2)EFG"
puts inputs.length
