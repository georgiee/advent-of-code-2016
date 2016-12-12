require 'ostruct'


commands = "value 5 goes to bot 2
bot 2 gives low to bot 1 and high to bot 0
value 3 goes to bot 1
bot 1 gives low to output 1 and high to bot 0
bot 0 gives low to output 2 and high to output 0
value 2 goes to bot 2"

$pattern_value = /value (\d) goes to bot (\d)/
$pattern_give = /bot (\d) gives low to (bot|output) (\d) and high to (bot|output) (\d)/

class Factory
  def initialize
    @bots = []
    @outputs = []
  end
  
  def process(commands)
    commands.each do |command|
      process_give(command) if command.action == 'give'
      process_value(command) if command.action == 'value'
    end
  end

  def process_value(data)
    puts "process value #{data}"
  end
  
  def process_give(data)
    puts "process give #{data}"
  end

end


def parse_commands(string)
  result = []
  if matches = $pattern_value.match(string)
    result << OpenStruct.new({
      action: 'value',
      bot: matches[1].to_i,
      value: matches[2].to_i
    })
  
  elsif matches = $pattern_give.match(string)
    result << OpenStruct.new({
      action: 'give',
      bot: matches[1].to_i,
      receiver_low_type: matches[2],
      receiver_low_id: matches[3].to_i,
      receiver_high_type: matches[4],
      receiver_high_id: matches[5].to_i
    })

  else
    puts "unknown command: #{string}"
  end

  result
end

$factory = Factory.new


commands.each_line do |line|
  command = parse_commands line
  $factory.process(command)

  #puts "line: #{line}" 
  #line.

end

if false
ARGF.each do |line|
  parse_command line
end
end

#string = "value 2 goes to bot 2"
#puts pattern.match(string).inspect

#puts string.scan(/\d+/)