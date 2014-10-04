class HomeController < ApplicationController

  def index
  	@bandas = Banda.all.to_a
  end

  def crear
  	nombre_banda = params[:nombre]
  	if bandaexiste?(params[:nombre])#si la banda existe en Last.fm la agrega
  		Banda.create(:nombre => params[:nombre], :likes => 0, :spotify => 0, :lastfm => 0)
    end
    redirect_to("/home/index")
  end

   def eliminar
   	 Banda.find(params[:banda_id]).destroy
     redirect_to("/home/index")
   end

   def bandaexiste?(banda)
   	 #Consulta API Last.fm
     response = buscar_banda(1,0,banda)# tomamos el primer resultado de la busqueda en Lastfm
     if response != nil #si el artista existe se le da formato para comparar
     	response = response.downcase
     	response.gsub!(/ /, '')
     end
     #damos formato para comparar
     n = banda.gsub(/%20+/, '')
     n = n.downcase
     banda.gsub!(/%20+/, ' ')
     
     return n == response
   end

end
