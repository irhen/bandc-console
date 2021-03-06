config = {
  classic: {
    ranges: {
      first: Array(1..4),
      second: Array(5..8),
      third: [9]
    },
    coeffs: {
      first: [2, 2], 
      second: [2, 2], 
      third: [3]
    }
  },
  advanced: {
    ranges: {
      first: Array(1..5),
      second: Array(6..9).push(0)
    },
    coeffs: {
      first: [10, 20, 10],
      second: [10, 20, 10]
    }
  }
}

def gen_num(set, iter)
  return [] if iter == 0
  local_set = set.clone
  num = local_set.sample(1)
  local_set.delete(num[0])
  num.concat(gen_num(local_set, iter - 1))
end

def gen_set(range, mult)
  result = Array(range)
  mult.each do |key, value| 
    result.concat(Array(0..(value - 2)).fill(key))
  end
  result.sort
end

def gen_mult(ranges, coeffs)
  result = {}
  ranges.each do |key, value| 
    sub_range = value.sample(coeffs[key].length)
    sub_range.each_with_index do |num, index|
      result[num] = coeffs[key][index]
    end
  end
  result
end

def gen_secret_number(config, type)
  if type == 4
    generated_mult = gen_mult(config[:classic][:ranges], config[:classic][:coeffs])
    generated_set = gen_set(1..9, generated_mult)
    gen_num(generated_set, 4)
    elsif type == 6
    generated_mult = gen_mult(config[:advanced][:ranges], config[:advanced][:coeffs])
    generated_set = gen_set(0..9, generated_mult)
    gen_num(generated_set, 6)
  end
end

def game_mode
  puts "Select classic or advanced game mode. For classic press 'c', for advanced press 'a'."
  input = gets.chomp.downcase
  yield input
end

def will_play_again
  puts "Do you want to play again? Press 'y' to continue or any other key to exit."
  input = gets.chomp.downcase
  yield input
end

def is_wrong?(guess, number_of_digits)
  result = false
  if guess.length != number_of_digits
    puts "Please, try again. Your guess must contain exactly #{number_of_digits} digits!"
    result = true
    elsif guess.uniq.length != number_of_digits
    puts "Please, try again. Your guess must contain #{number_of_digits} unique digits!"
    result = true
  end
    
  if guess.include?(0) && number_of_digits == 4
    puts "Please, try again. You cannot use zero in your guess!"
    result = true
  end
  result
end

def is_non_numerical?(guess)
  result = false
  if guess.join("").match(/\D/)
    puts "Please, try again. You cannot use non-numerical characters in your guess!"
    result = true
  end
  result
end

def how_gorgeous_is_user(score)
  if score.length != 1
    puts "You're gorgeous! It took you #{score.length} guesses!"
  else
    puts "You're super gorgeous! It took you just one guess!"
  end
end

def guessing(parameters, element)
  bulls_n_cows = (parameters[:secret_number])&(parameters[:user_guess])
  bulls = parameters[:game][element].map { |index| parameters[:user_guess][index] == parameters[:secret_number][index] }.select { |value| value }.length
  cows = bulls_n_cows.length - bulls
  puts "#{parameters[:user_guess].join("")} has #{bulls} bulls and #{cows} cows."
end

def play(config, element, game_type_in_digits)
  game = [[0, 1, 2, 3], [0, 1, 2, 3, 4, 5]]
  score = []
  user_guess = ""

  secret_number = gen_secret_number(config, game_type_in_digits)
  puts "Input your guess using keyboard."
  
  until user_guess == secret_number
    user_guess = gets.chomp.split("")
    parameters = { secret_number: secret_number, user_guess: user_guess, game: game }
    
    next if is_non_numerical?(user_guess)
    
    user_guess.map! { |el| el.to_i }
    
    next if is_wrong?(user_guess, game_type_in_digits)
    
    score << user_guess
    
    guessing(parameters, element)
  end
  
  how_gorgeous_is_user(score)
  
  score = []
end

game_type = ""
choice = lambda { |input| game_type = input }

game_mode(&choice)
while game_type
  if game_type == "c"
    play(config, 0, 4)
    will_play_again(&choice)
    break unless game_type == "y"
    game_mode(&choice)
  elsif game_type == "a"
    play(config, 1, 6)
    will_play_again(&choice)
    break unless game_type == "y"
    game_mode(&choice)
  else 
    puts "Didn’t quite catch that. What was it, again?"
    game_mode(&choice)
  end
end
