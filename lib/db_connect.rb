require 'yaml'
DB_CONFIG = YAML::load(File.read('./config/database.yml'))

class DbConnect
  attr_reader :adapter

  def initialize
    @adapter = PG.connect(DB_CONFIG)
  end
end
