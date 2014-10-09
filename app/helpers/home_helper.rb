module HomeHelper

	def estadisticas_bandas(bandas_array)
		html = '<div class="row">'
		html += '<div class="col-md-6">'
		html += '<table class="table">'
		html += '<tr>'
		html += '<td class="text-left"><b>Nombre</b></td>'
		html += '<td class="text-right"><b>Likes Chile</b></td>'
		html += '<td class="text-right"><b>Facebook</b></td>'
		html += '<td class="text-right"><b>Spotify</b></td>'
		html += '<td class="text-right"><b>Last.fm</b></td>'
		html += '<td class="text-center"><b>Eliminar</b></td>'
		html += '</tr>'
		for banda in bandas_array
			html += '<tr>'
			html += '<td class="text-left">' + "#{banda.nombre}</td>"
			html += '<td class="text-right">' + "#{banda.chile}</td>"
			html += '<td class="text-right">' + "#{banda.likes}</td>"
			html += '<td class="text-right">' + "#{banda.spotify}</td>"
			html += '<td class="text-right">' + "#{banda.lastfm}</td>"
			html += '<td class="text-center">' + link_to(image_tag("eliminar_icon.png",:size => "20x20"),{:action => "eliminar",:banda_id => "#{banda[:id]}" },method: :post,:remote => true) + '</td>'
			html += '</tr>'
		end
		html += '</table>'
		html += '</div>'
		html += '</div>'
		html.html_safe
	end

end
