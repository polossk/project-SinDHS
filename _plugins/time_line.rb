module Jekyll
	class PostTimeLine < Liquid::Tag
		class InnerStructure
			attr_accessor :name, :frequence
			def initialize( _name, _frequence )
				@name = _name
				@frequence = _frequence
			end

			def to_html( home_url )
				url = "#{home_url}/#{@name}/"
				%(<a href="#{url}" title="#{@name}">#{@name} (#{@frequence})</a>)
			end
		end

		def render( context )
			site = context.registers[:site]
			home_url = site.config['baseurl']
			dataset = site.posts.docs.map { |e| e.date.year.to_i }.sort.reverse
			dataidx = dataset.uniq
			output = '<div class="col-2">'
			dataidx.each { |e| 
				output << '<div><span>'
				output << %(<i class="icon-time"></i> )
				output << InnerStructure.new(e, dataset.count(e)).to_html(home_url)
				output << "</span></div>"
			}
			output << '</div>'
		end
	end
end

Liquid::Template.register_tag('time_line', Jekyll::PostTimeLine)