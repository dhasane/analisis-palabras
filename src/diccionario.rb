
require_relative 'arbol_trie.rb'

# arbolito de palabras ~
class Diccionario
  def initialize(tam)
    @trie = ArbolTrie.new
    @tam_contexto = tam
  end

  # se ingesa una palabra al arbol
  def agregar(palabra, relacion)
    return if palabra.nil?

    @trie.agregar(palabra, relacion)
  end

  # reconstruye las palabras que se encuentran dentro de todos los arboles
  # con fines de poder comprobar que se haya guardado correctamente
  def reconstruir_palabras
    palabras = []
    @trie.reconstruir_palabras_nodo('', palabras)
    palabras
  end

  def trie
    @trie
  end

  # busca una palabra, retorna true en caso de encontrarla
  # false de lo contrario
  def buscar(palabra)
    return if palabra.nil?

    @trie.buscar(palabra)
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
        texto: relato,
        posibilidades: verificar_texto(relato)
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
  def verificar_frase(contexto)
    return if contexto.nil?

    resultado = []
    palabras = contexto.split(' ')
    palabras.each_index do |i|
      respuesta = @trie.buscar_contexto(palabras, i, 0, '')
      next if respuesta.empty?

      resultado << {
        palabra: respuesta[:pal].to_s,
        contexto: ver_contexto(palabras, respuesta[:pal].to_s, i),
        relaciones: respuesta[:rel]
      }
    end
    resultado
  end

  # imprime los nodos del arbol
  def prt
    puts 'letras entre || representan el final de una palabra'
    @trie.prt(0)
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
    { pre: pre, pos: pos }
  end
end
