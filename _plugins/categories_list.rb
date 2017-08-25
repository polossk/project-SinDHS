require_relative 'category_links'

module Jekyll
	class CategoriesListTag < Liquid::Tag
		include CategoryLinksFilter

		def render( context )
			site = context.registers[:site]
			show_cnt = site.config['show_count_in_categories_list'] || true
			jekyll_archives_installed = Jekyll.const_defined?('Archives', false);

			output = '<div class="col-2">'

			site.categories.map { |elem, posts|
				elem_data = category_data(elem, context)
				elem_output = '<div><span>'
				elem_output << %(<i class="icon-folder-open"></i> )
				if jekyll_archives_installed
					elem_output << category_link(elem_data, context)
				else
					elem_output << elem_data['name']
				end
				if show_cnt
					elem_output << " (#{posts.size})</span></div>"
					[elem_output, posts.size, elem]
				else
					[elem_output, 0, elem]
				end
			}.compact.sort { |a, b| b[1] <=> a[1] }.each { |e| output << e[0] }
			
			output << '</div>'
		end
	end
end

Liquid::Template.register_tag('categories_list', Jekyll::CategoriesListTag)
