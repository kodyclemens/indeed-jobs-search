require_relative '../config/environment'

class CLI
  def start
    print 'Please enter a job title: '
    user_job_title = gets.chomp
    print 'Please enter a location: '
    user_location = gets.chomp
    Api.set_user_search(user_job_title.to_s, user_location.to_s)
    puts "A total of #{Api.total_jobs_found} jobs were found."
    puts "Gathering your search results. Est. wait: #{Api.expected_time_to_complete}"
    Api.create_jobs_from_search
  end
end

CLI.new.start