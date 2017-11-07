# ABSTRACT EXPRESSION
require './context'

class Expression
  def initialize context
    @context = context
    set_initial_context
  end

  def interprete
    raise NotImplementedError, 'Please, redeclare this method in a child class, don\'t use the abstract method!'
  end

  private

  def set_initial_context
    unless @context == Context
      Context.current_type = @context.include?('.') || @context.include?('-') ? :mor : :eng
      Context.current_data = @context.split('translate to')[0].chomp(' ')
      @context = Context
    end
  end
end

# CONCRETE COMPOUND EXPRESSION
class TranslaterExpression < Expression
  def initialize context
    super context
    if context.include? 'translate to'
      @interpreter = context[-3..-1].downcase == 'mor' ? MorzeExpression.new(@context) : EngExpression.new(@context)
    else
      raise ArgumentError, 'Please, specify `translate to` expression or use terminal expressions!'
    end
  end

  def interprete
    @interpreter.interprete
  end
end

# CONCRETE TERMINAL EXPRESSIONS
class EngExpression < Expression
  def interprete
    unless @context.current_type == :eng
      str = ''
      @context.current_data.split(' ').each do |sym|
        str += (DICTIONARY.invert[sym] || sym).to_s
      end
      @context.current_type = :eng
      @context.current_data = str
    end
    @context.current_data
  end
end

class MorzeExpression < Expression
  def interprete
    unless @context.current_type == :mor
      str = ''
      @context.current_data.split('').each do |sym|
        str += "#{DICTIONARY[sym.downcase.to_sym] || sym} "
      end
      @context.current_type = :mor
      @context.current_data = str
    end
    @context.current_data
  end
end

# GLOBAL DICTIONARY CONSTANT
DICTIONARY = {
  ' ': ' ',
  a: '.-',
  b: '-...',
  c: '-.-.',
  d: '-..',
  e: '.',
  f: '..-.',
  g: '--.',
  h: '....',
  i: '..',
  j: '.---',
  k: '-.-',
  l: '.-..',
  m: '--',
  n: '-.',
  o: '---',
  p: '.--.',
  q: '--.-',
  r: '.-.',
  s: '...',
  t: '-',
  u: '..-',
  v: '...-',
  x: '-..-',
  y: '-.--',
  z: '--..'
}