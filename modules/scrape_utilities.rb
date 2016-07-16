require_relative 'proxy_roller'

module ScrapeUtilities
  include ProxyRoller

  def clean_records!(path)
    json = JSON.parse(F.read(path))

    dup_hash = {}
    dup_array = ['name']
    dup_array.each do |attr|
      dup_hash[attr] = []
    end

    final_json = json.to_a

    json.each do |r|
      dup_array.each do |attr|
        final_json = final_json.delete_if{ |record| record[attr] == r[attr]} if dup_hash[attr].include?(r[attr])
        dup_hash[attr] << r[attr]
      end
    end

    count = final_json.count

    F.write(path, final_json.to_json)

    count
  end

  def add_missing_attributes!(path, attributes, save_file = true)
    json = JSON.parse(F.read(path))
    json.each do |r|
      attributes.each do |attr|
        unless r.key?(attr)
          r[attr] = ""
        end
      end
    end
    F.write("#{path}", json.to_json) if save_file
  end



  def log_to_file(msg)
    f = File.open('log.log', 'a')
    f.write(msg)
    f.close
  end

  def wait_until
    #expects block
    while true
      sleep 1
      return if yield
    end
  end



end

public
