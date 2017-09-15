module ProxyRoller
  def proxy_roller_data
    unless @proxy_roller_data
      f = F.read(File.expand_path('data/proxy_list.txt', File.dirname(__FILE__))).chomp
      arr = f.each_line.map{ |l| l.chomp }
      @proxy_roller_data = []
      @proxy_roller_data << arr[0..(arr.length / 2 - 1)]
      @proxy_roller_data << arr[(arr.length / 2)..arr.length]
    end

    @proxy_roller_data
  end

  def random_proxy
    index = Random.rand(0..(proxy_roller_data[0].count - 1))
    {:ip => proxy_roller_data[0][index], :port => proxy_roller_data[1][index]}
  end
end
