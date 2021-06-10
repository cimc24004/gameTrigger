class ApplicationController < ActionController::Base
    protect_from_forgery 
    before_action :configure_permitted_parameters, if: :devise_controller? 
    # before_action :get_url
    private

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    end

    # def get_url
    #     credentials = Google::Auth::UserRefreshCredentials.new(
    #         client_id: "847802651997-0svf1uqn4m1nsdq2hj2qmf5h4t5pr5ti.apps.googleusercontent.com",
    #         client_secret: "gAqPpk-j2LUDceXNm19H5Fkr",
    #         scope: [
    #         "https://www.googleapis.com/auth/drive",
    #         "https://spreadsheets.google.com/feeds/",
    #         ],
    #         redirect_uri: "http://localhost:3000")
    #         puts "ここにアクセスしてください---" + credentials.authorization_uri.to_s
    #         credentials.code = params[:code]
    #         credentials.fetch_access_token!
    #         puts "REFRESH TOEKNゲットする---" + credentials.refresh_token.to_s
    #         @session = GoogleDrive.login_with_oauth(credentials.access_token)   
    # end

end
