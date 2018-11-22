require_relative 'api'
require_relative 'job'
require 'byebug'

class CLI
  # Test data for now
  # TODO: Build CLI

  Api.set_user_search('Software Engineer', 'Kansas City, MO')
  puts "A total of #{Api.total_jobs_found} jobs were found."
  puts "Gathering your search results. Est. wait: #{Api.expected_time_to_complete}"
  Api.create_jobs_from_search
end