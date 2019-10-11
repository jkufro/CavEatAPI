Swagger::Docs::Config.register_apis({
  "1.0" => {
    # the extension used for the API
    :api_extension_type => :json,
    # the output location where your .json files are written to
    :api_file_path => "public/",
    # the URL base path to your API
    :base_path => "/",
    # if you want to delete all .json files at each generation
    :clean_directory => false,
    # Ability to setup base controller for each api version. Api::V1::SomeController for example.
    :parent_controller => Api::V1::ApiController,
    # add custom attributes to api-docs
    :attributes => {
      :info => {
        "title" => "CavEat API Swagger Documentation",
        "description" => "This is the official documentation for the CavEat API.",
        # "termsOfServiceUrl" => "http://helloreverb.com/terms/",
        "contact" => "jkufro@andrew.cmu.edu",
        "license" => "Apache 2.0",
        "licenseUrl" => "http://www.apache.org/licenses/LICENSE-2.0.html"
      }
    }
  }
})
