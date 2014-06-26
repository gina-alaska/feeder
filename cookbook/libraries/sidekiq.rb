module Puffin
	module Sidekiq
		def node_sidekiq_queues
			tags = node['tags'].select{|t| t =~ /^sidekiq/ }
			tags = %w{sidekiq-default-1} if tags.empty?

			tags.collect{|t| t.split("-")[1..2]}
		end

		#TODO:  This should search for the redis server unless in chef solo
		def redis_url
			node['puffin']['redis']['url']
		end

		#TODO:  This should search for the redis server unless in chef solo
		def redis_namespace
			node['puffin']['redis']['namespace']
		end
	end
end
