secret_number = Array(1..9).sample(4)
p secret_number #this is just for testing!

#wrap everything in while/until, break when user_guess = secret_number
puts "Input your guess using keyboard."
user_guess = gets.chomp.split("").map { |el| el.to_i }

if user_guess.size != 4
  puts "Please, try again. Your guess must contain exactly 4 digits!"
end

if user_guess[0] == user_guess[1] || user_guess[0] == user_guess[2] || user_guess[0] == user_guess[3] || user_guess[1] == user_guess[2] || user_guess[1] == user_guess[3] || user_guess[2] == user_guess[3]
  puts "Please, try again. Your guess must contain 4 unique digits!"
end

if user_guess.include?(0)
  puts "Please, try again. You cannot use zero in your guess!"
end

bulls_n_cows = secret_number&user_guess
bulls = user_guess.values_at(secret_number.join.to_i) #why does it return exactly one bull every time?
cows = bulls_n_cows.length - bulls.length

puts "#{user_guess.join("")} has #{bulls.length} bulls, #{cows} cows."
