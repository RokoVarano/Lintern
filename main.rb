require 'rubygems'
require 'bundler/setup'

# 1. The program reads the file and gets an array of hashes.
# A list of offenses is needed to plan their corresponding detecting methods
  # - nested if methods -> Use guard classes
  # - repetitive conditions in loops inside if statements -> summerize the condition at the end of the loop
  # - case or if statements with similar effects -> use .map
  # - useless 'else' statements (when if statements return) -> use if as a guard statements
  # - method does not return anything -> ask to return something so it can be easily tested.
# 2. it detects offenses by looking at key errors, repetitions and unnescesarily nested statements

Bundler.require(:default)

