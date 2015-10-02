require 'pry'

class Player
  attr_accessor :move, :name, :score

  def initialize
    set_name
    @score = []
    @move_history = []
  end

  def collect_move(move)
    @move_history << move
  end
end

class Human < Player
  def set_name
    n = nil
    loop do
      puts "What is your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, you must enter a name."
    end
    @name = n
  end

  def choose
    choice = ''
    loop do
      puts "Please choose rock, paper, or scissors: "
      choice = gets.chomp
      break if Move::VALUES.include? choice
      puts "Sorry that is an invalid choice."
    end
    @move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    @name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    @move = Move.new(Move::VALUES.sample)
  end
end

class Move
  VALUES = ['rock', 'paper', 'scissors']

  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def >(other_move)
    (rock? && other_move.scissors?) ||
      (paper? && other_move.rock?) ||
      (scissors? && other_move.paper?)
  end

  def <(other_move)
    (rock? && other_move.paper?) ||
      (paper? && other_move.scissors?) ||
      (scissors? && other_move.rock?)
  end

  def to_s
    @value
  end
end

# Game Orchestration Engine
class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
    @human_moves = []
    @computer_moves = []
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors!"
    puts "The first player to 3 wins the game!"
  end

  def display_goodbye_message
    puts "Thanks for playing my Rock, Paper, Scissors game. Bye!"
  end

  def display_moves
    puts "-----"
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_turn_winner
    if human.move > computer.move
      puts "#{human.name} won this turn!"
    elsif human.move < computer.move
      puts "#{computer.name} won this turn!"
    else
      puts "It's a tie!"
    end
  end

  def track_score(human_score, computer_score)
    if human.move > computer.move
      human_score.push('1')
    elsif human.move < computer.move
      computer_score.push('1')
    end
  end

  def display_score
    puts "#{human.name}'s score is #{human.score.size}."
    puts "#{computer.name}'s score is #{computer.score.size}."
  end

  def game_winner?(human_score, computer_score)
    human_score.size == 3 || computer_score.size == 3
  end

  def display_game_winner(human_score, computer_score)
    if human_score.size == 3
      puts "#{human.name} won the game!"
    elsif computer_score.size == 3
      puts "#{computer.name} won the game!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if ['y', 'n'].include? answer
      puts "Plese enter a valid response."
    end

    return false if answer == 'n'
    return true if answer == 'y'
  end

  def collect_moves
    @human_moves << human.move
    @computer_moves << computer.move
  end

  def display_move_history
    puts "Your moves have been: #{@human_moves.join(", ")}."
    puts "#{computer.name}'s moves have been: #{@computer_moves.join(", ")}."
    puts "-----"
  end

  def game_play
    display_welcome_message
    loop do
      loop do
        human.choose
        computer.choose
        collect_moves
        display_moves
        track_score(human.score, computer.score)
        display_turn_winner
        display_score
        display_move_history
        break if game_winner?(human.score, computer.score)
      end
      display_game_winner(human.score, computer.score)
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.game_play
