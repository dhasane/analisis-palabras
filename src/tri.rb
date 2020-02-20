

# nodos del arbol
class Nodito
  def initialize(letter, leaf)
    @letter = letter
    @leaf = leaf
    @children = {}
  end

  def add(palabra)
    puts palabra
    # para encontrar el caso de que un nodo intermedio
    # pueda ser final de palabra
    palabra.size == 1 ? (final = true) : (final = false)

    if @children[palabra[0]].nil? # se crea el nuevo nodo
      @children[palabra[0]] = Nodito.new(palabra[0], final)
    end
    unless palabra[1..-1].empty?
      @children[palabra[0]].add(palabra[1..-1])
    end
  end

  def attr_reader_letter
    @letter
  end

  def attr_reader_children
    @children
  end

  def find(palabra)
    if !@children[palabra[0]].nil?
      @children[palabra[0]].find(palabra[1..-1])
    else
      @leaf
    end
  end
end

# arbolito de palabras ~
class Arbolito
  def initialize
    @root = {}
  end

  # se ingesa la palabra al arbol
  # se supone no esta vacia
  def addchild(word)
    puts word
    if @root[word[0]].nil? # se crea el nuevo
      @root[word[0]] = Nodito.new(word[0], false)
    end
    unless word[1..-1].empty?
      @root[word[0]].add(word[1..-1])
    end
  end

  def find(palabra)
    if !@root[palabra[0]].nil?
      @root[palabra[0]].find(palabra[1..-1])
    else
      false # esto significaria que una palabra de una sola letra fue encontrada
    end
  end
end

hola = "holaaaaaa"
tri = Arbolito.new

tri.addchild(hola)
puts tri.find(hola)
puts tri.find('kiubo')


# puts hola[1..-1]
