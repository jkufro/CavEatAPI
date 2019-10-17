require 'uri'

class SourceValidator < ActiveModel::EachValidator
  # Method that validates email address
  def validate_each(record, attribute, value)
    return if !value.present? && options[:allow_blank]
    uri = URI.parse(value)
    record.errors[attribute] << (options[:message] || I18n.t('source.invalid')) unless uri && !uri.host.nil?
  rescue URI::InvalidURIError
    record.errors[attribute] << (options[:message] || I18n.t('source.invalid'))
  end
end
