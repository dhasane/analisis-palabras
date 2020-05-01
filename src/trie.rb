require_relative 'nodo.rb'

# arbolito de palabras ~
class ArbolTrie
  def initialize
    @raiz = {}
  end

  # se ingesa una palabra al arbol
  def agregar(palabra, relacion)
    return if palabra.nil?

    # se crea el nuevo nodo, solo en caso de que previamente no existiera
    @raiz[palabra[0]] = Nodo.new(palabra[0]) if @raiz[palabra[0]].nil?
    @raiz[palabra[0]].agregar(palabra[1..-1], relacion)
  end

  # reconstuye las palabras dentro del arbol
  def reconstruir_palabras_arbol(palabras)
    @raiz.each do |_key, value|
      value.reconstruir_palabras_nodo('', palabras)
    end
  end

  # busca una palabra, retorna true en caso de encontrarla
  # false de lo contrario
  def buscar(palabra)
    return if palabra.nil?

    if !@raiz[palabra[0]].nil?
      @raiz[palabra[0]].buscar(palabra[1..-1])
    else
      false # la primera letra no fue encontrada
    end
  end

  # tiene en cuenta el contexto (las palabras alrededor) al momento
  # de buscar si una palabra se encuentra en el arbol
  # es necesario tener en cuenta el contexto para nombres con mas de una palabra
  # en caso de encontrar la palabra, retorna un hash con la palabra y sus
  # relaciones
  def buscar_contexto(contexto, numero_palabra)
    return if contexto.nil? || contexto[numero_palabra].nil?

    if !@raiz[contexto[numero_palabra][0]].nil?
      @raiz[contexto[numero_palabra][0]]
        .buscar_contexto(contexto, numero_palabra, 1, '')
    else
      {}
    end
  end

  # imprime los nodos del arbol
  def prt
    puts 'letras entre || representan el final de una palabra'
    @raiz.each do |_key, value|
      value.prt(0)
    end
  end
end
