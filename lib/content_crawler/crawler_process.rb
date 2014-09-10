require 'fileutils'
require 'net/https'
require 'uri'


module CrawlerProcess

  def initialize(crawler, base_url, timeout=300, user_agent=nil)
      @base_url = base_url
      case crawler
	      when "selenium_webdriver_with_headless"
		       @headless = Headless.new
		       @headless.start
           watir_web_browser(timeout)
        when "selenium_webdriver_without_headless"
           watir_web_browser(timeout)
	      when "mechanize_parser"
           mechanize_parser(user_agent)
	      else
		      puts "Please select any one of the parser(selenium_webdriver_with_headless, selenium_webdriver_without_headless, mechanize_parser) to crawl content"
      end
  end

  def watir_web_browser(timeout)
      client = Selenium::WebDriver::Remote::Http::Default.new
      client.timeout = timeout
      @browser = Watir::Browser.new :firefox, :http_client => client
      @browser.goto(@base_url)
      @browser
  end

  def mechanize_parser(user_agent=nil)
      if user_agent.nil?
        @agent = Mechanize.new{|a| a.ssl_version, a.verify_mode = 'SSLv3', OpenSSL::SSL::VERIFY_NONE}
      else
        @agent = Mechanize.new{|agent| agent.user_agent_alias = user_agent}
      end
      #@page = @agent.get(@base_url).parser
      @agent
  end

  def collection_links(parser_links, options={})
    links = Array.new
    parser_links = [parser_links].flatten.uniq
    parser_links.each do |link|
       data = {}
       data[:href] = link.attributes["href"].value.strip
       data[:text] = link.text.strip
       links << data
    end
    collection_attr(links, options)
  end

  def store_remote_image(remote_image_url, image_store_dir)
    image_store_dir = "#{Dir.pwd}/crawled_images" if image_store_dir.nil?
    remote_image_url = "#{@base_url}#{remote_image_url}" if not remote_image_url.include?("http")
    if not Dir.exist?("#{image_store_dir}")
      Dir.mkdir("#{image_store_dir}")
    end
    url = URI.parse(remote_image_url)
    response = Net::HTTP.get_response(url)
    if response.is_a?(Net::HTTPSuccess)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true if url.scheme == "https"
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.start do
        http.request_get(url.path) do |res|
          File.open("#{image_store_dir}/#{File.basename(url.path)}",'wb') do |file|
            file.write(res.body)
          end
        end
      end
      local_image = "#{image_store_dir}/#{File.basename(url.path)}"
    else
      local_image  = ""
    end
    local_image
  end

  def select_collection(select_detail, options={})
      selects = []
       select_detail.each do |select|
           hash = {}
           hash[:text] = select.text.strip
           hash[:value] = select.attributes["value"].text.strip
           selects << hash
       end
      collection_attr(selects, options)
  end

  def iframe_embed_collection(ifrm_embd_detail, options={})
      ifrm_embds = []
      ifrm_embd_detail.each do |ifrmembd|
        hash = {}
        hash[:text] = ifrmembd.text.strip
        hash[:src] = ifrmembd.value.strip
        ifrm_embds << hash
      end
      collection_attr(ifrm_embds, options)
  end

  def audio_video_collection(audio_video_detail, options={})
      auvid_collection = []
      audio_video_detail.each do |auvid|
        hash = {}
        hash[:src] = auvid.attributes["src"].value.strip
        hash[:type] = auvid.attributes["type"].value.strip
        auvid_collection << hash
      end
      collection_attr(auvid_collection, options)
  end

  def object_collection(object_detail, options={})
       objects = []
       object_detail.each do |object|
           hash = {}
           hash[:text] = object.text.strip
           hash[:value] = object.value.strip
           objects << hash
       end
      collection_attr(objects, options)
  end

  def datalist_collection(datalist_detail, options={})
       datalists = []
       datalist_detail.each do |datalist|
           hash = {}
           hash[:value] = datalist.attributes["value"].value.strip
           datalists << hash
       end
      collection_attr(datalists, options)
  end

  def collection_attr(collection, options)
    case options[:format]
      when "srcs_types"
        collection
      when "texts_values"
        collection
      when "texts_srcs"
        collection
      when "texts_hrefs"
        collection
      when "only_srcs"
        collection.map{|collobjt| collobjt[:src]}
      when "only_types"
        collection.map{|collobjt| collobjt[:type]}
      when "only_values"
        collection.map{|collobjt| collobjt[:value]}
      when "only_texts"
        collection.map{|collobjt| collobjt[:text]}
      when "only_hrefs"
        collection.map{|collobjt| collobjt[:href]}
      else
        collection
    end
  end

  def close_browser
    @browser.close if not @browser.nil?
    @headless.destroy if not @headless.nil?
  end

end
