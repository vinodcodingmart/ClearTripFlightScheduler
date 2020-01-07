class FilePaginate
	attr_accessor :result, :options,:paginated_result,:starting,:ending
	def initialize(result,input_options={})
		@options= input_options
		@result = result
		default_options.merge(validate_options())
	end

	def generate
		@starting = (options[:page]-1) * options[:per_page]
		if options[:offset] && options[:page]>1
			@starting = @starting - options[:offset]
		end
		@ending = @starting + (options[:per_page]-1)
		@paginated_result = result[@starting..@ending]
	end

	def prev_link(filename)
	  prev_page = "-#{options[:page]-2}"
      prev_page= "" if prev_page=="-0"
      prev_link = "#{filename}#{prev_page}.html"
	end

	def next_link(filename)
		"#{filename}-#{options[:page]}.html"
	end

	def is_prev?
		@starting>0
	end

	def is_next?
		(@ending+1) < result.count
	end

	def validate_options()
		available_options = ["page","offset","per_page"]
		@options.delete_if{ |key,v| !(available_options.include? key.to_s) }
	end
	def default_options
		{:page=>1,:per_page=>20}
	end
end
