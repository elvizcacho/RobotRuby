module HomeHelper

	def estadisticas_bandas(bandas_array)
		html = '<div class="row">'
		html += '<div class="col-md-6">'
		html += '<table class="table">'
		html += '<tr>'
		html += '<td><b>Nombre</b></td>'
		html += '<td><b>Facebook</b></td>'
		html += '<td><b>Spotify</b></td>'
		html += '<td><b>Last.fm</b></td>'
		html += '<td><b>Eliminar</b></td>'
		html += '</tr>'
		for banda in bandas_array
			html += '<tr>'
			html += "<td>#{banda.nombre}</td>"
			html += "<td>#{banda.likes}</td>"
			html += "<td>#{banda.spotify}</td>"
			html += "<td>#{banda.lastfm}</td>"
			html += '<td>' + link_to(image_tag("eliminar_icon.png",:size => "20x20"),{:action => "eliminar",:banda_id => "#{banda[:id]}" },method: :post) + '</td>'
			html += '</tr>'
		end
		html += '</table>'
		html += '</div>'
		html += '</div>'
		html.html_safe
	end

end
