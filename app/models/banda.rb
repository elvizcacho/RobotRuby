class Banda < ActiveRecord::Base
	
  def actualizar_lastfm
		artist = self.nombre #obtenemos nombre de banda
		api_key = 'c0828cbf1521c0c4b7530aaee42ef105'
  	response = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=artist.search&artist=" + URI.escape("#{artist}") + "&api_key=#{api_key}&limit=1&page=0")
  	data = response.to_s.scan(/"artist"=>\{"name"=>"([^"]+)", "listeners"=>"([0-9]+)"/) #parseamos el response de la API
  	if data[0] != nil #en caso de que no devuelva listeners
  		listeners = data[0][1].to_i #extraemos el match group que contiene los listeners
  		self.lastfm = listeners #actualizamos los listeners
		  self.save #actualizamos la banda
		end
  end

	def actualizar_spotify
		artist = self.nombre #obtenemos nombre de banda
    response = HTTParty.get("https://api.spotify.com/v1/search?query=" + URI.escape("#{artist}") + "&offset=0&limit=1&type=artist")
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
    while (likes == nil && limit < 5) #Si Facebook no nos da acceso buscamos en el siguiente resultado
      url = "https://graph.facebook.com/search?q=" + URI.escape("#{artist}") + "&type=page&access_token=" + URI.escape("#{token}") + "&limit=#{limit}" # parseamos la URL ya que el token contiene un pipe que hace que la URL sea invalida
      response = HTTParty.get(url) #buscamos artista
      id = response.scan(/"id":"(\d+)"/) #parseamos el id de la fan page.
      id = id[0] != nil ? id[limit - 1][0] : nil #obtenemos el id
      response = HTTParty.get(URI.escape("https://graph.facebook.com/#{id}")) #obtenemos los datos de la fan page
      likes = response.scan(/"likes":(\d+)/)
      likes = likes[0] != nil ? likes[0][0] : nil #obtenemos la cantidad de likes
      limit = likes == nil ? limit += 1 : 0
    end
    self.likes = likes #actualizamos los like
    self.save #actualizamos la banda
  end

  def actualizar_likes_chile
    artist = self.nombre #obtenemos nombre de banda
    #token se vence despues de unos dias #pendiente por calcular periodicidad del token
    token = 'CAACZBzNhafycBAI1swImmeM4kSUZCBoXwSRcfhQfWMDlhJ7Qao68f9NHCyaWaI4lNxaIgRiKooZBIXO9NC7yiQD0uYLaTwwfquZAXQpU1DeKmAddUxEEEVDut0UgKIB2WVjJ0B9xH0vFIRKTFwZBceZAsuJPQiRK6mQZA6ENnYtVOGZCMi92bIEdPtPaSqbZC18dIxGJKArKLoZAn9edMJanlaZC5mHvCbZCFboZD'
    response_id = HTTParty.get("https://graph.facebook.com/search?access_token=#{token}&callback=__globalCallbacks.f4bb08abc&endpoint=%2Fsearch&locale=en_US&method=get&pretty=0&q=" + URI.escape("#{artist}") + "&type=adInterest")
    data = response_id.to_s.scan(/"id":(\d+)/) #parseamos el response de la API
    if data[0] != nil #en caso de que no devuelva ningun id
      id_searcher = data[0][0] #extraemos el primer ID
    end
    response_data = HTTParty.get("https://graph.facebook.com/act_1469630386636799/reachestimate?access_token=#{token}&accountId=1469630386636799&bid_for=%5B%22conversion%22%5D&callback=__globalCallbacks.f1864d5f48&currency=COP&endpoint=%2Fact_1469630386636799%2Freachestimate&locale=en_US&method=get&pretty=0&targeting_spec=%7B%22age_max%22%3A65%2C%22age_min%22%3A18%2C%22interests%22%3A%5B%7B%22id%22%3A%22#{id_searcher}%22%2C%22name%22%3A%22" + URI.escape("#{artist}") + "%22%7D%5D%2C%22excluded_connections%22%3A%5B%7B%22id%22%3A%22720613074687769%22%2C%22name%22%3A%22AcidSearcher%22%7D%5D%2C%22geo_locations%22%3A%7B%22countries%22%3A%5B%22CL%22%5D%7D%7D")
    data = response_data.to_s.scan(/"users":(\d+),"bid_estimations"/) #parseamos el response de la API
    if data[0] != nil #en caso de que no devuelva ningun resultado
      likes_chile = data[0][0] #extraemos la cantidad de personas que les gusta la banda en Chile
    end
    self.chile = likes_chile #actualizamos los like
    self.save #actualizamos la banda
  end

end
