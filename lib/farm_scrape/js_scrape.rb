require_relative 'modules/scrape_utilities'
require 'capybara/poltergeist'

class JsScrape
  include ScrapeUtilities
  attr_accessor :ghost

  def initialize(proxy: false, timeout: 120, phantomjs: nil, debug: false, phantom_debug: false)
    @debug = debug
    build_ghost(random_proxy, :options => {:timeout => timeout, :phantomjs => phantomjs, debug: phantom_debug})
  end

  def page
    @ghost
  end

  def html
    @ghost.html
  end

  def goto(path, retries: 10)
    try_again = 0
    begin
      @ghost.visit path
      log "Visiting: #{path}" if @debug
    rescue Capybara::Poltergeist::StatusFailError => cap_error
      raise cap_error if try_again == retries
      try_again += 1
      puts "FarmScrape: --- Capybara Timeout #{try_again} of #{retries}"
    end
  end

  def doc
    Nokogiri::HTML(html)
  end

  #--- Aliases ---

  def cap
    page
  end

  def noko
    doc
  end

  private

  def log(msg)
    puts "FarmScrape: #{msg}"
  end

  def build_ghost(proxy, options: {})
    if proxy
      GhostMaker.new({phantomjs_options: ["--proxy=#{proxy[:ip]}:#{proxy[:port]}"]}.merge(options))
    else
      GhostMaker.new(options)
    end

    @ghost = Capybara::Session.new(:farm_poltergeist)
  end
end

class GhostMaker
  def initialize(proxy_hash: nil, timeout: 30, debug: false,
                 js_errors: false, phantomjs: nil, phantomjs_options: nil)
    options = {timeout: timeout, debug: debug, js_errors: js_errors,
               phantomjs_options: nil}
    options[:phantomjs] = phantomjs if phantomjs

    Capybara.register_driver :farm_poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, options)
    end

  end
end

# module Cliver
# # This hack is required for Windows.
#   class ShellCapture
#     def initialize(_command)
#       @stderr = ''
#       @stdout = '2.1.1'
#       @command_found = true
#     end
#   end
# end
