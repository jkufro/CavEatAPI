# https://stackoverflow.com/questions/5654517
Dir[File.join(Rails.root, "lib", "core_ext", "*.rb")].each {|l| require l }
