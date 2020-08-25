module ApplicationHelper
	def image_url(url)
		if url.split('system')[1]
			"https://s3.amazonaws.com/" + ENV['S3_BUCKET'].to_s + url.split('system')[1].to_s
		end
	end

	def embed_from_youtube_url(youtube_url)
    if youtube_url[/youtu\.be\/([^\?]*)/]
	    youtube_id = $1
	  else
	    youtube_url[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
	    youtube_id = $5
	  end
	  if youtube_id.present?
    	content_tag(:iframe, nil, src: "//www.youtube.com/embed/#{youtube_id}")
    end
  end

  def url_with_protocol(url)
    /^http/.match(url) ? url : "http://#{url}"
  end
end