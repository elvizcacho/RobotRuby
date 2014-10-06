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
		  self.save #actualizamos la banda
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
		  self.save #actualizamos la banda
    end
  end

  def actualizar_likes
    artist = self.nombre #obtenemos nombre de banda
    response = HTTParty.get("https://graph.facebook.com/oauth/access_token?client_id=313760365477283&client_secret=b0eb3610944a84a9db9088678965b9c6&grant_type=client_credentials") #resquest del token
    token = response.scan(/access_token=(.+)/) 
    token = token[0] != nil ? token[0][0] : nil #obtenemos el token para poder usar la API
    limit = 1
    likes = nil
    while (likes == nil && limit < 5) #Si Facebook no nos da acceso buscamos en el siguiente resutado
      url = "https://graph.facebook.com/search?q=#{artist}&type=page&" + URI.escape("access_token=#{token}&limit=#{limit}") # parseamos la URL ya que el token contiene un pipe que hace que la URL sea invalida
      response = HTTParty.get(url) #buscamos artista
      id = response.scan(/"id":"(\d+)"/) #parseamos el id de la fan page.
      id = id[0] != nil ? id[limit - 1][0] : nil #obtenemos el id
      response = HTTParty.get(URI.escape("https://graph.facebook.com/#{id}")) #obtenemos los datos de la fan page
      likes = response.scan(/"likes":(\d+)/)
      likes = likes[0] != nil ? likes[0][0] : nil #obtenemos la cantidad de likes
      limit = likes == nil ? limit += 1 : 0
      puts "artist: #{artist} id: #{id} puts #{likes} url: #{url}"
    end
    self.likes = likes #actualizamos los like
    self.save #actualizamos la banda

  end

end
