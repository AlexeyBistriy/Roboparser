class TreeRefs
  def initialize

  end


  def root

  end
  def add_brenches
  end
  def cut_brences

  end
  def puts_array_hashes(array)
    array.each do |link|
      puts "=========================================="
      keys=link.keys
      keys.each do |key|
        puts link[key]
      end
    end
  end
end