require_relative '../config/environment'

class CLI
  include IndeedLib::InstanceMethods

  def initialize
    @logo_displayed = 0
  end

  def start
    clear_terminal
    display_logo if @logo_displayed == 0
    puts "Type " + Rainbow("help ").green.bright + "at any time for example input."
    @job_title = get_search_input("job title")
    @job_location = get_search_input("job location")
    Api.set_user_search(@job_title, @job_location)
    puts "Search for #{@job_title} jobs in #{@job_location}."
    puts "A total of #{Api.total_jobs_found} jobs were found."
    puts "Gathering your search results. Est. wait: #{Api.expected_time_to_complete}"
    Api.create_jobs_from_search
  end

  def display_logo
    # ASCII from https://www.asciiart.eu/computers/computers
    flatiron = Rainbow("//").cyan
    puts Rainbow("
          ,---------------------------,
          |  /---------------------\\  |
          | |   #{flatiron}                  | |
          | |     Indeed            | |
          | |      Jobs             | |
          | |       Search          | |
          | |                       | |
          |  \\_____________________/  |
          |___________________________|
        ,---\\_____     []     _______/------,
      /         /______________\\           /|
    /___________________________________ /  | ___
    |                                   |   |    )
    |  _ _ _                 [-------]  |   |   (
    |  o o o                 [-------]  |  /    _)_
    |__________________________________ |/     /  /
    /-------------------------------------/|  ( )/
  /-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/ /
/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/ /
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n").white
    @logo_displayed = 1
  end

  def help
    puts Rainbow("A few helpful examples:").green.bright
    puts "Example job title: Software Engineer\n"
    puts "Example job location: Denver, CO\n"
    puts "Example job location: 80014\n"
    puts "Example job location: NY\n"
    puts "Example job location: Nevada"
    puts "Press any key to continue..."
    STDIN.getch
    clear_terminal
    start
  end

  def get_search_input(search_type)
    print "Please enter a #{search_type}: "
    @user_input = gets.chomp
    validate_input(@user_input)
  end

  def validate_input(user_input)
    help if user_input == 'help'

    if user_input.strip.empty?
      begin
        raise IndeedError
      rescue IndeedError => error
        puts error.empty_message
        start
      end
    elsif user_input.length <= 4
      begin
        raise IndeedError
      rescue IndeedError => input_error
        puts input_error.length_message
        start
      end
    end
    user_input
  end
end

CLI.new.start