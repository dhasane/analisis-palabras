#!/bin/ruby

require 'csv'

require_relative 'tri.rb'

# carga los datos de un archivo csv
def cargar(nombre)
  CSV.parse(File.read(nombre.to_s), headers: true)
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
