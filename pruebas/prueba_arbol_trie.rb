#!/usr/bin/env ruby
# coding: utf-8

# Autor inicial: Vladimir Támara Patiño <vtamara@pasosdeJesus.org>:   https://github.com/dhasane/analisis-palabras/commit/3055a69fad020f180a1beb6cb33a19d7a3138eb6

require 'minitest/autorun'
require_relative '../src/arbol_trie'

class PruebaArbolTrie < Minitest::Test
  def setup
  end

  def test_vacio
    # Ninguna letra en nodo inicial y sin hijos?
    nodo = ArbolTrie.new
    assert_equal true, nodo.verificar_consistencia
    nodo.imp
    assert_equal false, nodo.buscar('x')
    assert_equal({},  nodo.buscar_contexto(['x'], 0, 0, ''))
    assert_equal false, nodo.buscar('')
    assert_equal({},  nodo.buscar_contexto([''], 0, 0, ''))
    palabras = []
    nodo.reconstruir_palabras_nodo('', palabras)
    assert_equal([], palabras)
  end

  def test_cadena_vacia
    nodo = ArbolTrie.new
    # Una vez
    nodo.agregar('', 1)
    assert_equal true, nodo.verificar_consistencia
    nodo.imp
    assert_equal false, nodo.buscar('x')
    assert_equal({},  nodo.buscar_contexto(['x'], 0, 0, ''))
    assert_equal true, nodo.buscar('')
    assert_equal({pal: '', rel: [1]},  nodo.buscar_contexto([''], 0, 0, ''))
    palabras = []
    nodo.reconstruir_palabras_nodo('', palabras)
    assert_equal([''], palabras)

    # Sin redundar 
    nodo.agregar('', 1)
    assert_equal true, nodo.verificar_consistencia
    nodo.imp
    assert_equal false, nodo.buscar('x')
    assert_equal({},  nodo.buscar_contexto(['x'], 0, 0, ''))
    assert_equal true, nodo.buscar('')
    assert_equal({pal: '', rel: [1]},  nodo.buscar_contexto([''], 0, 0, ''))

    # Dos veces
    nodo.agregar('', 2)
    assert_equal true, nodo.verificar_consistencia
    nodo.imp
    assert_equal false, nodo.buscar('x')
    assert_equal({},  nodo.buscar_contexto(['x'], 0, 0, ''))
    assert_equal true, nodo.buscar('')
    assert_equal({pal: '', rel: [1, 2]},  nodo.buscar_contexto([''], 0, 0, ''))

  end


  def test_una_cadena_l1
    nodo = ArbolTrie.new
    # Una vez
    nodo.agregar('a', 1)
    assert_equal true, nodo.verificar_consistencia
    nodo.imp
    assert_equal false, nodo.buscar('')
    assert_equal true, nodo.buscar('a')
    assert_equal({pal: 'a', rel: [1]},  
                 nodo.buscar_contexto(['a'], 0, 0, ''))
    assert_equal false, nodo.buscar('aa')
    assert_equal false, nodo.buscar('b')
    assert_equal({},
                 nodo.buscar_contexto(['aa'], 0, 0, ''))
    assert_equal({pal: 'a', rel: [1]},  
                 nodo.buscar_contexto(['b','a','c'], 1, 0, ''))
    palabras = []
    nodo.reconstruir_palabras_nodo('', palabras)
    assert_equal(['a'], palabras)
 
    # Sin redundar 
    nodo.agregar('a', 1)
    assert_equal true, nodo.verificar_consistencia
    nodo.imp
    assert_equal false, nodo.buscar('')
    assert_equal true, nodo.buscar('a')
    assert_equal({pal: 'a', rel: [1]},  
                 nodo.buscar_contexto(['a'], 0, 0, ''))
    assert_equal false, nodo.buscar('aa')
    assert_equal false, nodo.buscar('b')
    assert_equal({},
                 nodo.buscar_contexto(['aa'], 0, 0, ''))
    assert_equal({pal: 'a', rel: [1]},  
                 nodo.buscar_contexto(['b','a','c'], 1, 0, ''))
    palabras = []
    nodo.reconstruir_palabras_nodo('', palabras)
    assert_equal(['a'], palabras)
 
    # Dos veces
    nodo.agregar('a', 2)
    assert_equal true, nodo.verificar_consistencia
    nodo.imp
    assert_equal false, nodo.buscar('')
    assert_equal true, nodo.buscar('a')
    assert_equal({pal: 'a', rel: [1, 2]},  
                 nodo.buscar_contexto(['a'], 0, 0, ''))
    assert_equal false, nodo.buscar('aa')
    assert_equal false, nodo.buscar('b')
    assert_equal({},
                 nodo.buscar_contexto(['aa'], 0, 0, ''))
    assert_equal({pal: 'a', rel: [1, 2]},  
                 nodo.buscar_contexto(['b','a','c'], 1, 0, ''))
    palabras = []
    nodo.reconstruir_palabras_nodo('', palabras)
    assert_equal(['a'], palabras)
 
  end

  def test_una_cadena_l2
    nodo = ArbolTrie.new
    # Una vez
    nodo.agregar('aa', 1)
    assert_equal true, nodo.verificar_consistencia
    nodo.imp
    assert_equal false, nodo.buscar('')
    assert_equal false, nodo.buscar('a')
    assert_equal true, nodo.buscar('aa')
    assert_equal false, nodo.buscar('aaa')
    assert_equal({pal: 'aa', rel: [1]},  
                 nodo.buscar_contexto(['aa'], 0, 0, ''))
    assert_equal({},
                 nodo.buscar_contexto(['a'], 0, 0, ''))
    palabras = []
    nodo.reconstruir_palabras_nodo('', palabras)
    assert_equal(['aa'], palabras)

    # Sin redundar
    nodo.agregar('aa', 1)
    assert_equal true, nodo.verificar_consistencia
    nodo.imp
    assert_equal false, nodo.buscar('')
    assert_equal false, nodo.buscar('a')
    assert_equal true, nodo.buscar('aa')
    assert_equal false, nodo.buscar('aaa')
    assert_equal({pal: 'aa', rel: [1]},  
                 nodo.buscar_contexto(['aa'], 0, 0, ''))
    assert_equal({},
                 nodo.buscar_contexto(['a'], 0, 0, ''))
    palabras = []
    nodo.reconstruir_palabras_nodo('', palabras)
    assert_equal(['aa'], palabras)

    # Dos veces
    nodo.agregar('aa', 2)
    assert_equal true, nodo.verificar_consistencia
    nodo.imp
    assert_equal false, nodo.buscar('')
    assert_equal false, nodo.buscar('a')
    assert_equal true, nodo.buscar('aa')
    assert_equal false, nodo.buscar('aaa')
    assert_equal({pal: 'aa', rel: [1, 2]},  
                 nodo.buscar_contexto(['aa'], 0, 0, ''))
    assert_equal({},
                 nodo.buscar_contexto(['a'], 0, 0, ''))
    palabras = []
    nodo.reconstruir_palabras_nodo('', palabras)
    assert_equal(['aa'], palabras)
  end


  def test_dos_cadenas_l1_prefijo0
    nodo = ArbolTrie.new
    nodo.agregar('a', 1)
    nodo.agregar('b', 4)
    assert_equal true, nodo.verificar_consistencia
    nodo.imp
    assert_equal false, nodo.buscar('')
    assert_equal true, nodo.buscar('a')
    assert_equal true, nodo.buscar('b')
    assert_equal false, nodo.buscar('x')
    assert_equal({pal: 'a', rel: [1]},  
                 nodo.buscar_contexto(['a'], 0, 0, ''))
    assert_equal({},
                 nodo.buscar_contexto(['aa'], 0, 0, ''))
    assert_equal({pal: 'b', rel: [4]},  
                 nodo.buscar_contexto(['b'], 0, 0, ''))
    assert_equal({},
                 nodo.buscar_contexto(['c'], 0, 0, ''))
    palabras = []
    nodo.reconstruir_palabras_nodo('', palabras)
    assert_equal(['a', 'b'], palabras)

    # Sin redundar
    nodo.agregar('a', 1)
    assert_equal true, nodo.verificar_consistencia
    assert_equal true, nodo.buscar('a')
    assert_equal({pal: 'a', rel: [1]},  
                 nodo.buscar_contexto(['a'], 0, 0, ''))
    assert_equal({pal: 'b', rel: [4]},  
                 nodo.buscar_contexto(['b'], 0, 0, ''))
    palabras = []
    nodo.reconstruir_palabras_nodo('', palabras)
    assert_equal(['a', 'b'], palabras)

    # Dos veces
    nodo.agregar('a', 2)
    assert_equal true, nodo.verificar_consistencia
    nodo.imp
    assert_equal false, nodo.buscar('')
    assert_equal true, nodo.buscar('a')
    assert_equal false, nodo.buscar('aa')
    assert_equal true, nodo.buscar('b')
    assert_equal({pal: 'a', rel: [1, 2]},  
                 nodo.buscar_contexto(['a'], 0, 0, ''))
    assert_equal({pal: 'b', rel: [4]},  
                 nodo.buscar_contexto(['b'], 0, 0, ''))
    palabras = []
    nodo.reconstruir_palabras_nodo('', palabras)
    assert_equal(['a', 'b'], palabras)
  end

  def test_una_cadena_l1_y_una_cadena_l2_prefijo0
    nodo = ArbolTrie.new
    nodo.agregar('a', 1)
    nodo.agregar('bb', 2)
    assert_equal true, nodo.verificar_consistencia
    nodo.imp
    assert_equal false, nodo.buscar('')
    assert_equal true, nodo.buscar('a')
    assert_equal true, nodo.buscar('bb')
    assert_equal false, nodo.buscar('c')
    assert_equal({pal: 'a', rel: [1]},  
                 nodo.buscar_contexto(['a'], 0, 0, ''))
    assert_equal({},
                 nodo.buscar_contexto(['aa'], 0, 0, ''))
    assert_equal({pal: 'bb', rel: [2]},  
                 nodo.buscar_contexto(['bb'], 0, 0, ''))
    assert_equal({},
                 nodo.buscar_contexto(['c'], 0, 0, ''))
    palabras = []
    nodo.reconstruir_palabras_nodo('', palabras)
    assert_equal(['a', 'bb'], palabras)
  end

  def test_dos_cadenas_l2_prefijo0
    nodo = ArbolTrie.new
    nodo.agregar('aa', 1)
    nodo.agregar('bb', 2)
    assert_equal true, nodo.verificar_consistencia
    nodo.imp
    assert_equal false, nodo.buscar('')
    assert_equal false, nodo.buscar('a')
    assert_equal false, nodo.buscar('b')
    assert_equal true, nodo.buscar('aa')
    assert_equal true, nodo.buscar('bb')
    assert_equal false, nodo.buscar('c')
    assert_equal({pal: 'aa', rel: [1]},  
                 nodo.buscar_contexto(['aa'], 0, 0, ''))
    assert_equal({},
                 nodo.buscar_contexto(['ab'], 0, 0, ''))
    assert_equal({pal: 'bb', rel: [2]},  
                 nodo.buscar_contexto(['bb'], 0, 0, ''))
    assert_equal({},
                 nodo.buscar_contexto(['ba'], 0, 0, ''))
    palabras = []
    nodo.reconstruir_palabras_nodo('', palabras)
    assert_equal(['aa', 'bb'], palabras)
  end

  def test_una_cadena_l0_una_cadena_l1_prefijo1
    nodo = ArbolTrie.new
    nodo.agregar('', 1)
    nodo.agregar('a', 2)
    assert_equal true, nodo.verificar_consistencia
    assert_equal true, nodo.buscar('')
    assert_equal true, nodo.buscar('a')
    assert_equal({pal: '', rel: [1]},  
                 nodo.buscar_contexto([''], 0, 0, ''))
    assert_equal({pal: 'a', rel: [2]},  
                 nodo.buscar_contexto(['a'], 0, 0, ''))
 
  end
 
   def test_una_cadena_l1_una_cadena_l2_prefijo1
    nodo = ArbolTrie.new
    nodo.agregar('a', 1)
    nodo.agregar('ab', 2)
    assert_equal true, nodo.verificar_consistencia
    assert_equal false, nodo.buscar('')
    assert_equal true, nodo.buscar('a')
    assert_equal true, nodo.buscar('ab')
    assert_equal({},  
                 nodo.buscar_contexto([''], 0, 0, ''))
    assert_equal({pal: 'a', rel: [1]},  
                 nodo.buscar_contexto(['a'], 0, 0, ''))
    assert_equal({pal: 'ab', rel: [2]},  
                 nodo.buscar_contexto(['ab'], 0, 0, ''))
    assert_equal({},  
                 nodo.buscar_contexto(['abc'], 0, 0, ''))
  end
 
  def test_una_cadena_l3_una_cadena_l3_espacio1_prefijo1
    nodo = ArbolTrie.new
    nodo.agregar('aaa', 1)
    nodo.agregar('aa a', 2)
    assert_equal true, nodo.verificar_consistencia
    assert_equal false, nodo.buscar('a')
    assert_equal false, nodo.buscar('aa')
    assert_equal true, nodo.buscar('aaa')
    assert_equal true, nodo.buscar('aa a')
    assert_equal({},  
                 nodo.buscar_contexto(['aa'], 0, 0, ''))
    assert_equal({pal: 'aaa', rel: [1]},  
                 nodo.buscar_contexto(['aaa'], 0, 0, ''))
    assert_equal({pal: 'aa a', rel: [2]},  
                 nodo.buscar_contexto(['aa','a'], 0, 0, ''))
    assert_equal({pal: 'aa a', rel: [2]},  
                 nodo.buscar_contexto(['', 'aa','a'], 1, 0, ''))
    assert_equal({pal: 'aa a', rel: [2]},  
                 nodo.buscar_contexto(['aa a', 'aa','a'], 0, 0, ''))
  end
 
end
