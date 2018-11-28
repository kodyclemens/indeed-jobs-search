require_relative 'indeed_lib'

class IndeedError < StandardError
  include IndeedLib::InstanceMethods
  def empty_message
    clear_terminal
    Rainbow("Empty searches are not allowed. Type 'help' for example input.").red.bright
  end

  def length_message
    clear_terminal
    Rainbow("Input must be at least 5 characters long. Type 'help' for example input.").red.bright
  end
end