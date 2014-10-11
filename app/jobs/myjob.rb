module MyJob
  @queue = :my_job_queue
  def self.perform()
    bandas = Banda.all.to_a 
		for banda in bandas #Actualizamos cada uno de los campos del modelo.
			banda.actualizar_lastfm
			banda.actualizar_spotify
			banda.actualizar_likes
			banda.actualizar_likes_chile
		end
  end
end
