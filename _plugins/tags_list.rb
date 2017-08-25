require_relative 'tag_links'

module Jekyll
	class TagsListTag < Liquid::Tag
		include TagLinksFilter

		class InnerTagStructure
			include TagLinksFilter
			attr_accessor :name, :frequence, :level, :s_html, :s_name
			def initialize( _name, _frequence, _context, _jekyll_archives_installed )
				@name = _name
				@frequence = _frequence
				@s_name = get_s_name( _context )['name']
				
			end

			def get_s_name( _context )
				tag_data(@name, _context)
			end

			def to_html( _context, _jekyll_archives_installed )
				return '' if @frequence < 1
				elem_data = tag_data(@name, _context)
				output = "<div class=\"tags level-#{@level.to_i + 1}\">"
				if _jekyll_archives_installed
					output << tag_link_sp(elem_data, _context, @frequence)
				else
					output << elem_data['name']
				end
				output << '</div>'
				output
			end

			def to_s()
				%(#{@name}: [#{@frequence}], [#@level])
			end
		end

		def render( context )
			site = context.registers[:site]
			show_cnt = site.config['show_count_in_tags_list'] || true
			archives = Jekyll.const_defined?('Archives', false);

			dataset = Array.new
			mapping = Hash.new
			site.tags.each { |elem, posts|
				dataset << InnerTagStructure.new(elem.to_s, posts.size, context, archives)
			}
			output = ''
			# firstly by frequence decrease: 5 4 3 2 1
			# secondly by alphabet increase: a b c d e
			dataset.sort! { |a, b| 
				if a.frequence == b.frequence
					a.s_name.upcase <=> b.s_name.upcase
				else
					b.frequence <=> a.frequence
				end
			}
			hoge = dataset.map { |e| e.frequence } .sort.uniq.reverse
			frequence_gap = hoge.length / 5.0
			levels = (0..5).map { |y| (y * frequence_gap).round }
			levels = levels[0..4].zip(levels[1..5]).reverse
			hoge.each_with_index { |e, i|
				mapping[e] = levels.index { |target|
					e >= target.first && e <= target.last
				}
			}
			dataset.each { |tag|
				tag.level = mapping[tag.frequence]
				output << tag.to_html( context, archives )
			}
			output
		end
	end
end

Liquid::Template.register_tag('tags_list', Jekyll::TagsListTag)
