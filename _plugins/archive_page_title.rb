require_relative 'category_links'
require_relative 'tag_links'

module Jekyll
	class ArchivePageTitleTag < Liquid::Tag
		ARCHIVE_PAGE_TYPES = %w(category tag year month day)
		include CategoryLinksFilter
		include TagLinksFilter
		
		def render( context )
			unless Jekyll.const_defined?('Archives', false)
				return ''
			end
			page = context.environments.first['page']
			page_type = page['type']
			unless ARCHIVE_PAGE_TYPES.include? page_type
				return ''
			end
			case page_type
			when 'category'
				hoge = category_data(page['title'], context)['name']
				%Q{<i class="icon-briefcase icon-large"></i> <i class="icon-quote-left"></i>#{hoge}<i class="icon-quote-right"></i> 分类的归档}
			when 'tag'
				hoge = tag_data(page['title'], context)['name']
				%Q{<i class="icon-tag icon-large"></i> <i class="icon-quote-left"></i>#{hoge}<i class="icon-quote-right"></i> 标签的归档}
			when 'year'
				page['date'].strftime('%Y年') << '归档'
			when 'month'
				page['date'].strftime('%Y年%-m月') << '归档'
			when 'day'
				page['date'].strftime('%Y年%-m月%-d日') << '归档'
			end
		end
	end
end

Liquid::Template.register_tag('archive_page_title', Jekyll::ArchivePageTitleTag)
