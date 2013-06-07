class Lunchbot
	attr_accessor :group, :restaurants

	Member = Struct.new(:name)
	Restaurant = Struct.new(:name, :description, :location)

	def initialize
		mcDonalds = Restaurant.new("McDonalds", "McDickerson, Cheap burgers.", "200 Front St W")
		subway = Restaurant.new("Subway", "Good subs!", "2 287 King St W")
		burritoBoyz = Restaurant.new("Burrito Boyz", "Serve awesome burritos, but really busy.", "218 Adelaide St W")
		smokespoutinerie = Restaurant.new("Smoke's Poutinerie", "You can find all sorts of poutine!", "218 Adelaide St W")
		banhmiboys = Restaurant.new("Banh Mi Boys", "Has amazing fusion Asian sandwiches.", "392 Queen St W")
		village = Restaurant.new("Village by the Grange", "Food court with cheap, but decent food", "53 McCaul St")
		@restaurants = [] << mcDonalds << subway << burritoBoyz <<smokespoutinerie << banhmiboys << village
		@group = []
	end

	def join(name)
		mem = Member.new(name)
		group << mem
	end

	#returns list of group names
	def group_names
		names = []
		group.each do |mem|
			names << mem.name
		end
		names
	end
end