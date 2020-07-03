#!/usr/bin/env ruby
# coding: utf-8

# require 'byebug'
require 'csv'
require 'json'
require 'optparse'
require 'pp'

require 'buscador_palabras'

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
# quita todas las mayusculas, convierte lo guiones en espacios
# y borra todos los simbolos que no sean letras, numeros o espacios
# en caso de haber varios espacios seguidos los unifica y quita
# puntos en caso de encontrar palabras como 'a.m.' para dejarlo como 'am'
def normalizar(str)
  return str if str.nil?

  str.downcase
     .gsub(/[Áá]/, 'a')
     .gsub(/[Éé]/, 'e')
     .gsub(/[Íí]/, 'i')
     .gsub(/[Óó]/, 'o')
     .gsub(/[ÚúÜü]/, 'u')
     .gsub('-', ' ')
     .delete('^a-zñÑA-Z0-9. ')
     .gsub(/\s+/, ' ')
     .gsub(/([a-z])\.([a-z])\./, '\1\2')
end

def limpiar(table, eliminar)
  table.map! { |v| normalizar(v) }

  table.delete_if do |val|
    del = val.empty? # si esta vacio, borrar de una
    if !val && !eliminar.empty?
      eliminar.each { |elim| del ||= val.include? elim }
    end
    del
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
    mantener = %w[id dep_coded mun_coded cp_coded vereda text]
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

      linea_r[:posibilidades].each do |pos|
        pos[:relaciones].each do |ubicacion|
          tipo = ubicacion[0]
          info = ubicacion[1..-1]

          # esto posiblemente se puede hacer mucho mas inteligentemente
          if tipo == 'vereda'
            puts info[1].to_s
            nueva_linea["vereda_#{num_ubicacion}"] = pos[:palabra]
            nueva_linea["municipio_#{num_ubicacion}"] = info[0].to_s
            nueva_linea["departamento_#{num_ubicacion}"] = info[1].to_s
            num_ubicacion += 1
          elsif tipo == 'municipio'
            nueva_linea["municipio_#{num_ubicacion}"] = pos['palabra']
            nueva_linea["departamento_#{num_ubicacion}"] = info[0].to_s
            num_ubicacion += 1
          elsif tipo == 'departamento'
            nueva_linea["departamento_#{num_ubicacion}"] = pos['palabra']
            num_ubicacion += 1
          end
        end
      end
      csv << nueva_linea
    end
  end
end

def guardarCSVOtro(origen, buscador, nombre, tam_contexto)
  puts "creando archivo #{nombre}.csv"
  CSV.open("#{nombre}.csv", 'wb') do |csv|
    origen.each do |relato|
      next if relato['text'].nil?

      resultado = buscador.analizar(
        normalizar(relato['text']),
        tam_contexto
      )

      resultado.each do |_llave, posibilidad|

        posibilidad[:relaciones].each do |relacion|
          tipo = relacion[0]
          info = relacion[1..-1]

          departamento = nil
          municipio = nil
          vereda = nil

          if tipo == 'vereda'
            vereda = posibilidad[:palabra]
            municipio = info[0].to_s
            departamento = info[1].to_s
          elsif tipo == 'municipio'
            municipio = posibilidad[:palabra]
            departamento = info[0].to_s
          elsif tipo == 'departamento'
            departamento = posibilidad[:palabra]
          elsif tipo == 'centro poblado'
            centro_poblado = posibilidad[:palabra]
            municipio = info[0].to_s
            departamento = info[1].to_s
          end

          dep_coded = normalizar(relato['dep_coded'])
          mun_coded = normalizar(relato['mun_coded'])
          ver_coded = normalizar(relato['vereda'])
          cp_coded  = normalizar(relato['cp_coded'])

          id,dep_cambia_a,mun_cambia_a,cp_cambia_a,tipo_ubicacion,


          principal = (tipo <=> posibilidad[:contexto][0][:pre][-1]).zero? ? 1 : 0

          csv << [
            relato['id'],
            relato['text'],
            dep_coded,
            mun_coded,
            cp_coded,
            # ver_coded,
            departamento,
            municipio,
            centro_poblado,
            vereda,
            coincidencia(
              [
                [dep_coded, departamento],
                [mun_coded, municipio],
                [cp_coded, centro_poblado],
                # [ver_coded, vereda]

              ]
            ),
            principal
          ]
        end
      end
    end
  end
end

def coincidencia(lista_coincidencias)
  # contador coincidencias
  cc = 0
  lista_coincidencias.each do |c|
    if c[0] == c[1]
      cc += 1
    elsif cc.zero?
      return 'falso'
    else
      return 'parcial'
    end
  end
  'verdadero'
end

def guardar_json(objeto, nombre)
  puts "archivo creado #{nombre}.json"
  File.open("#{nombre}.json", 'w') do |file|
    file.write(objeto.to_json)
  end
end

def cargar_csv_a_buscador(
      buscador,
      dep, muni, vere,
      rel1, rel2, rel3
    )

  relacion_veredas = []
  relacion_municipios = []
  relacion_departamento = []

  dep.zip(muni) do |d, m|
    relacion_departamento << [rel1]
    relacion_municipios << [rel2, d]
    relacion_veredas << [rel3, m, d]
  end

  dep.zip(relacion_departamento) do |val, rel|
    buscador.agregar(val, rel)
  end
  muni.zip(relacion_municipios) do |val, rel|
    buscador.agregar(val, rel)
  end
  vere.zip(relacion_veredas) do |val, rel|
    buscador.agregar(val, rel)
  end
  buscador
end

# i_f = []
i_a = []
output_name = 'resultado'
OptionParser.new do |opt|
  # opt.on('-f', '--file FILENAME') { |o| i_f << o }
  opt.on('-a', '--analize FILENAME') { |o| i_a = o }
  opt.on('-o', '--output FILENAME') { |o| output_name = o }
end.parse!

start = Time.now
buscador = BuscadorPalabras.new

tabla = cargar(i_a)

veredas = cargar('./datos/veredas.csv')
centros_poblados = cargar('./datos/DIVIPOLA_2020627.csv')

buscador = cargar_csv_a_buscador(
  buscador,
  limpiar(veredas['departamento'], []),
  limpiar(veredas['municipio'], []),
  limpiar(veredas['vereda'], ['sin definir']),
  'departamento',
  'municipio',
  'vereda'
)
buscador = cargar_csv_a_buscador(
  buscador,
  limpiar(centros_poblados['Nombre departamento'], []),
  limpiar(centros_poblados['Nombre municipio'], []),
  limpiar(centros_poblados['Nombre centro poblado'], []),
  'departamento',
  'municipio',
  'centro poblado'
)

tam_contexto = 5

# hacer con integracion continua de github las pruebas
#   - action de github - semaphore - travis
guardarCSVOtro(tabla, buscador, output_name, tam_contexto)

finish = Time.now
puts "demora total : #{finish - start}"
