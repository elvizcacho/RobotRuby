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
    @bandas = Banda.all.to_a
    respond_to do |format|
      format.html {redirect_to("/home/index")}
      format.js
    end
  end

  def bandaexiste?(banda)
   	#Consulta API Last.fm
    response = buscar_banda(1,0,banda)# tomamos el primer resultado de la busqueda en Lastfm
    if response != nil #si el artista existe se le da formato para comparar
     	nombre = response[0].downcase
     	listeners = response[1].to_i
     	nombre.gsub!(/ /, '')
    end
    #damos formato para comparar
    n = banda.gsub(/%20+/, '')
    n = n.downcase
    banda.gsub!(/%20+/, ' ')
     
    return (n == nombre && listeners > 20)
  end

   def scrapping 
    #Scrapping Facebook para obtener los likes solo de Chile
    mechanize = Mechanize.new { |agent|
      agent.follow_meta_refresh = true
    }

    #Login Facebook
    page = mechanize.get('https://www.facebook.com/advertising')
    form = page.forms.first #busco el primer form
    form['email'] = 'acidprueba@gmail.com' #credenciales de acceso a facebook
    form['pass'] = 'acidprueba77'
    ads_home = page.form.submit  #envio el form
    links = ads_home.links_with(:class => "_42ft _42fu selected _42gz") #obtengo el link que me lleva a crear un nuevo Ad
    ads_options = links[0].click #voy a crear nuevo Ad
    ##Problemas con mechanize y JavaScript ... Buscando solución
    ##para poder navegar entre el form que usa Ajax.
    render :text => "#{ads_options.body}"
    ##############ADS API#####################
    #GET TOKEN TO USE AD API: https://graph.facebook.com/oauth/access_token?client_id=313760365477283&redirect_uri=http://0.0.0.0:3000/&client_secret=b0eb3610944a84a9db9088678965b9c6&code=AQAWiYi1QPCd5KewTv6sW6tPp-8u2wctxxfPuAf1XhfPCOqgsHX_MV5kH3_4AM6XHraqbMNgXNxnhUW3VqhGVOXxtLT7E-2ekgtB3uaHxGg3wRSH_mr1MGaU3JRryLqLczp-06V9yG06av1aLmHL5dV9I0kcrplQDRWSGBsmt3R6cKYccN0ZdRq6Ire54hRKQTQWQSkfL87HtG4x-ZBioffkGN2tBzKCyzrYS9DlsqnHrqMWIBixsaAI1VHQHM9pIpe4GVeXGnY7HH-RNGsV4cZlUCUu3c_o5CyoBv6Xmil6vo8CX1QWxlZeQi7DJ6f4tjM#_=_
    #TOKEN: CAAEdXQcgZCaMBAFjxiYslYgKwZA7t6FePskHG9MN9KZAUL4HTV8Vd1FTWbvAH9VRSDpbOeY9thUIcr9TQxXUiM6MZCcrQiVZAcOKuXdmv9I7xFbxr7GULnbDuZCLF5mMlJyh5YN7ITgHXfi1TtQas8dHUytJ85nYPknyjDABq5xNzYWo3T8ZAg8Q2ZAfve85y0I846cBONYNgsydAk79PWVq&expires=5183836
    ##Debo pedir permiso a facebook llenando un formulario para poder usar la Ads API
   end

end
