class Game < ApplicationRecord
    mount_uploader :image, FileUploader
    has_many :game_events
    belongs_to :user
    after_create_commit :image_upload_to_google_drive
    after_update_commit :image_update_to_google_drive
    after_destroy_commit :image_destroy_to_google_drive
    def image_upload_to_google_drive
        session = session_get()
        if Rails.env.development?
            upload_to_folder = session.file_by_title("GameTriggerUploaders")
                               .file_by_title("GameDevelopmentImage")
            
        else
            upload_to_folder = session.file_by_title("GameTriggerUploaders")
                            .file_by_title("GameProductionImage")
        end
        file_name = image.file.original_filename
        file_ext = File.extname(file_name) #拡張子を取得
        file_find = upload_to_folder.upload_from_file(image.current_path, "game-event-image-#{id}-image#{file_ext}", convert: false)
        update(google_file_id: file_find.id, google_file_url: "https://drive.google.com/uc?id=#{file_find.id}")
    end

    def image_update_to_google_drive
        session = session_get()
        target_file = session.file_by_id(google_file_id)
        target_file.update_from_file(image.current_path)
    end
    
    def image_destroy_to_google_drive
        session = session_get()
        if Rails.env.development?
          upload_to_folder = session.file_by_title("GameTriggerUploaders")
                             .file_by_title("GameDevelopmentImage")
          
        else
          upload_to_folder = session.file_by_title("GameTriggerUploaders")
                             .file_by_title("GameProductionImage")
        end
        session.drive_service.delete_file(google_file_id, supports_all_drives: true)
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
