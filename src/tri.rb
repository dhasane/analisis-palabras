# nodos del arbol
class Nodito
  def initialize(letter)
    @letter = letter
    @leaf = false
    @children = {}
  end

  # agrega una letra al nivel actual en caso de no existir, y a ese nodo le
  # envia la palabra menos la primera letra, para continuar el proceso hasta la
  # palabra estar vacia
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

  # busca la primera letra de la palabra en los nodos del siguiente nivel
  # y envia la palabra menos la primera letar a este siguiente nivel
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
      @children[contexto[numero_palabra][iter]]
        .find_context(contexto, numero_palabra, iter + 1, palabra)
    elsif !@children[' '].nil? && numero_palabra + 1 < contexto.size
      # palabra actual mas la siguiente
      palabra += contexto[numero_palabra] + ' '
      @children[' '].find_context(contexto, numero_palabra + 1, 0, palabra)
    else
      @leaf ? palabra + contexto[numero_palabra] : ''
    end
  end

  # agrega el nodo a la palabra, en caso de ser hoja, se agrega a las palabras
  # encontradas dentro del arbol
  def reconstruir_palabras_nodo(palabra, palabras)
    palabra += @letter
    palabras << palabra if @leaf
    @children.each do |_key, value|
      value.reconstruir_palabras_nodo(palabra, palabras)
    end
  end

  # imprime el nodo, indentado dependiendo su profundidad, con respecto a la raiz
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

  # se ingesa una palabra al arbol
  def add(word)
    return if word.nil?

    # se crea el nuevo nodo, en caso de que previamente no existiera
    @root[word[0]] = Nodito.new(word[0]) if @root[word[0]].nil?
    @root[word[0]].add(word[1..-1]) unless word[1..-1].empty?
  end

  # reconstuye las palabras dentro del arbol
  def reconstruir_palabras_arbol(palabras)
    @root.each do |_key, value|
      value.reconstruir_palabras_nodo('', palabras)
    end
  end

  # busca una palabra
  def find(palabra)
    return if palabra.nil?

    if !@root[palabra[0]].nil?
      @root[palabra[0]].find(palabra[1..-1])
    else
      false # la primera letra no fue encontrada
    end
  end

  # tiene en cuenta el contexto (las palabras alrededor) al momento
  # de buscar si una palabra se encuentra en el arbol
  # es necesario tener en cuenta el contexto para nombres con mas de una palabra
  def find_context(contexto, numero_palabra)
    return if contexto.nil? || contexto[numero_palabra].nil?

    if !@root[contexto[numero_palabra][0]].nil?
      @root[contexto[numero_palabra][0]]
        .find_context(contexto, numero_palabra, 1, '')
    else
      # false # la primera letra no fue encontrada
      ''
    end
  end

  # imprime los nodos del arbol
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
  # aqui se deberia encontrar el 'que mas'

  str.split(' ').each_index do |i|
    puts tri.find_context(str, i)
  end
end

# representa un conjunto de arboles de decision
class Bosquesito
  # para contener la informacion nombre - contenido(arbol)
  Contenedor = Struct.new(:nombre, :contenido)

  def initialize(tam_contexto)
    # representa las categorias sobre las que se buscara
    @arboles = []
    # la cantidad de palabras para tomar de contexto
    @t_contexto = tam_contexto
    @contexto = Array.new(tam_contexto * 2 + 1) { {} }
  end

  # agrega un elemento, el cual tiene:
  # contenido, que es el arbol en si
  # y un nombre, que sirve como identificador
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

  # falta realizar varios saltos para evitar volver a contar una palabra
  # consigue las palabras dentro de un texto que hagan match con las
  # palabras en alguno de los arboles
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

  # reconstruye las palabras que se encuentran dentro de todos los arboles
  # con fines de poder comprobar que se haya guardado correctamente
  def reconstruir_palabras
    palabras = []
    @arboles.each do |tree|
      tree.contenido.reconstruir_palabras_arbol(palabras)
    end
    palabras
  end

  # imprime las palabras encontradas como 'contexto'
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

  # agrega una palabra a una columna especifica del contexto
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
