class TreeRefs
  def initialize(refs)
    @navigate=[]
    @tree=Hash.new
    refs.each do |ref|
      if ref[:href].any?
        @tree[ref[:href]]=ref[:level]
      end
    end
  end

    @navigate
  def root

  end
  def add_brenches

  end
  def cut_brences

  end
end