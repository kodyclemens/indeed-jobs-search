class Location
  # Base class
  attr_accessor :job
  attr_reader :name

  @@all = []
  def initialize(name)
    @name = name
    @job = []
    @@all << self
  end

  def self.all
    @@all
  end

  def job=(job)
    @job << job
  end
end
