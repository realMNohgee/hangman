def initialize_dictionary()
  fname = 'google-10000-english-no-swears.txt'
  dictionary = File.open(fname, "r")
  dict_array = dictionary.readlines(chomp: true)
  dict_array.filter! {|word| word.length > 4}
  dict_array
end

def new_word(dictionary)
  word = dictionary[rand(dictionary.length)]
  word.length.times {print '_ '}
  word
end

def display_current_guess()
  $player_guess.each {|w| print "#{w} "}
end
  
def guess_letter(letter, word)
  word = word.split('')
  if word.include?(letter)
    word.each_with_index {|i, j|
      if i==letter
        $player_guess[j] = "#{i}"
        print "#{letter} "
      else
        print "#{$player_guess[j]} "
      end
      }
  else
    $lives -= 1
    $player_wrong.push(letter)
    puts "letter not included (Lives: #{$lives})"
    display_current_guess()
  end
end

def greeting
  puts "\nWelcome to Hangman Console, you have 7 lives to guess the secret word"
end

def continue_saved_game() #currently working in this method
  puts "\nDo you want to continue the saved game? (y/n)"
  dec = gets.chr.downcase
  if dec=='y'
    regexp = /[_a-z]/
    file = File.open('saved_game.txt', "r")
    guess = file.readline.chomp.split("")
    wrong = file.readline.chomp.split("")
    
    $player_guess = guess.filter {|i| regexp.match?(i)}
    $player_wrong = wrong.filter {|i| regexp.match?(i)}
    $word = file.readline.chomp
    
    file.close
  else
    dictionary = initialize_dictionary()
    $word = new_word(dictionary)
  
    $player_guess = Array.new($word.length, '_')
    $player_wrong = Array.new()
    
  end
end

def save_game(word)
  puts "\nDo you want to save your game? (y/n)"
  dec = gets.chr.downcase
  if dec=='y'
    file = File.open('saved_game.txt', "w")
    file.write("#{$player_guess}")
    file.write("\n#{$player_wrong}")
    file.write("\n#{word}")
    file.close
  end
end
    
#end

play_game = true
p_decide = false

while play_game
  
  greeting
  $lives = 7
  
  continue_saved_game()
  
  while $lives > 0
    if $player_wrong.length !=0
      print "\n\nWrong letters: "
      $player_wrong.each {|i| print "#{i} "}
    end
    
    print "\n\nEnter a letter: "
    
    guess_letter(gets.chr.downcase, $word)
    
    if $player_guess==$word.split('')
      puts "\nCongratulations you have guessed the word!"
      break
    end
  end
  
  if $player_guess!=$word.split('')
    puts "You have failed to guess the secret word"
  end
  
  while !p_decide
    puts 'Do you want to play again (y/n)?'
    dec = gets.chr.downcase
    if dec == 'y'
      play_game = true
      p_decide = true
    elsif dec == 'n'
      save_game($word)
      play_game = false
      p_decide = true
    end
  end
end
