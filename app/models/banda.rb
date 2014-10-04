class Banda < ActiveRecord::Base
	def actualizar_lastfm
		artist = self.nombre
		artist.gsub!(/\s+/,'%20')
  		api_key = 'c0828cbf1521c0c4b7530aaee42ef105'
  		response = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=artist.search&artist=#{artist}&api_key=#{api_key}&limit=1&page=0")
  		data = response.to_s.scan(/"artist"=>\{"name"=>"([^"]+)", "listeners"=>"([0-9]+)"/)
  		listeners = data[0][1].to_i
  		self.lastfm = listeners
		self.save
	end
end
