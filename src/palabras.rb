#!/bin/ruby

require 'csv'
require_relative 'distancias.rb'

# carga los datos de un archivo csv
def cargar(nombre)
  datos = CSV.parse(File.read(nombre.to_s), headers: true)
  datos
end

# imprime la matriz entera, en caso de especificar una columna
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

# para eliminar las tildes y dejar la palabra en minuscula
def normalizar(str)
  str.downcase
     .gsub('á', 'a')
     .gsub('é', 'e')
     .gsub('í', 'i')
     .gsub('ó', 'o')
     .gsub('ú', 'u')
end

input = ARGV
tabla = cargar(input[0])

# de aqui en adelante son pruebas terriblemente desorganizadas

prt(tabla, 'text')
# prt(tabla)

pal1 = 'bventur'
# # pal2 = "buenaventura"
pal2 = 'buenaventura'

# pal1 = 'cotachiacota'
# pal2 = 'xchiaes'

# # puts "#{hamming(pal1,pal2)}"
#
imp(mmat(pal1, pal2))
imp(dist(pal1, pal2))
# imp( dist( pal1, pal1  ) )
puts normalizar('qUé MáS')

# todas las posibles opciones de columnas

# id,
# dep_coded,
# mun_coded,
# cp_coded,
# dep_cambia_a,
# mun_cambia_a,
# cp_cambia_a,
# vereda,
# tipo_ubicacion,
# observaciones_cambio,
# Estado de Verificación,
# Analizado por,
# text,
# vereda_1,
# Dif,
# departamento_1,
# municipio_1,
# centro_poblado_1,
# confirmed_1,
# departamento_2,
# municipio_2,
# centro_poblado_2,
# confirmed_2,
# departamento_3,
# municipio_3,
# centro_poblado_3,
# confirmed_3,
# departamento_4,
# municipio_4,
# centro_poblado_4,
# confirmed_4,
# departamento_5,
# municipio_5,
# centro_poblado_5,
# confirmed_5,
# departamento_6,
# municipio_6,
# centro_poblado_6,
# confirmed_6,
# departamento_7,
# municipio_7,
# centro_poblado_7,
# confirmed_7,
# departamento_8,
# municipio_8,
# centro_poblado_8,
# confirmed_8,
# departamento_9,
# municipio_9,
# centro_poblado_9,
# confirmed_9,
# departamento_10,
# municipio_10,
# centro_poblado_10,
# confirmed_10,
# departamento_11,
# municipio_11,
# centro_poblado_11,
# confirmed_11,
# departamento_12,
# municipio_12,
# centro_poblado_12,
# confirmed_12,
# departamento_13,
# municipio_13,
# centro_poblado_13,
# confirmed_13,
# departamento_14,
# municipio_14,
# centro_poblado_14,
# confirmed_14,
# departamento_15,
# municipio_15,
# centro_poblado_15,
# confirmed_15,
# departamento_16,
# municipio_16,
# centro_poblado_16,
# confirmed_16,
# departamento_17,
# municipio_17,
# centro_poblado_17,
# confirmed_17,
# departamento_18,
# municipio_18,
# centro_poblado_18,
# confirmed_18,
# departamento_19,
# municipio_19,
# centro_poblado_19,
# confirmed_19,
# departamento_20,
# municipio_20,
# centro_poblado_20,
# confirmed_20,
# departamento_21,
# municipio_21,
# centro_poblado_21,
# confirmed_21,
# departamento_22,
# municipio_22,
# centro_poblado_22,
# confirmed_22,
# departamento_23,
# municipio_23,
# centro_poblado_23,
# confirmed_23,
# departamento_24,
# municipio_24,
# centro_poblado_24,
# confirmed_24,
# departamento_25,
# municipio_25,
# centro_poblado_25,
# confirmed_25,
# departamento_26,
# municipio_26,
# centro_poblado_26,
# confirmed_26,
# departamento_27,
# municipio_27,
# centro_poblado_27,
# confirmed_27,
# departamento_28,
# municipio_28,
# centro_poblado_28,
# confirmed_28,
# departamento_29,
# municipio_29,
# centro_poblado_29,
# confirmed_29,
# departamento_30,
# municipio_30,
# centro_poblado_30,
# confirmed_30,
# vereda_2,
# vereda_3,
# vereda_4,
# vereda_5,
# vereda_6,
# vereda_7,
# vereda_8,
# vereda_9,
# vereda_10,
# vereda_11,
# vereda_12,
# vereda_13,
# vereda_14,
# vereda_15,
# comunidad_1,
# comunidad_2,
# puerto_1,
# puerto_2,
# puerto_3,
# puerto_4,
# puerto_5,
# puerto_6,
# rio_1,
# rio_2,
# rio_3,
# rio_4,
# rio_5,
# rio_6,
# rio_7


# puts cargar('analizar.csv')
