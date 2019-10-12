class ApidocsController < ApplicationController
  include Swagger::Blocks

  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'CavEat API Swagger Docs'
      key :description, 'This is the official documentation for the CavEat API.'
      key :termsOfService, ''
      contact do
        key :name, 'CavEat Team'
      end
      license do
        key :name, 'MIT'
      end
    end
    key :host, ''
    key :basePath, '/api'
    key :consumes, ['application/json']
    key :produces, ['application/json']
  end

  # A list of all classes that have swagger_* declarations.
  SWAGGERED_CLASSES = [
    Api::V1::FoodsController,
    self,
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end
