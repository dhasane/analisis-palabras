require_relative 'trie.rb'

# representa un conjunto de arboles de decision
class BosqueTrie
  # para contener la informacion nombre - contenido(arbol)
  Contenedor = Struct.new(:nombre, :contenido)

  def initialize(tam_contexto)
    # representa las categorias sobre las que se buscara
    @arboles = []
    # la cantidad de palabras para tomar de contexto
    @tam_contexto = tam_contexto
    @contexto = Array.new(tam_contexto * 2) { {} }
  end

  # agrega un elemento, el cual tiene:
  # contenido, que es el arbol en si
  # y un nombre, que sirve como identificador
  def agregar_arbol(nombre, datos)
    tree = ArbolTrie.new
    datos.each do |val|
      tree.agregar(val)
    end

    cc = Contenedor.new
    cc.contenido = tree
    cc.nombre = nombre

    @arboles << cc
  end

  # falta realizar varios saltos para evitar volver a contar una palabra
  # consigue las palabras dentro de un texto que hagan match con las
  # palabras en alguno de los arboles
  def verificar(texto)
    return if texto.nil?

    resultado = []

    texto.each do |relato|
      next if relato.nil?

      resultado_relato = {}

      # puts '----------------------------------------------'
      # puts relato
      resultado_relato['texto'] = relato
      # puts

      next if relato.nil?

      resultado_relato['posibilidades'] = verificar_frase(relato)
      resultado << resultado_relato
      next

      parrafo = relato.split('.')
      puts parrafo
      parrafo.each do |parr|
        puts parr
        verificar_frase(parr)
      end
    end
    resultado
    # prt_contexto
  end

  # cada palabra probarla en todos los arboles
  def verificar_frase(relato)
    resultado = []
    palabras = relato.split(' ')
    palabras.each_index do |i|
      @arboles.each do |tree|
        ver = tree.contenido.buscar_contexto(palabras, i)

        next if ver.empty?

        posibilidad = {}
        posibilidad['tipo'] = tree.nombre.to_s
        posibilidad['palabra'] = ver.to_s
        contexto = ver_contexto(palabras, ver.to_s, i)
        posibilidad['contexto'] = contexto

        resultado << posibilidad
      end
    end
    resultado
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
    @contexto[columna][palabra] = 0 if @contexto[columna][palabra].nil?
    @contexto[columna][palabra] += 1
  end

  # siendo contexto, una lista de palabras, frase lo que se tendra en cuenta y
  # entorno la cantidad de palabras alrededor de frase
  def ver_contexto(contexto, frase, posicion)
    tam = frase.split(' ').size
    pre = contexto[posicion - @tam_contexto..posicion - 1]
    pre.each_index do |i|
      agregar_a_contexto(i, pre[i])
    end
    pos = contexto[posicion + tam..posicion + @tam_contexto + tam - 1]
    pos.each_index do |i|
      agregar_a_contexto(i + @tam_contexto, pos[i])
    end
    # "#{pre} #{frase} #{pos}"
    ctx = {}
    ctx['pre'] = pre
    ctx['pos'] = pos
    # "#{pre} #{pos}"
    ctx
  end
end
