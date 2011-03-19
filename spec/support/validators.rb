RSpec::Matchers.instance_eval do
  define :validate_presence_of do |attribute|
    match do |model|
      model.send("#{attribute}=", nil)
      !model.valid? and model.errors[attribute].any?
    end

    description { "model to validate presence of #{attribute}" }
    failure_message_for_should { "model should validate presence of #{attribute}" }
    failure_message_for_should_not { "model should not validate presence of #{attribute}" }
  end

  define :validate_uniqueness_of do |attribute|
    match do |model|
      fake_model = Factory.create model.class.to_s.underscore, attribute.to_sym => model.send(attribute)
      !model.valid? and model.errors[attribute].any?
    end

    description { "model to validate uniqueness of #{attribute}" }
    failure_message_for_should { "model should validate uniqueness of #{attribute}" }
    failure_message_for_should_not { "model should not validate uniqueness of #{attribute}" }
  end

  define :validate_length_of do |name, options|
    match do |model|
      result = true
      unless options[:is].blank?
        _name = (model.send name.to_sym).to_s

        model.send "#{name}=", "#{_name}1"
        result = !model.valid? and model.errors[name].any?

        model.send "#{name}=", _name[0..-2]
        result &&= !model.valid? and model.errors[name].any?
      end

      unless options[:minimum].blank?
        _min = options[:minimum].to_i - 1
        _name = (model.send name.to_sym).to_s
        _name = (_min < 0) ? "" : _name[0.._min]

        model.send "#{name}=", _name
        result &&= !model.valid? and model.errors[name].any?
      end
      
      unless options[:maximum].blank?
        _max = options[:maximum].to_i + 1
        _name = "a" * _max

        model.send "#{name}=", _name
        result &&= !model.valid? and model.errors[name].any?
      end

      result
    end
    description { "model to validate length of #{name}" }
    failure_message_for_should { "model should validate length of #{name}" }
    failure_message_for_should_not { "model should not validate length of #{name}" }
  end

  define :validate_numericality_of do |name, options|
    match do |model|
      result = false
      unless options[:less_than].blank?

        _value = options[:less_than]
        _name = (model.send name.to_sym)

        model.send "#{name}=", _value
        result ||= !model.valid? and model.errors[name].any?
      end

      unless options[:greater_than_or_equal_to].blank?
        _value = options[:greater_than_or_equal_to]
        _name = (model.send name.to_sym)

        model.send "#{name}=", _value - 1
        result ||= !model.valid? and model.errors[name].any?
      end
      result
    end
    description { "model to validate length of #{name}" }
    failure_message_for_should { "model should validate length of #{name}" }
    failure_message_for_should_not { "model should not validate length of #{name}" }
  end

  define :validate_confirmation_of do |attribute|
    match do |model|
      model.send("#{attribute}=", '1234abcd')
      !model.valid? and model.errors[attribute].any?
    end

    description { "model to validate confirmation of #{attribute}" }
    failure_message_for_should { "model should validate confirmation of #{attribute}" }
    failure_message_for_should_not { "model should not validate confirmation of #{attribute}" }
  end

  define :validate_inclusion_of do |attribute, options|
    match do |model|
      inv_result = false # Inverted result - false if everything is ok

      options[:in].each do |val|
        model.send("#{attribute}=", val)
        inv_result ||= !model.valid?
      end

      model.send("#{attribute}=", rand.to_s)
      inv_result ||= model.valid?

      !inv_result
    end

    description { "model to validate inclusion of #{attribute} in #{options[:in].inspect}" }
    failure_message_for_should { "model should validate inclusion of #{attribute} in #{options[:in].inspect}" }
    failure_message_for_should_not { "model should not validate inclusion of #{attribute} in #{options[:in].inspect}" }
  end

end
