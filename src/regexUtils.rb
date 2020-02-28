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
def matchLine( line, re )
  line.match( re ) { 
    |m| return( '\'' + m.captures.join( "','" ) + "\'\n") 
    }
end

#inf.each do |inl|  matchLineOld(inl, VdaRe, of)
#end


mPrefix = {
    'triv':"",
    'en_xlx':"en\s(?:el|(?:l(?:a|o)s?))"
    
}

mFixedW = {
    
    'vereda':"\sveredas?\s",
    'municipio':"\smunicipios?\s",
    
}

mSuffix = {
    'triv': "",
    'next_dot_cap':"([^\.]+\.)",

}


#F

#should create intermediate csv file with id and text only

def preProcessTxt( inPath )
  data = CSV.parse(File.read(inPath.to_s), headers:true )
  writeBuffIdTx= "'id'\t'text'\n"
  writeBuffTx= ''
  
  data['id'].zip data['text'] do | id , d |
    if( ! ( id.nil? || d.nil? ) )
      writeBuffTx +=  d
      #writeBuffIdTx += '"' + id  + '","'+ d + '"' + "\n"
      writeBuffIdTx +=  id  + "\t" + d + "\n"
    else
      writeBuffTx += "---------------NIL--------------\n"
    end
  end
  
  of  = File.open("../../datos/iD_Text.csv", "w")
  of.write( writeBuffIdTx )
  of.close()
  of  = File.open("../../datos/texts", "w")
  of.write( writeBuffTx )
  of.close()
  
end

def process(path , pre , word , suf )
  #create re
  data = CSV.parse( File.read(path.to_s), headers:true  )
  re = mPrefix[pre] + mFixedW[word] + mSuffix[suf]
  writeBuff = "'id','text'\n"

  data['id'].zip data['text'] do | id , d|
    writeBuff += matchLine( d , re )
  end
  puts word
  filename = "../../Processed/process_" + word + ".csv"
 
  of = File.open( filename.to_s , 'w')
  of.write(writeBuff)
  of.close()
end

preProcessTxt( "../../datos/"+ARGV[0]+".csv" )
process('../../datos/iD_Text.csv',mPrefix['en_xlx'], mFixedW['vereda'] ,mSuffix['next_dot_cap'])
