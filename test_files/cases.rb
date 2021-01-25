# nested if statementes
def nested_if
  if true
    if true
      puts 'nested if!'
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
    if true
     index += 1
    end
    if false
      index += 1
    end
  end
end


# similar if statements

def similar_if
  if 1
    puts '1' 
  end

  if 2
    puts '2'
  end

  if 3
    puts '3'
  end
end