require 'mechanize'

class MachineScrape
  attr_accessor :mech

  def initialize
    @mech = Mechanize.new
  end

  def parse(url)
    @mech.get(url)
  end
end
