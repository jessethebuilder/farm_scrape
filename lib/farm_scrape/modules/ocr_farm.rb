# require 'tesseract'
require 'rtesseract'
require 'mini_magick'

RTesseract.configure do |config|
  config.processor = "mini_magick"
end

class OcrFarm
  
  
  def initialize
    # @engine = Tesseract::Engine.new do |e|
      # e.language = :eng
    # end
  end
  
  def parse(path)
    # @engine.text_for(path).strip
   
  x = RTesseract.new(path).to_s.strip
  x
  end
end