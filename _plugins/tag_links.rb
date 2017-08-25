module Jekyll
	module TagLinksFilter
		def tag_links( tags )
			return '' if tags == nil || tags.empty?
			output = []

			jekyll_archives_installed = Jekyll.const_defined?('Archives', false)

			tags.each { |elem|
				elem_data = tag_data(elem, @context)
				output << (jekyll_archives_installed ? tag_link(elem_data, @context) : elem_data['name'])
			}
			configs = @context.registers[:site].config
			seperator = configs['tags_seperator'] || ', '
			output.join(seperator)
		end

		def tag_link( tag_data, context )
			site = context.registers[:site]
			archive = Archives::Archive.new(site, tag_data['slug'], 'tag', [])
			url = site.config['baseurl'] + archive.url
			%(<a href="#{url}" title="#{tag_data['name']}">#{tag_data['name']}</a>)
		end

		def tag_link_sp( tag_data, context, count )
			site = context.registers[:site]
			archive = Archives::Archive.new(site, tag_data['slug'], 'tag', [])
			url = site.config['baseurl'] + archive.url
			%(<a href="#{url}" title="#{tag_data['name']}">#{tag_data['name']} (#{count})</a>)
		end

		def tag_data(tag, context)
			tags_data = context.registers[:site].data['tags']
			slugs = tags_data.map { |e| e['slug'] }
			return {'slug' => tag, 'name' => tag} unless slugs.include?(tag)
			tags_data.select { |e| e['slug'] == tag }.first
		end
	end
end

Liquid::Template.register_filter(Jekyll::TagLinksFilter)
