Phnamefn = Class.new do
    @letter
    @isLeaf 
    @childs

    def initialize(letter, leaf)
        @letter = letter
        @leaf = leaf
        @childs = []
    end

    def addchild(ch)
        @childs<<ch
    end

    def test()
        return @childs
    end

    def childs()
        return @childs
    end
    def letter()
        return @letter
    end

end 


def treeLoader( name )
    inFile = open( name )
end


def populate(root)
    #random.
    ('a'..'h').each do |l|
        newletter = Phnamefn.new(l,false)
        root.addchild( newletter )
    end
end




def dive (root, s)
    s += root.letter
    if root.childs().length > 0
        root.childs().each do |k|
            dive(k, s)
        end
    else
        puts s    
    end
end

#------------------------
#testing area ahead.
#populate method should receive a list and create tree.
#for now tree structure is cute 

groot = Phnamefn.new('',false)
groot.addchild( Phnamefn.new('z',false) )

populate(groot)
groot.childs().each do |n|
    populate(n)
end

puts groot.test()
dive(groot,'-')