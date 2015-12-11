class User < ActiveRecord::Base
	attr_accessor :password, :password_confirmation, :email, :user
	before_save :encrypt_password
	
	has_many :posts

	validates :email, uniqueness: true
	validates :password, length: { minimum: 3 }, if: -> { new_record? || changes["password"] }
	validates :password, confirmation: true, if: -> { new_record? || changes["password"] }
	validates :name, :email, :password, :password_confirmation, presence: true

	def self.authenticate(email, password)
		user = find_by_email(email)
		if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
			user
		else
			nil
		end
	end

	def encrypt_password
		if password.present?
			self.password_salt = BCrypt::Engine.generate_salt
			self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
		end
	end

	def self.search(query)
		where("name like ? OR email like ?", "%#{query}%", "%#{query}%")
	end
end