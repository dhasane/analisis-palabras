# nodos del arbol
class Nodito
  # def initialize(letter, leaf)
  def initialize(letter)
    @letter = letter
    @leaf = false
    @children = {}
  end

  def attr_reader_letter
    @letter
  end

  def attr_reader_children
    @children
  end

  def add(palabra)
    # si es la ultima letra, es final de palabra, sin importar
    # que no sea exactamente una hoja del arbol
    @leaf ||= palabra.empty?

    if !palabra.empty? && @children[palabra[0]].nil? # se crea el nuevo nodo
      @children[palabra[0]] = Nodito.new(palabra[0])
    end

    # va al siguiente, excepto si la palabra - 1 esta vacia
    @children[palabra[0]].add(palabra[1..-1]) unless palabra.empty?
  end

  def find(palabra)
    if !@children[palabra[0]].nil?
      @children[palabra[0]].find(palabra[1..-1])
    else
      @leaf # es la ultima letra de esta palabra el final de una palabra?
    end
  end

  # es necesario tener en cuenta el contexto para
  # nombres con mas de una palabra
  def find_context(contexto, numero_palabra, iter, palabra)
    if !@children[contexto[numero_palabra][iter]].nil?
      # puts '\'' + contexto[numero_palabra][iter] + '\''
      @children[contexto[numero_palabra][iter]]
        .find_context(contexto, numero_palabra, iter + 1, palabra)
    elsif !@children[' '].nil? && numero_palabra + 1 < contexto.size
      # palabra actual mas la siguiente
      palabra += contexto[numero_palabra]
      @children[' '].find_context(contexto, numero_palabra + 1, 0, palabra)
    else
      # es la ultima letra de esta palabra el final de una palabra?
      @leaf ? palabra + contexto[numero_palabra] : ''
    end
  end

  def prt(profundidad)
    bar = @leaf ? '|' : '' # representa final de palabras
    puts profundidad.to_s + "\t" + '-' * profundidad + bar + @letter.to_s + bar
    @children.each do |_key, value|
      value.prt(profundidad + 1)
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
  def add(word)
    return if word.nil?

    word = normalizar(word)
    # se crea el nuevo nodo, en caso de que previamente no existiera
    @root[word[0]] = Nodito.new(word[0]) if @root[word[0]].nil?
    @root[word[0]].add(word[1..-1]) unless word[1..-1].empty?
  end

  def find(palabra)
    return if palabra.nil?

    palabra = normalizar(palabra)
    if !@root[palabra[0]].nil?
      @root[palabra[0]].find(palabra[1..-1])
    else
      false # la primera letra no fue encontrada
    end
  end

  # es necesario tener en cuenta el contexto para
  # nombres con mas de una palabra
  def find_context(contexto, numero_palabra)
    return if contexto.nil? || contexto[numero_palabra].nil?

    contexto = normalizar(contexto).split(' ')
    if !@root[contexto[numero_palabra][0]].nil?
      # puts contexto[numero_palabra][0]
      @root[contexto[numero_palabra][0]]
        .find_context(contexto, numero_palabra, 1, '')
    else
      # false # la primera letra no fue encontrada
      ''
    end
  end

  def prt
    puts 'palabras entre || son finales de palabra'
    @root.each do |_key, value|
      value.prt(0)
    end
  end

  # para eliminar las tildes y dejar la palabra en minuscula
  # def normalizar(str)
  #   str.downcase
  #      .gsub('á', 'a')
  #      .gsub('é', 'e')
  #      .gsub('í', 'i')
  #      .gsub('ó', 'o')
  #      .gsub('\[úü\]', 'u')
  #      .gsub('\[,.\]', '')
  # end
end

def test
  tri = Arbolito.new
  tri.add('holaaa')
  tri.add('holae')
  tri.add('hilae')
  tri.add('que mas')

  str = 'que mas cuenta?'

  str.split(' ').each_index do |i|
    puts tri.find_context(str, i)
  end
end

# test
