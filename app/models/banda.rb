class Banda < ActiveRecord::Base
	def actualizar_lastfm
		artist = self.nombre #obtenemos nombre de banda
		artist.gsub!(/\s+/,'%20') #reemplazamos espacios por %20 para la URI
  		api_key = 'c0828cbf1521c0c4b7530aaee42ef105'
  		response = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=artist.search&artist=#{artist}&api_key=#{api_key}&limit=1&page=0")
  		data = response.to_s.scan(/"artist"=>\{"name"=>"([^"]+)", "listeners"=>"([0-9]+)"/) #parseamos el response de la API
  		if data[0] != nil #en caso de que no devuelva listeners
  		  listeners = data[0][1].to_i #extraemos el match group que contiene los listeners
  		  self.lastfm = listeners #actualizamos los listeners
		  self.save #actualizamos
		end
	end

	def actualizar_spotify
		artist = self.nombre #obtenemos nombre de banda
    	artist.gsub!(/\s+/,'%20') #reemplazamos espacios por %20 para la URI
    	response = HTTParty.get("https://api.spotify.com/v1/search?query=#{artist}&offset=0&limit=1&type=artist")
    	data = response.to_s.scan(/"popularity"=>([0-9]+)/) #parseamos el response de la API
    	if data[0] != nil #en caso de que no devuelva popularidad
    	   popularity = data[0][0].to_i #extraemos el match group que contiene la popularidad
    	   self.spotify = popularity #actualizamos la polularidad
		   self.save #actualizamos
    	end
    end


end
