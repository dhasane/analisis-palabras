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

def mmat(pal1, pal2)
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
      # if x > 0
      #   mat[x][y] = mat[x-1][y]
      # end
      if corta[y] == larga[ y + x ]
        if y > 0
          mat[x][y] = mat[x][y - 1]
        end
        mat[x][y] += 1
      end
    end
  end
  mat
end

def imp(mat)
  # mat.each { |reg| print reg.each{ |val| print "#{val} " }, "\n" }
  # puts "matriz : "
  mat.each { |reg| print "#{reg}\n" }
  # puts "#{mat}"
  #   (0..mat.length-1).each do |x|
  #       (0..mat[x].length-1).each do |y|
  #         print "#{mat[x][y]} "
  #     end
  #     puts
  # end
end
