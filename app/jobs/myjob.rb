module MyJob
  @queue = :my_job_queue
  def self.perform()
    bandas = Banda.all.to_a
		for banda in bandas
			banda.actualizar_lastfm
		end
  end
end
