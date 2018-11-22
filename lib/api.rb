require 'open-uri'
require 'JSON'
require 'byebug'
require_relative 'job'

class Api
  # Adjust to change delay between API requests
  # Set equal to amount of seconds
  @delay = 2

  def self.set_user_search(user_job_title, user_job_location)
    # Format user input appropriately. URL encode all spaces and commas
    @user_job_title = user_job_title.split(' ').join('%20')
    @user_job_location = user_job_location.gsub(',', '%2C').split(' ').join('%20')

    # The query will return 25 jobs per request. Index 0 will return job listings 1..25
    # See Indeed API doc (paginate results on multiple pages) => http://opensource.indeedeng.io/api-documentation/docs/job-search/
    @job_index = 0
    url = update_url(@job_index)
    parsed_data = parse_url(url)

    # Raise error if request receives an error, likely a bad API key
    raise "#{parsed_data["error"]}" if parsed_data["error"] 

    # Store total amount of job listings found for the user's search query
    @@total_jobs_found = parsed_data['totalResults'].to_i

    # Print estimated completion time to user's console
    expected_time_to_complete
  end

  def self.create_jobs_from_search
    while @job_index < total_jobs_found
      url = update_url(@job_index)
      parsed_data = parse_url(url)

      # parsed_data['results'] contains a hash for each job listing (25 per API query)
      parsed_data['results'].each do |job_hash|
        job_hash.each do |job_attr, value|
          Job.new(job_hash['jobtitle']) if job_attr == 'jobtitle'
        end
      end
      # Increment our index by 25 to return jobs 26..50 after the iteration
      @job_index += 25
      puts "Gathered #{@job_index}/#{@@total_jobs_found}"
      sleep(@delay)
    end
  end

  def self.total_jobs_found
    @@total_jobs_found
  end

  def self.expected_time_to_complete
    # Total Jobs / 25 returns the amount of iterations needed to collect all jobs
    # Multiplied by our sleep duration gives an estimated time for completion of job creation
    @@expected_time_to_complete = (@@total_jobs_found.to_f / 25.to_f).ceil * @delay
    Time.at(@@expected_time_to_complete).utc.strftime("%H:%M:%S")
  end

  private
    def self.update_url(updated_job_index)
      @job_index = updated_job_index
      url = "http://api.indeed.com/ads/apisearch?publisher=#{read_api_key}&q=#{@user_job_title}&l=#{@user_job_location}&latlong=1&co=us&v=2&limit=25&format=json&start=#{@job_index}"
    end

    def self.parse_url(api_url)
      unparsed_data = open(api_url + "&start=0").read
      parsed_data = JSON.parse(unparsed_data)
    end

    def self.read_api_key
      # Read API key from file
      # gitignore api.txt to keep key private
      @@api_key = File.open('../api.txt', 'r').read
    end
end
