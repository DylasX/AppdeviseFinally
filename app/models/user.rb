class User < ActiveRecord::Base
  rolify
  has_many :books
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and
  devise :database_authenticatable, :registerable,  :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable

       validates_presence_of :username
       validates_uniqueness_of :username
       attr_accessor :current_password


       def self.from_omniauth(auth)
         where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
           if auth.provider=="twitter"
           user.provider = auth.provider
           user.uid = auth.uid
           user.username = auth.info.nickname
          # if auth.info.email == nil
          #   email2 = auth.info.name
          #   user.email = email2.gsub(" ","") + "@twitter.com"
          # end
          #  elsif auth.info.email

          # user.email = auth.info.email
         elsif auth.provider=="facebook"
           user.provider = auth.provider
           user.uid = auth.uid
           user.username = auth.info.name
           #if auth.info.email == nil
          #   email1 = auth.info.name
          #   user.email = email1.gsub(" ","") + "@facebook.com"
          # end
          #elsif auth.info.email

           #user.email = auth.info.email

           user.oauth_token = auth.credentials.token
           user.oauth_expires_at = Time.at(auth.credentials.expires_at)
         end
         end
      end

      def self.new_with_session(params, session)
       if session["devise.user_attributes"]
         new(session["devise.user_attributes"], without_protection:true) do |user|
             user.attributes = params
             user.valid?
       end
       else
         super
       end
   end

   def update_with_password(params, *options)
       if encrypted_password.blank?
         update_attributes(params, *options)
       else
         super
       end
  end

   def password_required?

     super && provider.blank?

   end

   def email_required?

     super && provider.blank?

   end

end
