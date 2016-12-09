#http://stackoverflow.com/questions/17894340/parse-string-with-nested-brackets

#10762972448 < x < 20762972448

require 'strscan'
def parse input, sum = 0

  scanner = StringScanner.new input
  opened = false

  while not scanner.eos?
    string = scanner.scan(/[^()]+/)
    sum = sum + string.length unless string.nil?

    if scanner.peek(1) == '('
      scanner.pos = scanner.pos + 1
      marker = scanner.scan(/[^()]+/).split('x')

      length = marker[0].to_i
      cycle = marker[1].to_i

      scanner.pos = scanner.pos + 1
      content = scanner.peek(length) * cycle
      content = parse(content)
      scanner.pos = scanner.pos + length

      sum = sum + content
    end
  end


  return sum
end


file = File.open("input.txt", "r")
inputs = parse file.read
#inputs = parse "(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN"
puts inputs
