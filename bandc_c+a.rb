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

game_type = ""
choice = Proc.new { |input| game_type = input }
moving_on = Proc.new { |input| game_type = input }
score = []

choosing_game(&choice)

while game_type do
  if game_type == "c"  
    secret_number = Array(1..9).sample(4)
    classic_game = [0, 1, 2, 3]
    user_guess = ""
    
    puts "Input your guess using keyboard."
    
    while user_guess != secret_number do
      user_guess = gets.chomp.split("").map { |el| el.to_i }
      score << user_guess
      
      if classic_check(user_guess) 
        next
      end
            
      bulls_n_cows = secret_number&user_guess
      bulls = classic_game.map{ |index| user_guess[index] == secret_number[index] }.select{ |value| value }
      cows = bulls_n_cows.length - bulls.length
        
      puts "#{user_guess.join("")} has #{bulls.length} bulls and #{cows} cows."
    end
    
    if score.size != 1
      puts "You're gorgeous! You took #{score.size} guesses!"
    else
      puts "You're gorgeous! You took just #{score.size} guess!"
    end
    score = []
    continue(&moving_on)
    
    if game_type != "y"
      break
    end
    
    choosing_game(&choice)
  
  elsif game_type == "a"  
    secret_number_a = Array(0..9).sample(6)
    advanced_game = [0, 1, 2, 3, 4, 5]
    user_guess_a = ""
    
    puts "Input your guess using keyboard."
    
    while user_guess_a != secret_number_a do
      user_guess_a = gets.chomp.split("").map { |el| el.to_i }
      score << user_guess_a
      
      if advanced_check(user_guess_a) 
        next
      end
            
      bulls_n_cows_a = secret_number_a&user_guess_a
      bulls_a = advanced_game.map{ |index| user_guess_a[index] == secret_number_a[index] }.select{ |value| value }
      cows_a = bulls_n_cows_a.length - bulls_a.length
       
      puts "#{user_guess_a.join("")} has #{bulls_a.length} bulls and #{cows_a} cows."
    end
    
    if score.size != 1
      puts "You're super gorgeous!! You took #{score.size} guesses!"
    else
      puts "You're super gorgeous!! You took just #{score.size} guess!"
    end
    score = []
    
    continue(&moving_on)
    
    if game_type != "y"
      break
    end
    
    choosing_game(&choice)
    
  else 
    puts "Didn’t quite catch that. What was it, again?"
    choosing_game(&choice)
  end
end
