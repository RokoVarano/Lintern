
def nested_if
  if true
    if true
      puts 'nested if!' if true
    end
  end
end

# useless 'else' clause

def useless_else
  if true
    'already returning'
  else
    'this could be a separate if'
  end
end

# repeating effect in loops

def repeated_effect
  index = 0

  while index > 10
    index += 1 if true
    index += 1 if false
  end
end

# similar if statements

def similar_if
  puts '1' if 1

  puts '2' if 2

  puts '3' if 3
end
