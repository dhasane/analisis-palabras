#!/usr/bin/env ruby

require 'csv'
require 'json'
require 'optparse'

require_relative 'bosque.rb'

# carga los datos de un archivo csv
def cargar(nombre)
  CSV.parse(
    File.read(nombre.to_s),
    headers: true,
    encoding: 'UTF-8'
  )
end

def guardar(nombre, archivo)
  CSV.open("#{nombre}.csv", 'ab') do |csv|
    csv << archivo
  end
end

# imprime la matriz entera (csv), en caso de especificar una columna
# imprimira todos los valores en esa columna
def prt(mat, col = '')
  if !col.empty?
    mat.each do |val|
      puts val[col]
    end
  else
    mat.each do |val|
      puts val
    end
  end
end

# normaliza el texto, haciendo mas facil su busqueda
def normalizar(str)
  str.downcase
     .gsub('á', 'a')
     .gsub('é', 'e')
     .gsub('í', 'i')
     .gsub('ó', 'o')
     .gsub('-', ' ')
     .gsub(/[úü]/, 'u')
     .delete('^a-zñÑA-Z0-9. ')
     .gsub(/\s+/, ' ')
end

def limpiar(table, eliminar)
  table.uniq!.map! { |v| normalizar(v) }

  table.delete_if do |val|
    del = false
    if val.empty?
      del = true
    elsif !eliminar.empty?
      eliminar.each { |elim| del ||= val.include? elim }
    end
    del # || val.match(/[0-9]{3,}/)
  end
  table
end

def limpiar_str_array(str_array)
  str_array.map! do |v|
    normalizar(v) unless v.nil?
  end
  str_array
end

# la complejidad de esto esta un asco, pero deberia servir
def comprobar(texto, lista)
  lista.each do |val|
    val.each do |vv|
      texto.delete_if do |t|
        t == vv
      end
    end
  end
  texto
end

# une todos lo elementos de un arreglo con ', ' y
# rodea el resultado con ""
# def format(cnt)
#   "\"#{cnt.join(', ')}\""
# end

# retorna un string como:
# "palabra, tipo, "pre1,pre2...", "pos1,pos2..." "
# def item_format(posibilidad)
#   format(
#     [
#       posibilidad['palabra'],
#       posibilidad['tipo'],
#       format(posibilidad['contexto']['pre']),
#       format(posibilidad['contexto']['pos'])
#     ]
#   )
# end

def guardar_resultados(resultados)
  CSV.open('resultados.csv', 'wb') do |csv|
    resultados.each do |res|
      next if res.nil?

      pp = [
        "\"#{res['relato']}\"",
        format(res['posibilidades'].map { |posib| item_format(posib) })
      ].join(', ')

      puts pp
      # puts '----------------------------------------------'
      csv << pp
    end
  end
end

i_f = []
i_a = []
OptionParser.new do |opt|
  opt.on('-f', '--file FILENAME') { |o| i_f = o }
  opt.on('-a', '--analize FILENAME') { |o| i_a = o }
end.parse!

start = Time.now

veredas = cargar(i_f)
tabla = cargar(i_a)

bsq = BosqueTrie.new(5)

dep = limpiar(veredas['departamento'], [])
muni = limpiar(veredas['municipio'], [])
vere = limpiar(veredas['vereda'], ['sin definir'])

# guardar('texto', tabla['text'])
# guardar('departamento', dep)
# guardar('municipio', muni)
# guardar('vereda', vere)

bsq.agregar_arbol('departamento', dep)
bsq.agregar_arbol('municipio', muni)
bsq.agregar_arbol('vereda', vere)

# el texto en el cual se buscaran las palabras

# puts bsq.reconstruir_palabras

# puts comprobar(ubicaciones, [dep, muni, vere])

# guardar_resultados(bsq.verificar(limpiar_str_array(tabla['text'])))

File.open('resultados.json', 'w') do |file|
  file.write(bsq.verificar(limpiar_str_array(tabla['text'])).to_json)
end

# puts cargar('resultados.csv')

finish = Time.now
puts "demora total : #{finish - start}"

