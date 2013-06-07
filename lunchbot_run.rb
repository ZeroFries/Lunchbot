class IRCBot
	require "socket"
	require_relative "lunchbot"

	#returns user nick name from IRC msg
	def name_parse(msg)
		x = msg.index("!")
		msg[1,x-1]
	end

	def list_group(bot)
		group = bot.group
	end

	def random_restaurant(bot)
		bot.restaurants.sample
	end


	def initialize
		server = "chat.freenode.net"
		port = "6667"
		nick = "LunchBot"
		channel = "#lunchbot"
		join_command = "lunchbot join"
		leave_command = "lunchbot leave"
		list_member_command = "lunchbot group"
		list_rests_command = "lunchbot places"
		go_command = "lunchbot go"
		intro_msg = "Welcome to the amazing Lunchbot! Not sure what to eat? Join by typing '#{join_command}' and we'll decide for you!"
		msg_counter = 20
		msg_prefix = "PRIVMSG #{channel} :"

		s = TCPSocket.open(server, port)
		s.puts "USER LunchBot 0 * LunchBot"
		s.puts "NICK #{nick}"
		s.puts "JOIN #{channel}"
		lb = Lunchbot.new

		s.puts msg_prefix + intro_msg

		until s.eof? 
			msg = s.gets
			puts msg

			#exits and closes the TCO connection
			if msg.include?("lunchbot exit")
				s.puts "QUIT Leavin!"
				s.closes
			end

			if msg.include?(msg_prefix)

			#repeats intro msg every 20 msgs to IRC
			msg_counter -= 1
			if msg_counter<=0
				s.puts msg_prefix + intro_msg
				msg_counter = 15
			end

				#joining lunchbot group
				if msg.include?(join_command)
					name = name_parse(msg)
					if lb.group_names.include?(name)
						s.puts msg_prefix + "#{name} has already joined"
					else
						lb.join(name)
						s.puts msg_prefix + "#{name} has joined Lunchbot! Type '#{list_member_command}' to list all members, '#{list_rests_command}' to list all restaurants, or '#{go_command}' to decide where to go"
					end

				#listing all group members
				elsif msg.include?(list_member_command)
					lb.group_names.each_with_index do |mem, i|
						s.puts "#{msg_prefix} [#{i+1}] #{mem}"
					end

				#final command to go to a place
				elsif msg.include?(go_command)
					name = name_parse(msg)
					if lb.group_names.include?(name)
						restaurant = random_restaurant(lb)
						output_string = lb.group_names.join(', ')
						s.puts msg_prefix + output_string + ": you guys are going to #{restaurant.name}. Bon appetit!"
						s.puts msg_prefix + "Restaurant description: " + restaurant.description
						s.puts msg_prefix + "Located at: " + restaurant.location
					elsif
						s.puts msg_prefix + "#{name}, join the group if you want to go to lunch!"
					end

				#leaving lunchbot group
				elsif msg.include?(leave_command)
					name = name_parse(msg)
					if lb.group_names.include?(name)
						lb.leave(name)
						s.puts msg_prefix + "#{name}, you are removed from the group."
					else
						s.puts msg_prefix + "#{name}, you aren't in the group."
					end	

				#listing restaurants
				elsif msg.include?(list_rests_command)
					lb.rest_names.each_with_index do |mem, i|
						s.puts "#{msg_prefix} [#{i+1}] #{mem}"
					end
						
				end
			end

		end

		s.puts "PART" #exits channel
	end
end

IRCBot.new


