# ABSTRACT STATE
require './context'

class AuthorizationLevel
  @job = ''

  def initialize(worker)
    @context = worker
  end

  %i[increase_level decrease_level show_salary get_to_sector].each do |mth|
    define_method mth do |*|
      raise(
        NotImplementedError,
        'Redeclare this method in a child class, don\'t use the abstract ' \
        'method!'
      )
    end
  end

  %i[fix_communication_error interact_with_matter analyze_costs].each do |mth|
    define_method mth do
      denied
    end
  end

  def job=(job = false)
    @context.job =
      if job.is_a?(Symbol)
        job
      else
        self.class.instance_variable_get('@job')
      end
  end

  private

  def denied
    puts "\e[31mACCESS DENIED\e[0m"
  end
end

# CONCRETE STATES
class WorkerLevel < AuthorizationLevel
  @job = :worker

  def increase_level
    @context.current_level = @context.level2
    self.job = :engineer
    puts 'The level of trust is increased to Engineer'
  end

  def decrease_level
    puts 'Can not decrease the level of trust (already the first one)'
  end

  def show_salary
    @context.earned_money += 1000
    puts 'You`ve got 1000$ for your work'
  end

  def get_to_sector(number = 1)
    if number == 1
      puts 'SECTOR #1 ACCESS GRANTED'
      puts 'Business center of managers and analysts'
    else
      denied
    end
  end

  def analyze_costs
    puts 'The last month experiements cost to company 102_342$'
  end
end

class EngineerLevel < AuthorizationLevel
  @job = :engineer

  def increase_level
    @context.current_level = @context.level3
    self.job = :scientist
    puts 'The level of trust is increased to the Scientist, congratulations!'
  end

  def decrease_level
    @context.current_level = @context.level1
    self.job = :worker
    puts 'The level of trust is decreased to #1. Please, work harder to get ' \
    'back the trust.'
  end

  def show_salary
    @context.earned_money += 10_000
    puts 'You`ve got 10 000$ for your work. Thank you!'
  end

  def get_to_sector(number = 2)
    if number == 1
      puts 'SECTOR #1 ACCESS GRANTED (not your regular working place)'
      puts 'Business center of managers and analysts'
    elsif number == 2
      puts 'SECTOR #2 ACCESS GRANTED'
      puts 'The communications and data storage sector'
    else
      denied
    end
  end

  def fix_communication_error
    puts 'The scientists can`t reach the database with results of previous ' \
    'experiement'
    puts 'Fixing the connection...'
    sleep 10
    puts 'The connection is fixed!'
  end
end

class ScientistLevel < EngineerLevel
  @job = :scientist

  def increase_level
    puts 'Your level of trust is already maximal.'
  end

  def decrease_level
    @context.current_level = @context.level2
    self.job = :engineer
    puts 'The level of trust is decreased to Engineer. Please, work harder ' \
    'to get back the trust.'
  end

  def show_salary
    @context.earned_money += 100_000
    puts 'You`ve got your month revenue to one of your secret bank accounts'
  end

  def get_to_sector(number = 3)
    case number
    when 1 then puts 'SECTOR #1 ACCESS GRANTED (not your regular working ' \
      "place)\nBusiness center of managers and analysts"
    when 2 then puts 'SECTOR #2 ACCESS GRANTED (not your regular working ' \
      "place)\nThe communications and data storage sector"
    when 3 then puts "SECTOR #3 ACCESS GRANTED\nSector of studying the " \
      'properties of dark matter'
    else puts 'There are no sectors with this number'
    end
  end

  def interact_with_matter
    puts 'You`ve started the experiement with antimatter...'
    sleep 5
    puts "\e[33mBOOM!\e[0m The particles of antimatter and matter ' \
    'annihilated  after touch."
  end
end
