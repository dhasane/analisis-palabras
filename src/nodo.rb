# nodos del arbol
class Nodo
  def initialize(letra)
    @letra = letra
    @leaf = false
    @hijos = {}
    @relacion = []
  end

  # agrega una letra al nivel actual en caso de no existir, y a ese nodo le
  # envia la palabra menos la primera letra, para continuar el proceso hasta la
  # palabra estar vacia
  def agregar(palabra, relacion)
    # si es la ultima letra, es final de palabra, sin importar
    # que no sea exactamente una hoja del arbol
    if palabra.empty?
      @leaf = true
      # en caso de ser hoja, se agrega la relacion
      @relacion << relacion
    else
      # se crea el nuevo nodo con la siguiente letra
      @hijos[palabra[0]] = Nodo.new(palabra[0]) if @hijos[palabra[0]].nil?
      # va al siguiente nodo
      @hijos[palabra[0]].agregar(palabra[1..-1], relacion)
    end
  end

  # busca la primera letra de la palabra en los nodos del siguiente nivel
  # y envia la palabra menos la primera letar a este siguiente nivel
  def buscar(palabra)
    if !@hijos[palabra[0]].nil?
      @hijos[palabra[0]].buscar(palabra[1..-1])
    else
      @leaf # es la ultima letra de esta palabra el final de una palabra?
    end
  end

  # esta funcion tiene en cuenta el contexto de una palabra, para
  # poder encontrar cadenas de varias palabras que esten dentro del diccionario
  # en el texto
  # contexto es la lista de todas las palabras de un texto
  # numero palabra es la palabra que se esta buscando dentro del contexto
  # iter es la posicion en la palabra (la letra)
  # palabra es el resultado total que ha sido encontrado
  def buscar_contexto(contexto, numero_palabra, iter, palabra)
    if !@hijos[contexto[numero_palabra][iter]].nil?
      @hijos[contexto[numero_palabra][iter]]
        .buscar_contexto(contexto, numero_palabra, iter + 1, palabra)

      # que se encuentre espacio entre los posibles hijos del nodo actual
      # y que haya una palabra siguiente en el contexto
    elsif !@hijos[' '].nil? && numero_palabra + 1 < contexto.size
      # palabra actual mas la siguiente
      palabra += contexto[numero_palabra] + ' '
      @hijos[' '].buscar_contexto(contexto, numero_palabra + 1, 0, palabra)

      # si no se cumplio ninguna de las anteriores, significa que no hay nada
      # mas para analizar. Compara con el tamano de la ultima palabra, si
      # iter y esta palabra son iguales, significa que lo que fue encontrado
      # esta en el diccionario
    elsif iter == contexto[numero_palabra].length
      @leaf ? palabra + contexto[numero_palabra] : ''
    else
      ''
    end
  end

  # agrega el nodo a la palabra, en caso de ser hoja, se agrega a las palabras
  # encontradas dentro del arbol
  def reconstruir_palabras_nodo(palabra, palabras)
    palabra += @letra
    palabras << palabra if @leaf
    @hijos.each do |_key, valor|
      valor.reconstruir_palabras_nodo(palabra, palabras)
    end
  end

  # imprime el nodo, indentado dependiendo su profundidad,
  # con respecto a la raiz
  def prt(profundidad)
    bar = @leaf ? '|' : '' # representa final de palabras
    puts profundidad.to_s + "\t" + '-' * profundidad + bar + @letra.to_s + bar
    @hijos.each do |_key, value|
      value.prt(profundidad + 1)
    end
  end
end
