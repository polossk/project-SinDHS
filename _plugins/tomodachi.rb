module Jekyll
    class Tomodachi < Liquid::Tag
        def links( context )
            raw = context.registers[:site].data['friends']
            return raw.map{ |e| [e['slug'], e['value']] }
        end

        def rend_link( name, url )
            %(<div><span><i class="icon-bookmark"></i><a href="#{url}" title="#{name}"> #{name} </a></span></div>)
        end

        def render( context )
            raw = context.registers[:site].data['friends']
            output = raw.map{ |e| rend_link(e['slug'], e['value']) }
            return output
        end
    end
end

Liquid::Template.register_tag('tomodachi', Jekyll::Tomodachi)