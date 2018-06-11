require_relative 'modules/scrape_utilities'
require 'capybara/poltergeist'

class JsScrape
  include ScrapeUtilities
  attr_accessor :ghost

  def initialize(proxy: false, timeout: 120, phantomjs: nil, debug: false, phantomjs_debug: false, phantomjs_options: nil)
    @proxy = proxy
    @debug = debug
    @options = {timeout: timeout, phantomjs: phantomjs,
                debug: phantomjs_debug, phantomjs_options: phantomjs_options}
    build_ghost
  end

  def page
    @ghost
  end

  def html
    @ghost.html
  end

  def goto(path, retries: 10, sleep_time: nil)
    try_again = 0
    begin
      @ghost.visit path
      sleep sleep_time if sleep_time
      log "Visiting: #{path}" if @debug
    rescue Capybara::Poltergeist::StatusFailError => cap_error
      raise cap_error if try_again == retries
      try_again += 1
      puts "FarmScrape: --- Capybara Timeout #{try_again} of #{retries}"
      puts "#{cap_error.message}\n"
      cap_error.backtrace.each{ |b| puts b }
    end
  end

  def doc
    Nokogiri::HTML(html)
  end

  def reset
    @ghost.driver.quit
    build_ghost
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

  def build_ghost
    if @proxy
      GhostMaker.new({phantomjs_options: ["--proxy=#{proxy[:ip]}:#{proxy[:port]}"]}.merge(@options))
    else
      GhostMaker.new(@options)
    end

    @ghost = Capybara::Session.new(:farm_poltergeist)
  end
end

class GhostMaker
  def initialize(proxy_hash: nil, timeout: 30, debug: false,
                 js_errors: false, phantomjs: nil, phantomjs_options: nil)
    options = {timeout: timeout, debug: debug, js_errors: js_errors,
               phantomjs_options: phantomjs_options}
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
