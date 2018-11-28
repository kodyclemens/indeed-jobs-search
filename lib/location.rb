class Location
  attr_reader :name, :job

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
