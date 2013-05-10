class EmailValidator < ActiveModel::EachValidator
  EMAIL_FORMAT = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  def validate_each(record, attribute, value)
    unless value.to_s =~ EMAIL_FORMAT
      record.errors[attribute] << (
        options[:message] ||
          I18n.t("activerecord.errors.email.invalid"))
    end
  end
end
