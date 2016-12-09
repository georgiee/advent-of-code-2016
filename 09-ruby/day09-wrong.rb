#http://stackoverflow.com/questions/17894340/parse-string-with-nested-brackets
require 'strscan'

def parse input
  scanner = StringScanner.new input
  stack = [[]]
  while not scanner.eos?
    string = scanner.scan(/[^()]+/)
    case scanner.scan /[()]+/
    when '('
      stack.last << string #save the last content

      new_nesting = []
      stack.last << new_nesting
      stack << new_nesting
    when ')'
      stack.last << string
      puts "popped: #{string} "
      stack.pop
    else
        puts "content: #{string} "
      stack.last << string
    end
  end
  stack.last
end




inputs = parse "(19x14)(3x2)ZTN(5x14)MBPWH(112x2)(20x15)(2x15)AX(7x4)UDNOYNU(7x7)YGJJMBB(59x11)"


[nil, *inputs, nil].each_cons(3){|prev, curr, nxt|
  if(prev.kind_of?(Array) && curr.kind_of?(String))
    puts "process #{curr}, prepend #{prev[1..-1]} and use marker with #{prev.first} "
    marker = prev.first
    data = prev[1..-1].map { |item| "(#{item})" }
    marker = marker.split('x')
    
    puts data
    puts data[0..-1]
    data.to_a.cycle(marker[1])
    puts "#{data*""}#{curr} -- #{marker}"
  else
    puts "skip on #{curr}"
  end
}


puts inputs.inspect
