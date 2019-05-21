class OauthController < ApplicationController
    def initialize(*)
        super
        
        @CLIENT_ID = ENV['GITHUB_CLIENT_ID']
        @CLIENT_SECRET = ENV['GITHUB_CLIENT_SECRET']

        if @CLIENT_ID.nil? or @CLIENT_SECRET.nil? 
            id_val = (@CLIENT_ID.nil?) ? 'nil' : @CLIENT_ID
            secret_val = (@CLIENT_SECRET.nil?) ? 'nil' : @CLIENT_SECRET
            raise "Missed required environment variables: GITHUB_CLIENT_ID (got #{id_val}) and/or GITHUB_CLIENT_SECRET (got #{secret_val})"
        end

        @github_client = GithubApi.new(@CLIENT_ID, @CLIENT_SECRET)
    end

    def start
        redirect_uri = url_for(action: 'oncode')
        @onclick_url = "https://github.com/login/oauth/authorize?client_id=#{@CLIENT_ID}&redirect_uri=#{redirect_uri}"
    end

    def oncode
        code = request.query_parameters['code']

        if code.nil? 
            return redirect_to(url_for(action: 'start'))
        end

        access_token = @github_client.login_by_code(code)
        
        @user_info = @github_client.get_user
        @repositories = @github_client.get_user_repos()
        
        GithubAccess.new(access_token: access_token, **@user_info).save 
    end
end
