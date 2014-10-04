class HomeController < ApplicationController
  
  def index
  	@bandas = Banda.all.to_a
  end

  def crear
  	Banda.create(:nombre => params[:nombre], :likes => 0, :spotify => 0, :lastfm => 0)
    redirect_to("/home/index")
   end

   def eliminar
   	Banda.find(params[:banda_id]).destroy
    redirect_to("/home/index")
   end
end
