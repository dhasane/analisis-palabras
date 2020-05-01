#!/usr/bin/env ruby
# coding: utf-8

require 'byebug'

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
     .gsub('á', 'a').gsub('é', 'e').gsub('í', 'i').gsub('ó', 'o')
     .gsub(/[úü]/, 'u')
     .gsub('-', ' ')
     .delete('^a-zñÑA-Z0-9. ')
     .gsub(/\s+/, ' ')
     .gsub(/([a-z])\.([a-z])\./, '\1\2')
  # .gsub('.', " \n ")
  # separarlo de otras posibles palabras, para evitar que las afecte
end

def limpiar(table, eliminar)
  table.map! { |v| normalizar(v) }

  table.delete_if do |val|
    del = val.empty? # si esta vacio, borrar de una
    if !val && !eliminar.empty?
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

# relaciones :
# vereda
# [
#   [ municipio1, departamento1 ]
#   [ municipio2, departamento2 ]
# ]
# municipio
# [
#   [ departamento1 ]
#   [ departamento2 ]
# ]
# departamento
# []

def guardar_csv(original, resultados, nombre)
  CSV.open("#{nombre}.csv", 'wb') do |csv|
    # copia valores anteriores
    mantener = ['id', 'dep_coded', 'mun_coded', 'cp_coded', 'vereda', 'text']
    # inicializa en nill
    headers = original.headers - mantener
    # copia el header
    csv << original.headers

    original[1..-1].zip(resultados).each do |linea_o, linea_r|
      next if linea_o['text'].nil?

      nueva_linea = linea_o

      # para esto debe haber una forma mas eficiente
      headers.each { |h| nueva_linea[h] = nil }
      mantener.each { |m| nueva_linea[m] = linea_o[m] }
      num_ubicacion = 1

      linea_r['posibilidades'].each do |pos|
        if pos['tipo'] == 'vereda'
          pos['relaciones'].each do |relacion|
            nueva_linea["vereda_#{num_ubicacion}"] = pos['palabra']
            nueva_linea["municipio_#{num_ubicacion}"] = relacion[0].to_s
            nueva_linea["departartamento_#{num_ubicacion}"] = relacion[1].to_s
            num_ubicacion += 1
          end
        elsif pos['tipo'] == 'municipio'
          pos['relaciones'].each do |relacion|
            nueva_linea["municipio_#{num_ubicacion}"] = pos['palabra']
            nueva_linea["departamento_#{num_ubicacion}"] = relacion[0].to_s
            num_ubicacion += 1
          end
        elsif pos['tipo'] == 'departamento'
          nueva_linea["departamento_#{num_ubicacion}"] = pos['palabra']
          num_ubicacion += 1
        end
        puts pos['tipo'].to_s + '(' + (num_ubicacion - 1).to_s + ') --> ' + pos['palabra'].to_s + '  ' + pos['relaciones'].to_s
      end
      csv << nueva_linea
      exit
    end
  end
end

def guardar_json(objeto, nombre)
  puts "archivo creado #{nombre}.json"
  File.open("#{nombre}.json", 'w') do |file|
    file.write(objeto.to_json)
  end
end

# imprime los resultados conseguidos de forma que sea facil leerlos
def pretty_print(resultado)
  resultado.each do |res|
    puts 'Texto:'
    puts res['texto']

    res['posibilidades'].each do |posibilidad|
      puts "\n"
      puts "\tPalabra: #{posibilidad['palabra']}"
      puts "\tTipo: #{posibilidad['tipo']}"
      puts "\tContexto: #{posibilidad['contexto']['pre']} |" \
           "#{posibilidad['palabra']}| #{posibilidad['contexto']['pos']}"
      puts "\tRelaciones: #{posibilidad['relaciones']}"
    end
    puts "\n\n"
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

relacion_veredas = []
relacion_municipios = []
relacion_departamento = []


dep.zip(muni) do |d, m|
  relacion_departamento << []
  relacion_municipios << [d]
  relacion_veredas << [m, d]
end

bsq.agregar_arbol('departamento', dep, relacion_departamento) # ninguna
bsq.agregar_arbol('municipio', muni, relacion_municipios) # departamento
bsq.agregar_arbol('vereda', vere, relacion_veredas) # municipio y departamento

verif = bsq.verificar(limpiar_str_array(tabla['text']))

# next
# puts bsq.reconstruir_palabras

# pretty_print(verif)

# guardar_json(verif, 'resultados')
guardar_csv(tabla, verif, 'resultados')

# puts cargar('resultados.csv')

finish = Time.now
puts "demora total : #{finish - start}"
