puts "Welcome! Select classic or advanced game! For classic press 'c', for advanced press 'a'."
game_type = gets.chomp

def classic_check(variable)
  if variable.size != 4
    puts "Please, try again. Your guess must contain exactly 4 digits!"
  end
        
  if variable.uniq.length != 4
    puts "Please, try again. Your guess must contain 4 unique digits!"
  end
    
  if variable.include?(0)
    puts "Please, try again. You cannot use zero in your guess!"
  end
end

def advanced_check(variable)
  if variable.size != 6
    puts "Please, try again. Your guess must contain exactly 6 digits!"
  end
        
  if variable.uniq.length != 6
    puts "Please, try again. Your guess must contain 6 unique digits!"
  end
end

while game_type == "c" or "a" do
  if game_type == "c"  
    secret_number = Array(1..9).sample(4)
    p secret_number #delete after testing
    classic_game = [0, 1, 2, 3]
    user_guess = ""
    
    puts "Input your guess using keyboard."
    
    while user_guess != secret_number do
      user_guess = gets.chomp.split("").map { |el| el.to_i }
      
      classic_check(user_guess)
            
      bulls_n_cows = secret_number&user_guess
      bulls = classic_game.map{ |index| user_guess[index] == secret_number[index] }.select{ |value| value }
      cows = bulls_n_cows.length - bulls.length
        
      puts "#{user_guess.join('')} has #{bulls.length} bulls and #{cows} cows."
    end
    
    puts "You're gorgeous!"
  
  elsif game_type == "a"  
    secret_number_a = Array(0..9).sample(6)
    p secret_number_a #delete after testing
    advanced_game = [0, 1, 2, 3, 4, 5]
    user_guess_a = ""
    
    puts "Input your guess using keyboard."
    
    while user_guess_a != secret_number_a do
      user_guess_a = gets.chomp.split("").map { |el| el.to_i }
      
      advanced_check(user_guess_a)
            
      bulls_n_cows_a = secret_number_a&user_guess_a
      bulls_a = advanced_game.map{ |index| user_guess_a[index] == secret_number_a[index] }.select{ |value| value }
      cows_a = bulls_n_cows_a.length - bulls_a.length
       
      puts "#{user_guess_a.join("")} has #{bulls_a.length} bulls and #{cows_a} cows."
    end
    
    puts "You're super gorgeous!!"
    
  else 
    puts "Didn’t quite catch that. What was it, again?"
    game_type = gets.chomp
  end
end
