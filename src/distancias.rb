
# encontrar la distancia de hamming entre dos palabras
def hamming(pal1, pal2)
  i = 0
  rep = 0
  while i < pal1.length && i < pal2.length
    if pal1[i] == pal2[i] && rep += 1
    end
    i += 1
  end
  rep
end

def equivalente_a_palabra(pal1, pal2)
  len = (pal1.length - pal2.length).abs + 1
  if pal1.length < pal2.length
    corta = pal1
    larga = pal2
  else
    corta = pal2
    larga = pal1
  end
  mat = Array.new(len) { Array.new(corta.length, 0) }
  (0..len - 1).each do |x|
    (0..corta.length - 1).each do |y|
      mat[x][y] = larga[y + x]
    end
  end
  mat
end
# experimento para encontrar substrings
def dist(pal1, pal2)
  len = (pal1.length - pal2.length).abs + 1
  if pal1.length < pal2.length
    corta = pal1
    larga = pal2
  else
    corta = pal2
    larga = pal1
  end
  mat = Array.new(len) { Array.new(corta.length, 0) }
  (0..len - 1).each do |x|
    (0..corta.length - 1).each do |y|
      # usar next por recomendacion del linter para hacerlo "mas legible"
      # corta[y] != larga[y + x] ? next : ()
      next if corta[y] != larga[y + x]

      if y > 0
        mat[x][y] = mat[x][y - 1]
      end
      mat[x][y] += 1
    end
  end
  mat
end

# imprime la matriz de manera organizada
def imp(mat)
  mat.each { |reg| print "#{reg}\n" }
end
