require 'bundler'
Bundler.require

require_relative 'modules/scrape_utilities'

# require 'capybara'
require 'capybara/poltergeist'
# require 'nokogiri'

class JsScrape
  include ScrapeUtilities
  attr_accessor :ghost

  def initialize(proxy: nil)
    build_ghost(proxy)
  end

  def JsScrape.with_random_proxy
    # JsScrape.new(proxy: {:ip => })
  end

  def page
    @ghost.html
  end

  def goto(path)
    @ghost.visit path
  end

  private

  def build_ghost(proxy)
    if proxy
      GhostMaker.new(phantomjs_options: ["--proxy=#{proxy[:ip]}:#{proxy[:port]}"])
    else
      GhostMaker.new
    end

    @ghost = Capybara::Session.new(:farm_poltergeist)
  end
end

class GhostMaker
  def initialize(proxie_hash: nil, timeout: 120, debug: false,
                 js_errors: false, phantomjs: nil, phantomjs_options: nil)
    options = {timeout: timeout, debug: debug, js_errors: js_errors,
               phantomjs_options: nil}
    options[:phantomjs] = phantomjs if phantomjs

    Capybara.register_driver :farm_poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, options)
    end

  end
end

module Cliver
# This hack is required for Windows.
  class ShellCapture
    def initialize(_command)
      @stderr = ''
      @stdout = '2.1.1'
      @command_found = true
    end
  end
end
