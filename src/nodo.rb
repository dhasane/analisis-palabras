# nodos del arbol
class Nodo
  def initialize(letra)
    @letra = letra
    @leaf = false
    @hijos = {}
  end

  # agrega una letra al nivel actual en caso de no existir, y a ese nodo le
  # envia la palabra menos la primera letra, para continuar el proceso hasta la
  # palabra estar vacia
  def agregar(palabra)
    # si es la ultima letra, es final de palabra, sin importar
    # que no sea exactamente una hoja del arbol
    @leaf ||= palabra.empty?

    if !palabra.empty? && @hijos[palabra[0]].nil? # se crea el nuevo nodo
      @hijos[palabra[0]] = Nodo.new(palabra[0])
    end

    # va al siguiente, excepto si la palabra - 1 esta vacia
    @hijos[palabra[0]].agregar(palabra[1..-1]) unless palabra.empty?
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

  # es necesario tener en cuenta el contexto para
  # nombres con mas de una palabra
  def buscar_contexto(contexto, numero_palabra, iter, palabra)
    if !@hijos[contexto[numero_palabra][iter]].nil?
      @hijos[contexto[numero_palabra][iter]]
        .buscar_contexto(contexto, numero_palabra, iter + 1, palabra)
    elsif !@hijos[' '].nil? && numero_palabra + 1 < contexto.size
      # palabra actual mas la siguiente
      palabra += contexto[numero_palabra] + ' '
      @hijos[' '].buscar_contexto(contexto, numero_palabra + 1, 0, palabra)
    else
      @leaf ? palabra + contexto[numero_palabra] : ''
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
