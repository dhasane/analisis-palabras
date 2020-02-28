#!/bin/ruby

require 'csv'
require 'optparse'

require_relative 'distancias.rb'
require_relative 'tri.rb'

# carga los datos de un archivo csv
def cargar(nombre)
  CSV.parse(File.read(nombre.to_s), headers: true)
end

def guardar(nombre, archivo)
  CSV.open("#{nombre}.cvs", 'ab') do |csv|
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
     .gsub(/[úü]/, 'u')
     .delete('^a-zñÑA-Z0-9 ')
     .gsub(/\s+/, ' ')
end

def normalizar_nombre(str)
  normalizar(str)
    .delete('^a-zñÑA-Z ')
end

def limpiar(table, eliminar)
  table = (table.map! { |v| normalizar_nombre(v) }).uniq

  table.delete_if do |val|
    del = false
    if val.empty?
      del = true
    elsif !eliminar.empty?
      eliminar.each { |elim| del ||= val.include? elim }
    end
    del
  end
  table
end

i_f = []
i_a = []
OptionParser.new do |opt|
  # opt.on('-f', '--file FILENAME') { |o| options[:file] = o }
  opt.on('-f', '--file FILENAME') { |o| i_f = o }
  opt.on('-a', '--analize FILENAME') { |o| i_a = o }
end.parse!

# puts i_f
# puts i_a

# input = ARGV

start = Time.now

# esto eventualmente seria chevere ponerlo como opciones decentes
# de lineas de comando a lo: palabras -archivos a1,a2,a3,etc -analisis a1
veredas = cargar(i_f)
tabla = cargar(i_a)


# puts tabla['municipio']
bsq = Bosquesito.new

dep = limpiar(veredas['departamento'], [])
muni = limpiar(veredas['municipio'], [])
vere = limpiar(veredas['vereda'], ['sin definir'])

guardar('departamento', dep)
guardar('municipio', muni)
guardar('vereda', vere)
# puts vere

bsq.agregar_arbol('departamento', dep)
bsq.agregar_arbol('municipio', muni)
bsq.agregar_arbol('vereda', vere)
#
# # el texto en el cual se buscaran las palabras
# bsq.verificar(tabla['text'])
#



finish = Time.now
puts "demora total : #{finish - start}"

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
