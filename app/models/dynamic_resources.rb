module DynamicResources
	def consumes(*resources)
		resources.each{|r| Resource.create_class(r)}
		self.send :include, Resource
	end
end