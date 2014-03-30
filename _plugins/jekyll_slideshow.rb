require 'RMagick'
require 'nokogiri'
include Magick

module Jekyll

  class ThumbGenerator < Generator
    safe true

    def generate(site)
      # go through all the images in the site, generate thumbnails for each one

      # if we don't have values set for thumbnails, use a sensible default
      if Jekyll.configuration({}).has_key?('slideshow')
        config = Jekyll.configuration({})['slideshow']
      else
        config = Hash["width", 100, "height", 100]
      end
      to_thumb = Array.new
      # create a list of images to be thumbed
      # avoids problem with running over and over the old thumb
      site.static_files.each do |file|
        if (File.extname(file.path).downcase == ('.jpg' || '.png')) &&
              (!File.basename(file.path).include? "-thumb")
          new_path = File.dirname(file.path) +
            '/' + File.basename(file.path, '.*') +
            '-thumb' + File.extname(file.path)
          # if we already have a thumbnail for this, we may or may not want to
          # overwrite it. concretely, we overwrite it if and only if the
          # thumbnail is older than the current version of the file we want to
          # thumbify
          if (!File.file?(new_path) ||
              File.mtime(new_path).to_i < file.mtime)
            to_thumb.push(file)
          end
        end
      end
      to_thumb.each do |file|
          img = Magick::Image::read(file.path).first
          thumb = img.resize_to_fill(config['width'], config['height'])
          path = file.path.sub(File.extname(file.path),
            '-thumb' << File.extname(file.path))
          thumb.write path
          site.static_files << StaticFile.new(thumb, site.source,
            File.dirname(file.path).sub(site.source, ''),
            File.basename(file.path).sub(File.extname(file.path),
              '-thumb' << File.extname(file.path)))
      end
    end
  end

  module ImageThumbs
    def slideshows(content)
      # go through content using the slideshows filter
      # for any imgs in <ul>s, change the src to use the new thumbs
      # set a data attribute referencing the original (fullsize) image

	  page = @context.registers[:page]
	  img_rel = ""
      if page.has_key?('img_rel')
	  	img_rel=page['img_rel'] + '/'
	  end

      doc = Nokogiri::XML.fragment(content.encode!("UTF-8"))
      doc.css('img').each do |img|
	    subimg = img
        url = img['src']
		if url.index("http") == 0
			next
		end
	    a = img.document.create_element 'a'
		title = img['alt']
		a['href'] = img_rel + url
		a['title'] = title
        newurl = img_rel + File.dirname(url) << '/' << File.basename(url,
          File.extname(url)) << '-thumb' << File.extname(url)
		subimg['src'] = newurl
		a.inner_html = subimg.to_s
		img.replace a
      end
      return doc.to_s.encode!("UTF-8")

    end
  end

end

Liquid::Template.register_filter(Jekyll::ImageThumbs)
