#!/usr/bin/env ruby

require_relative 'js_scrape'

def test(start)
  s = JsScrape.new(proxy: {:ip => '223.17.105.184', :port => '8088'})
  s.goto 'https://whoer.net/webproxy'

  s.goto base_url
  F.write("tmp/#{start}_#{Time.now.to_i}", s.page)
end

100.times do
  t = []
  10.times do |n|
    t << Thread.new do
      test(10 * n + 1)
    end
  end

  t.each{ |th| th.join }
end

puts 'end'
