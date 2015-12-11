class Comment < ActiveRecord::Base
	belongs_to :post
	validates :name, :email, :body, presence: true
end
