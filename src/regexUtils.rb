#!/bin/ruby
require 'csv'

#test> qué esta en "text"

#f = File.open("../datos/original/Para-ayudar-analizar-Daniela-Sebastian-12-Sep-2019 - Datos.csv")

=begin
datum = cargar( "../../datos/"+ARGV[0]+".csv" )
of  = File.open("../../datos/texts", "w")
writeBuff= ''

datum['id'].zip datum['text'] do | id , d |
  if( d.nil? )
    writeBuff += id + "\t,\t" + "----------------------nil"
  else
    writeBuff += id + "\t,\t" + d
  end
  writeBuff += "\n"
end

of.write( writeBuff )

of.close()

inf = File.open("../../datos/texts")
of = File.open("../../datos/vdaBase","a")

inf.close()
of.close()
=end

VdaRe = %r{
  vereda      #start with vereda
  ([^\.]+     #things that should appear but don't matter (aka context)
  \.)         #ends on next dot
  }x
  
# en l(a|o)s? veredas?([^\.]+\.)



#inf.each do |inl|  matchLineOld(inl, VdaRe, of)
#end


dPrefix = {
  'triv' => "",
  'en_xlx'=>"en\s(?:el|(?:l(?:a|o)s?))"
  
}

dWord = {
  
  'vereda'=>"\sveredas?\s",
  'municipio'=>"\smunicipios?\s",
  
}

dSuffix = {
  'triv'=> "",
  'next_dot_cap'=>"([^\.]+\.)",
  
}


#returns matches as '&&:' separated values string;
def matchLine( line, re )
  line.match( re ) { 
    |m| (m.captures.join( "&&:" ))
    }
end

#should create intermediate csv file with id and text only
#returns # of nil/invalid rows
def preProcessTxt( inPath )
  data = CSV.parse(File.read(inPath.to_s), headers:true )
  writeBuffIdTx= "id\ttext\n"
  writeBuffTx= ''
  nilRows = 0
  data['id'].zip data['text'] do | id , d |
    if( ! ( id.nil? || d.nil? ) )
      writeBuffTx +=  d + "\n"
      #writeBuffIdTx += '"' + id  + '","'+ d + '"' + "\n"
      writeBuffIdTx +=  CSV.generate_line( [id, d ] , :col_sep=>"\t" )
    else
      writeBuffTx += "---------------NIL--------------\n"
      nilRows+=1
    end
  end
  
  of  = File.open("../../datos/intermediate/iD_Text.csv", "w")
  of.write( writeBuffIdTx )
  of.close()
  of  = File.open("../../datos/output/texts.txt", "w")
  of.write( writeBuffTx )
  of.close()
  nilRows
  
end

define_method(:process){
  |path , pre , word , suf |
  #create re
  data = CSV.parse( File.read(path.to_s), headers:true , :col_sep=>"\t" )
  re = dPrefix[pre] + dWord[word] + dSuffix[suf]
  writeBuff = "id\tmatches\n"

  data['id'].zip data['text'] do | id , d|
    writeBuff += CSV.generate_line( [ id , matchLine( d , re ) ] , :col_sep=>"\t"  )
  end
  puts word
  filename = "../../datos/intermediate/process::" + [pre,word,suf].join(' ') + ".csv"
 
  of = File.open( filename.to_s , 'w')
  of.write(writeBuff)
  of.close()
}


p 'preprocessing'
preProcessTxt( "../../datos/"+ARGV[0]+".csv" )
p 'processing'
process('../../datos/iD_Text.csv','en_xlx', 'vereda' ,'next_dot_cap')
