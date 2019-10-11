# require 'barby'
# require 'barby/barcode/code_128'
# require 'barby/outputter/html_outputter'

module FoodsHelper
  def html_upc(food)
    Barby::Code128B.new(food.upc).to_html(:class_name => 'upc-barcode').html_safe
  end
end
