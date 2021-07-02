class GameEventOgp < ApplicationRecord
    after_create_commit :ogp_save_google
    after_destroy_commit :destroy_google_drive_file_ogp
    after_update_commit :ogp_update_google
    belongs_to :game_event

    def ogp_save_google
        if ogp_url.present?
            og = OpenGraph.new(URI.encode(ogp_url), false)
            unless og.images.empty?
                unless File.exists?("public/uploads/ogp-images")
                    FileUtils.mkdir_p("public/uploads/ogp-images")
                end
                file = open(og.images[0])
                File.open("public/uploads/ogp-images/ogp-#{self.class.to_s.underscore + id.to_s}.png", "wb") {|f| f.write(file.read)}
                file_wanna_save = "public/uploads/ogp-images/ogp-#{self.class.to_s.underscore + id.to_s}.png"
                create_google_drive_file_ogp(file_wanna_save, id, og.title, og.description)
            else
                update(ogp_google_file_id: nil, ogp_title: og.title, ogp_body: og.description)
            end
        end
    end

    def ogp_update_google
        if saved_change_to_ogp_url?
          if ogp_url.present?
            og = OpenGraph.new(URI.encode(ogp_url), false)
            if ogp_google_file_id.present? && og.images.present?
                session = session_get()
                file = open(og.images[0])
                File.open("public/uploads/ogp-images/ogp-#{self.class.to_s.underscore + id.to_s}.png", "wb") {|f| f.write(file.read)}
                file_wanna_save = "public/uploads/ogp-images/ogp-#{self.class.to_s.underscore + id.to_s}.png"
                target_file = session.file_by_id(ogp_google_file_id)
                target_file.update_from_file(file_wanna_save)
            else
                unless og.images.empty?
                    unless File.exists?("public/uploads/ogp-images")
                        FileUtils.mkdir_p("public/uploads/ogp-images")
                    end
                    file = open(og.images[0])
                    File.open("public/uploads/ogp-images/ogp-#{self.class.to_s.underscore + id.to_s}.png", "wb") {|f| f.write(file.read)}
                    file_wanna_save = "public/uploads/ogp-images/ogp-#{self.class.to_s.underscore + id.to_s}.png"
                    create_google_drive_file_ogp(file_wanna_save, id, og.title, og.description)
                end
            end
            update(ogp_title: og.title, ogp_body: og.description)
          else
            session = session_get()
			session.drive_service.delete_file(ogp_google_file_id, supports_all_drives: true)
            update(ogp_title: nil, ogp_body: nil, ogp_google_file_id: nil, ogp_url: nil)
          end
        end
    end

    def create_google_drive_file_ogp(url, id, title, description)
		if url.present?
			session = session_get()
			if Rails.env.development?
                upload_to_folder = session.file_by_title("GameTriggerUploaders")
                .file_by_title("GameEventOGPImageDevelopment")
			else
                upload_to_folder = session.file_by_title("GameTriggerUploaders")
                .file_by_title("GameEventOGPImageProduction")
            end
	        file_find = upload_to_folder.upload_from_file(url, "ogp-#{self.class.to_s.underscore + id.to_s}", convert: false) 
			update(ogp_google_file_id: file_find.id, ogp_title: title, ogp_body: description)
	    end
	end

    def destroy_google_drive_file_ogp
		if ogp_google_file_id.present?
			session = session_get()
			session.drive_service.delete_file(ogp_google_file_id, supports_all_drives: true)
	  	end
    end
    private
    def session_get
        credentials = Google::Auth::UserRefreshCredentials.new(
          client_id: ENV["DRIVE_CLIENT_ID"],
          client_secret: ENV["DRIVE_CLIENT_SECRET"],
          scope: [
            "https://www.googleapis.com/auth/drive"
          ],
          redirect_uri: ENV["REQUEST_URL"],
          refresh_token: ENV["DRIVE_REFRESH_TOKEN"])
    
          credentials.update!(access_token: credentials.refresh_token)    
    
          credentials.fetch_access_token!
          session = GoogleDrive.login_with_oauth(credentials.access_token)
          return session
      end
end
