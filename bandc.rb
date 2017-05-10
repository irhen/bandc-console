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
  if iter == 0 
    return []
  end
  local_set = set.clone
  num = local_set.sample(1)
  local_set.delete(num[0])
  num.concat(gen_num(local_set, iter - 1))
end

def gen_set(range, mult)
  result = Array(range)
  mult.each do |k, v| 
    result.concat(Array(0..(v - 2)).fill(k))
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

def choosing_game
  puts "Select classic or advanced game mode. For classic press 'c', for advanced press 'a'."
  input = gets.chomp.downcase
  yield input
end

def continue
  puts "Do you want to play again? Press 'y' to continue or any other key to exit."
  input = gets.chomp.downcase
  yield input
end

def classic_check(variable)
  result = false
  if variable.size != 4
    puts "Please, try again. Your guess must contain exactly 4 digits!"
    result = true
  end
        
  if variable.uniq.length != 4
    puts "Please, try again. Your guess must contain 4 unique digits!"
    result = true
  end
    
  if variable.include?(0)
    puts "Please, try again. You cannot use zero in your guess!"
    result = true
  end
  result
end

def advanced_check(variable)
  result = false
  if variable.size != 6
    puts "Please, try again. Your guess must contain exactly 6 digits!"
    result = true
  end
        
  if variable.uniq.length != 6
    puts "Please, try again. Your guess must contain 6 unique digits!"
    result = true
  end
  result
end

game = [[0, 1, 2, 3], [0, 1, 2, 3, 4, 5]]
score = []
user_guess = ""
game_type = ""

choice = Proc.new { |input| game_type = input }

choosing_game(&choice)

while game_type do
  if game_type == "c"  
    generated_mult = gen_mult(config[:classic][:ranges], config[:classic][:coeffs])
    generated_set = gen_set(1..9, generated_mult)
    secret_number = gen_num(generated_set, 4)
    puts "Input your guess using keyboard."
    
    while user_guess != secret_number do
      user_guess = gets.chomp.split("").map { |el| el.to_i }
      
      if classic_check(user_guess) 
        next
      end
      
      score << user_guess
      bulls_n_cows = secret_number&user_guess
      bulls = game[0].map { |index| user_guess[index] == secret_number[index] }.select { |value| value }
      cows = bulls_n_cows.length - bulls.length
        
      puts "#{user_guess.join("")} has #{bulls.length} bulls and #{cows} cows."
    end
    
    if score.size != 1
      puts "You're gorgeous! It took you #{score.size} guesses!"
    else
      puts "You're gorgeous! It took you just one guess!"
    end
    
    score = []
    
    continue(&choice)
    
    if game_type != "y"
      break
    end
    
    choosing_game(&choice)
  
  elsif game_type == "a"
    generated_mult = gen_mult(config[:advanced][:ranges], config[:advanced][:coeffs])
    generated_set = gen_set(0..9, generated_mult)
    secret_number = gen_num(generated_set, 6)
    puts "Input your guess using keyboard."
    
    while user_guess != secret_number do
      user_guess = gets.chomp.split("").map { |el| el.to_i }

      if advanced_check(user_guess) 
        next
      end
      
      score << user_guess            
      bulls_n_cows = secret_number&user_guess
      bulls = game[1].map { |index| user_guess[index] == secret_number[index] }.select { |value| value }
      cows = bulls_n_cows.length - bulls.length
       
      puts "#{user_guess.join("")} has #{bulls.length} bulls and #{cows} cows."
    end
    
    if score.size != 1
      puts "You're gorgeous! It took you #{score.size} guesses!"
    else
      puts "You're gorgeous! It took you just one guess!"
    end
    
    score = []
    
    continue(&choice)
    
    if game_type != "y"
      break
    end
    
    choosing_game(&choice)
    
  else 
    puts "Didn’t quite catch that. What was it, again?"
    choosing_game(&choice)
  end
end
