module Resource
  def self.create_class(new_class)
    c = Class.new(OpenStruct) do
      include ActiveModel::Validations
      define_method(:to_model) { self  }
      define_method("persisted?") { self.id.present? }
      define_method("build_errors") do |errors|
        # errors is a Hash: {field_name1: ["error1", "error2"], field_name2: ["error"], field_nameN: ["error"]}
        errors.each_pair do |field, error_keys|
          error_keys = ["required"] if error_keys.include?("required")
          error_keys.each{|error| self.errors.add field, I18n.t("errors.#{error}")}
        end
      end
    end
    class_name = new_class.to_s.classify
      Resource.const_set class_name, c
      klass = "Resource::#{class_name}".constantize
      klass.class_eval "def self.model_name() ActiveModel::Name.new(#{klass}, nil, '#{class_name}') end"
  end
end