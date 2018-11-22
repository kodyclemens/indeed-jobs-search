require 'byebug'

class Job
  # Base class
  attr_reader :name, :location

  @@all = []
  def initialize(name, location)
    @name = name
    @location = location
    @@all << self
  end

  def self.all
    @@all
  end
end
