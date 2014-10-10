class HomeController < ApplicationController
  
  def index
    @bandas = Banda.all.to_a
    @quiso_decir = flash[:quiso_decir]
  end

  def crear
  	nombre_banda = params[:nombre]
    consulta = bandaexiste(params[:nombre])
    if consulta == true #si la banda existe en Last.fm la agrega
  		Banda.create(:nombre => params[:nombre], :likes => 0, :spotify => 0, :lastfm => 0)
    elsif consulta[:nombre_verdadero] #Si esta mal escrito muestra sugerencia
      flash[:quiso_decir] = consulta[:nombre_verdadero]
    else
      flash[:quiso_decir] = 1
    end
    redirect_to("/home/index")
  end

  def eliminar
   	Banda.find(params[:banda_id]).destroy
    @bandas = Banda.all.to_a
    respond_to do |format|
      format.html {redirect_to("/home/index")}
      format.js
    end
  end

  def bandaexiste(banda)
   	#Consulta API Last.fm
    listeners = 0
    response = buscar_banda(1,0,banda)# tomamos el primer resultado de la busqueda en Lastfm

    if response != nil #si el artista existe se le da formato para comparar
      nombre_v = response[0].downcase
     	nombre = response[0].downcase
     	listeners = response[1].to_i
     	nombre.gsub!(/\s+/, '')
    end
    #damos formato para comparar
    n = banda.gsub(/\s+/, '')
    n = n.downcase
    if n == nombre && listeners > 20 #Banda existe y esta bien escrita
      return true
    elsif n != nombre && listeners > 20 #Banda existe pero esta mal escrita
      return {:nombre_verdadero => nombre_v}
    else
      return {:nombre_verdadero => false}
    end
  end

end
