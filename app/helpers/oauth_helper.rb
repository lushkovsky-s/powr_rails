require 'httparty'
require 'pp'

class GithubApi 
    include HTTParty
    base_uri 'https://api.github.com'

    def initialize(client_id, client_secret, access_token=nil)
        @client_id = client_id
        @client_secret = client_secret
        @access_token = access_token
    end

    def login_by_code(code)
        resp = self.class.post('https://github.com/login/oauth/access_token', {
            query: {
                client_id: @client_id,
                client_secret: @client_secret,
                code: code
            }
        })

        if !resp.body.include? 'access_token'
            raise 'Incorrect github API reponse (field "access_token" expected)'
        end

        token = resp.body.match('access_token=([^&]+)\&').captures[0]
        
        @access_token = token

        return token
    end

    def get_user
        if @access_token.nil?
            raise "Method shoud be called only if access_token was specified or after passing login precedure" 
        end

        resp = self.class.get("/user", {
            headers: {
                "Authorization": "token #{@access_token}",
                "User-Agent": "ROR Backend"
            },
            format: :json
        })

        return {
            github_id: resp["id"],
            avatar_url: resp["avatar_url"],
            name: resp["name"],
            location: resp["location"],
            company: resp["company"],
            bio: resp["bio"],
            created_at: resp["created_at"],
            login: resp["login"] 
        }
    end

    def get_user_repos()
        resp = self.class.get("/user/repos", {
            headers: {
                "Authorization": "token #{@access_token}",
                "User-Agent": "ROR Backend"
            },
            format: :json
        })

        return resp.parsed_response
    end
end

module OauthHelper
end
