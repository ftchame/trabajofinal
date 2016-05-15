class ApiController < ApplicationController
	skip_before_filter :verify_authenticity_token
	access_token = '2019746130.59a3f2b.86a0135240404ed5b908a14c0a2d9402'
	
	def getTag
		tag = params[:tag]
		token = params[:access_token]
		cantidad = getCount(tag,token)
		post = getPost(tag,token)
		render json: {
							metadata: {
								total: cantidad
								},

							posts: post,
							version: "5" 
							}, status: 200
	end

	def getCount(tag,token)
		headers = {}
		query = Hash.new
		post = HTTParty.get("https://api.instagram.com/v1/tags/#{tag}?access_token=#{token}")
		cantidad = post["data"]["media_count"].to_i
		#render json: {cantidad: cantidad}
		return cantidad
	end

	def getPost(tag,token)
		post = HTTParty.get('https://api.instagram.com/v1/tags/'<<tag.to_s<<'/media/recent'<<'?access_token='<<token.to_s)
		posts = post["data"]
		#render json: {post: post}
		arreglo_aux = []
		posts.each do |p1|
			hash = {
			tags: p1["tags"],
			username: p1["user"]["username"].to_s,
			likes: p1["likes"]["count"].to_i,
			url: p1["images"]["standard_resolution"]["url"].to_s,
			caption: p1["caption"]["text"].to_s 
			}
			arreglo_aux.append(hash)
		end
		return arreglo_aux
	end

end
