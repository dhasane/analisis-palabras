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
  '(next_dot)'=>"([^\.]+\.)",
  
}


#returns matches as '&&:' separated values string;
def matchLine( line, re )
  line.match( re ) { 
    |m| (m.captures.join( "&&:" ))
    }
end

#returns matchobject
def matchLine2( line, re )
  
  line.match( /#{re}/i ){# Regexp( re , "i" ) ) { 
    |m| ( m )
    }
end

#should create intermediate csv file with id and text only
#returns # of nil/invalid rows
def preProcessTxt( inPath )
  data = CSV.parse(File.read(inPath.to_s), headers:true )
  writeBuffIdTx= "id,text\n"
  writeBuffTx= ''
  nilRows = 0
  data['id'].zip data['text'] do | id , d |
    if( ! ( id.nil? || d.nil? ) )
      d = d.gsub(/"*/,'')
      writeBuffTx +=  d+"\n"
      writeBuffIdTx +=  CSV.generate_line( [id, d ] )
    else
      writeBuffTx += "---------------NIL--------------"
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

#writes id,matches to outputfile with regex 
define_method(:process){
  |path , pre , word , suf |
  #create re
  data = CSV.parse( File.read(path.to_s), headers:true  )
  re = dPrefix[pre] + dWord[word] + dSuffix[suf]
  writeBuff = "id,matches\n"

  data['id'].zip data['text'] do | id , d|
    writeBuff += CSV.generate_line( [ id , matchLine( d , re ) ] )
  end
  puts word
  filename = "../../datos/intermediate/process::" + [pre,word,suf].join(' ') + ".csv"
 
  of = File.open( filename.to_s , 'w')
  of.write(writeBuff)
  of.close()
}

#receives path,prefix, word, suffix codes
#should return dictionary {'id':matchObject} 
define_method(:process2){
  |path , pre , word , suf |
  #create re
  data = CSV.parse( File.read(path.to_s), headers:true )
  re = dPrefix[pre] + dWord[word] + dSuffix[suf]
  matchDic = {}

  data['id'].zip data['text'] do | id , d|
    matchDic[ id ] =  matchLine2( d , re ) 
  end
  matchDic
}



p 'preprocessing'
preProcessTxt( "../../datos/"+ARGV[0]+".csv" )
p 'processing'
process('../../datos/intermediate/iD_Text.csv','en_xlx', 'vereda' ,'(next_dot)')
process('../../datos/intermediate/iD_Text.csv','triv', 'vereda' ,'(next_dot)')

dadic = process2('../../datos/intermediate/iD_Text.csv','triv', 'vereda' ,'(next_dot)')

noMatch = []
i = 0
dadic.each { | k , v |
  v.nil? ? noMatch.push(k) :  (v.size > 2 ?  (puts(v.size) ; i+=1 ) : ''  )
}
puts "no match: #{noMatch.size}", "more than 1 match: #{i}"
