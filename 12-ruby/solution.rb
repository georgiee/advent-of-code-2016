

input = "cpy 1 a
cpy 1 b
cpy 26 d
jnz c 2
jnz 1 5
cpy 7 c
inc d
dec c
jnz c -2
cpy a c
inc a
dec b
jnz b -2
cpy c b
dec d
jnz d -6
cpy 19 c
cpy 14 d
inc a
dec d
jnz d -2
dec c
jnz c -5"


class Computer
  INC_DEC = /(inc|dec) ([a-z])/
  COPY = /^cpy ([a-z]||\d+) ([a-z]|\d+)$/
  JUMP = /jnz (\d+|[a-z]) (-?\d+(\.\d+)?)/
  
  attr_reader :registers

  def initialize
    @stack_pointer = 0;
    @registers = { a:0, b:0, c:1, d:0 }

    
  end


  def get(key)
    key = key.to_s
    if(@registers.keys.include?(key.to_sym))
      result = @registers[key.to_sym]
    else
      result = key.to_i
    end
    result
  end

  def set(key, value)
    #puts "set: #{key} = #{value} #{@registers.inspect}"
    @registers[key.to_sym] = get(value)
    #puts "set after #{@registers.inspect}"

  end
  
  def jump(matches)
    condition = get(matches[1]) != 0 
    #puts "--- jump test #{matches[1]} #{condition}"
    
    if(condition)
      #puts "--- do jump by --> #{get(matches[2])}"
      @stack_pointer += get(matches[2])
      return true;
    else
      #puts "--- skip jump"
    end
    return false;
  end

  def copy(matches)
    #puts "--- copy"
    if matches[1] =~ /[a-z]/
        set(matches[2], matches[1])
      else
        set(matches[2], get(matches[1]))
      end
  end
  
  def inc_dec(matches)
    #puts "--- inc/dec"
    if matches[1] == "inc"
      value = +1 
    else
      value = -1
    end 
    set(matches[2], get(matches[2]) + value)
  end

  def process(commands)
    while @stack_pointer < commands.length
      cmd = commands[@stack_pointer].strip
      #puts "\n@#{@stack_pointer} process: '#{cmd}' #{@registers}"
      
      inc_dec($~) if cmd =~ INC_DEC
      copy($~) if cmd =~ COPY
      
      if cmd =~ JUMP
        next if jump($~) 
      end
      
      @stack_pointer += 1
      #sleep(0.1)
    end
  end
end

computer = Computer.new
computer.process(input.lines)

puts "complete: #{computer.registers}"