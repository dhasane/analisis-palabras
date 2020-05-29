require_relative 'arbol_trie.rb'

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
  def agregar_arbol(nombre, datos, relacion)
    tree = ArbolTrie.new

    datos.zip(relacion) do |val, rel|
      tree.agregar(val, rel)
    end

    cc = Contenedor.new
    cc.contenido = tree
    cc.nombre = nombre

    @arboles << cc
  end

  # siendo texto una lista de cadenas de texto, se verifica cada una de estas.
  # con relacion a cada uno de los arboles que se hayan construido
  # al final se retorna una lista de hashes, donde cada hash contiene:
  # texto => texto original
  # posibilidades => lista hashes {
  #   tipo => nombre del arbol en el que fue encontrada la palabra
  #   palabra => la palabra encontrada en uno de los arboles
  #   contexto => las palabras que rodean la palabra buscada
  #   relaciones => relaciones encontradas en el arbol
  # }
  def verificar(texto)
    return if texto.nil?

    resultado = []
    texto.each do |relato|
      next if relato.nil?

      resultado << {
        'texto' => relato,
        'posibilidades' => verificar_texto(relato)
      }
    end
    resultado
  end

  def verificar_texto(relato)
    resultado = []
    relato.split('.').each do |parr|
      resultado += verificar_frase(parr)
    end
    resultado
  end

  # cada texto probarlo en cada uno de los arboles
  # para esto se recorre el relato como una lista de palabras, en la que
  # cada palabra es verificada en cada uno de los arboles.
  # En caso de ser encontrada en el arbol, se agrega la informacion
  # conseguida a la lista "resultado". Esta lista es retornada
  def verificar_frase(relato)
    resultado = []
    palabras = relato.split(' ')
    palabras.each_index do |i|
      @arboles.each do |tree|
        # byebug if palabras[i] == "chia"
        # byebug if palabras[i] == "vereda"
        ver = tree.contenido.buscar_contexto(palabras, i, 0 , "")
        next if ver.empty?

        resultado << {
          'tipo' => tree.nombre.to_s,
          'palabra' => ver[:pal].to_s,
          'contexto' => ver_contexto(palabras, ver[:pal].to_s, i),
          'relaciones' => ver[:rel]
        }
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
    pre = contexto[[posicion - @tam_contexto, 0].max..posicion - 1]
    pos = contexto[
      posicion + tam..
      [posicion + @tam_contexto + tam - 1, contexto.size].min
    ]

    # TODO: contexto no se esta usando para nada
    # pre&.each_index { |i| agregar_a_contexto(i, pre[i]) }
    # pos&.each_index { |i| agregar_a_contexto(i + @tam_contexto, pos[i]) }

    # "#{pre} #{frase} #{pos}"
    { 'pre' => pre, 'pos' => pos }
  end
end
