module Jekyll
    class RunDays < Liquid::Tag
        def render( context )
            site = context.registers[:site]
            dataset = site.posts.docs.map { |e| e.date }.sort.reverse.uniq
            hoge = dataset[0]
            piyo = dataset[-1]
            output = ((hoge - piyo) / 3600 / 24).ceil
        end
    end
end

Liquid::Template.register_tag('rundays', Jekyll::RunDays)