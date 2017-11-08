require_relative 'game'

class Main
  attr_accessor :cards, :deck, :hand, :dealer, :player, :game

  def initialize
    puts 'Как Вас зовут ?'
    name = gets.chomp.to_s
    puts "Давайте сырграем, #{name}"
    @game = Game.new(name)
  end

  def menu
    @game.start_game
    game_table(true)
    loop do
      step = second_step
      @game.second_step(step)
      game_table(@game.game_table)
      break if end_round?
    end
    repeat?
  end

  def repeat?
    puts "#{@game.player.name}, сыграем еще ? (Y/N)"
    resp = gets.chomp.to_s
    if resp == 'Y'
      @game.result = ''
      menu
    end
  end

  def game_table(param)
    system 'clear'
    if param
      dealer_points = '***'
      dealer_cards  = '***'
    else
      dealer_cards = []
      dealer_points = @game.dealer.amount_of_points
      @game.dealer.cards.each {|card| dealer_cards << card.card}
    end
    render_table(dealer_points, dealer_cards, @game)
  end

  def render_table(dealer_points, dealer_cards, game)
    player_cards = []
    game.player.cards.each do |card|
      player_cards << card.card
    end
    puts "
    ---------------------------------------
    Game bank: #{@game.bank}\n
    Dealer: #{dealer_points}
    Cards:  #{dealer_cards}
    Cash:   #{game.dealer.cash}

    Player(#{game.player.name.capitalize}): #{game.player.amount_of_points}
    Cards:  #{player_cards}
    Cash:   #{game.player.cash}
    ----------------------------------------\n"
    if end_round?
      puts "
    Result: #{game.result}\n\n"
    end
  end

  def second_step
    if @game.player.card_added? && !@game.player.hand_full?
      puts"
      #{@game.player.name.capitalize}, выберите один из вариантов:
      1. Пропустить
      2. Добавить карту
      3. Открыть карты\n"
    elsif @game.player.hand_full? && !@game.dealer.hand_full?
      puts"
      #{@game.player.name}, выберите один из вариантов:
      1. Пропустить
      3. Открыть карты\n"
    elsif @game.player.hand_full? && @game.dealer.hand_full?
      puts"
      #{@game.player.name}, выберите один из вариантов:
      3. Открыть карты\n"
    end
    gets.chomp.to_i
  end

  def end_round?
    @game.result != ''
  end
end

Main.new.menu
