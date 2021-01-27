def nested_if
  the_first = true
  the_second = true
  the third = true

  if the_first
    if the_second
      puts 'three nested cases' if the third
    end
  end
end

def combination
  the_first = true
  the_second = false
  the third = true

  if the_first
    unless the_second
      puts 'combined cases' if the third
    end
  end
end

def inline_if
  the_first = false
  the_second = false
  the_third = true
  the_fourth = true

  puts 'the first' if the_first

  puts 'the second' unless the_second

  if the_third
    # This should be detected
    puts 'the fourth' if the_fourth
  end
end

def disruptive
  the_first = false
  the_second = false

  if the_first
    # if This comment has if if and unless unless
  end

  if the_second
    'unless This string has if if and unless unless ' if the_second
  end

  if the_second
    'This string has if if and unless unless '
  end
end
