
require_relative 'nodo.rb'
# arbolito de palabras ~
class ArbolTrie
  def initialize
    @raiz = {}
  end

  # se ingesa una palabra al arbol
  def agregar(palabra)
    return if palabra.nil?

    # se crea el nuevo nodo, en caso de que previamente no existiera
    @raiz[palabra[0]] = Nodo.new(palabra[0]) if @raiz[palabra[0]].nil?
    @raiz[palabra[0]].agregar(palabra[1..-1]) unless palabra[1..-1].empty?
  end

  # reconstuye las palabras dentro del arbol
  def reconstruir_palabras_arbol(palabras)
    @raiz.each do |_key, value|
      value.reconstruir_palabras_nodo('', palabras)
    end
  end

  # busca una palabra
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
  def buscar_contexto(contexto, numero_palabra)
    return if contexto.nil? || contexto[numero_palabra].nil?

    if !@raiz[contexto[numero_palabra][0]].nil?
      @raiz[contexto[numero_palabra][0]]
        .buscar_contexto(contexto, numero_palabra, 1, '')
    else
      # false # la primera letra no fue encontrada
      ''
    end
  end

  # imprime los nodos del arbol
  def prt
    puts 'palabras entre || son finales de palabra'
    @raiz.each do |_key, value|
      value.prt(0)
    end
  end
end

def test_arbol
  tri = ArbolTrie.new
  tri.agregar('holaaa')
  tri.agregar('holae')
  tri.agregar('hilae')
  tri.agregar('que mas')

  str = 'que mas cuenta?'
  # aqui se deberia encontrar el 'que mas'

  str.split(' ').each_index do |i|
    puts tri.buscar_contexto(str, i)
  end
end
