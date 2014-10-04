class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def buscar_banda(limit = 0, page = 0,artist)
  	artist.gsub!(/\s+/,'%20')
  	api_key = 'c0828cbf1521c0c4b7530aaee42ef105'
  	response = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=artist.search&artist=#{artist}&api_key=#{api_key}&limit=#{limit}&page=#{page}")
  	data = response.to_s.scan(/"artist"=>\{"name"=>"([^"]+)", "listeners"=>"([0-9]+)"/)
  	return data[0] ## ["nombre_banda","listeners"]
  end
end
