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
      # puts contexto[numero_palabra][iter]
      @children[contexto[numero_palabra][iter]]
        .find_context(contexto, numero_palabra, iter + 1, palabra)
    elsif !@children[' '].nil? && numero_palabra + 1 < contexto.size
      # palabra actual mas la siguiente
      palabra += contexto[numero_palabra] + ' '
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

  # se ingesa una palabra normalizada al arbol
  # se supone no esta vacia
  def add(word)
    return if word.nil?

    # se crea el nuevo nodo, en caso de que previamente no existiera
    @root[word[0]] = Nodito.new(word[0]) if @root[word[0]].nil?
    @root[word[0]].add(word[1..-1]) unless word[1..-1].empty?
  end

  def find(palabra)
    return if palabra.nil?

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

    # puts contexto[numero_palabra]
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
end

def test_arbol
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

# representa un conjunto de arboles de decision
class Bosquesito
  Contenedor = Struct.new(:nombre, :contenido)
  def initialize(tam_contexto)
    # representa las categorias sobre las que se buscara
    @arboles = []
    # la cantidad de palabras para tomar de contexto
    @t_contexto = tam_contexto
    @contexto = Array.new(tam_contexto * 2 + 1) { {} }
  end

  def agregar_arbol(nombre, datos)
    tree = Arbolito.new
    datos.each do |val|
      tree.add(val)
    end

    cc = Contenedor.new
    cc.contenido = tree
    cc.nombre = nombre

    @arboles << cc
  end


  # Info = Struct.new(:nombre,:)
  # falta realizar varios saltos para evitar volver a contar una palabra
  def verificar(text)
    return if text.nil?

    text.each do |relato|
      next if relato.nil?

      found = false
      # cada palabra probarla en todos los arboles
      palabras = normalizar(relato).split(' ')
      palabras.each_index do |i|
        # info = Contenedor.new
        @arboles.each do |tree|
          ver = tree.contenido.find_context(palabras, i)
          puts tree.nombre.to_s + '  ' + ver.to_s unless ver.empty?
          puts ver_contexto(palabras, ver.to_s, i) unless ver.empty?
          found ||= !ver.empty?
        end
      end
      puts
      puts relato + "\n--------------" if found
      puts '----------------------------------------------'
    end

    # prt_contexto
  end

  def prt_contexto
    i = 0
    # @contexto[1]['hola'] = 5
    @contexto.each do |columna|
      puts "#{i}------------------------------------"
      columna.sort_by(&:last).each do |palabra, cantidad|
        puts "#{palabra}: #{cantidad}"
      end
      i += 1
      puts "\n\n\n\n"
    end
  end

  def agregar_a_contexto(columna, palabra)
    # puts columna
    @contexto[columna][palabra] = 0 if @contexto[columna][palabra].nil?
    @contexto[columna][palabra] += 1
  end

  # siendo contexto, una lista de palabras, frase lo que se tendra en cuenta y
  # entorno la cantidad de palabras alrededor de frase
  def ver_contexto(contexto, frase, posicion)
    # puts '----------------------------------------------'
    tam = frase.split(' ').size
    pre = contexto[posicion - @t_contexto..posicion - 1]
    pre.each_index do |i|
      # @contexto[i][pre[i]] = 0 if @contexto[i][pre[i]].nil?
      # @contexto[i][pre[i]] += 1
      agregar_a_contexto(i, pre[i])
    end
    pos = contexto[posicion + tam..posicion + @t_contexto + tam]
    pos.each_index do |i|
      # @contexto[i + @t_contexto][pos[i]] = 0 if @contexto[i + @t_contexto][pos[i]].nil?
      # @contexto[i + @t_contexto][pos[i]] += 1
      agregar_a_contexto(i + @t_contexto, pos[i])
    end
    "#{pre} #{frase} #{pos}"
  end


end
