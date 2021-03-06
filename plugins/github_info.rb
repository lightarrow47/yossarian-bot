#  github_info.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that gets information about a user from GitHub.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'json'
require 'open-uri'

require_relative 'yossarian_plugin'

class GitHubInfo < YossarianPlugin
	include Cinch::Plugin

	def usage
		'!gh <user> - Get information about <user> on GitHub. Alias: !github.'
	end

	def match?(cmd)
		cmd =~ /^(!)?(github)|(gh)$/
	end

	match /gh (\w+)/, method: :github_info
	match /github (\w+)/, method: :github_info

	def github_info(m, username)
		url = "https://api.github.com/users/#{URI.encode(username)}"

		begin
			hash = JSON.parse(open(url).read)

			if hash.has_key?('login')
				login = hash['login']
				name = hash['name'] || 'No name given'
				repos = hash['public_repos']
				followers = hash['followers']
				following = hash['following']
				m.reply "#{m.user.nick}: #{login} (#{name}) has #{repos} repositories, #{followers} followers, and is following #{following} people."
			else
				m.reply "#{m.user.nick}: No such user \'#{username}\'."
			end
		rescue
			m.reply "#{m.user.nick}: No such user \'#{username}\' or possible network error."
		end
	end
end
