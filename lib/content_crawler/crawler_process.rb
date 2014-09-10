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
    links_attr(links, options)
  end

  def links_attr(links, options={})
    case options[:format]
      when "texts_hrefs"
        links
      when "only_hrefs"
        links.map{|link| link[:href]}
      when "only_texts"
        links.map{|link| link[:text]}
      else
        links
    end
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

  def select_text_values(select_detail, options={})
      selects = []
       select_detail.each do |select|
           hash = {}
           hash[:text] = select.text.strip
           hash[:value] = select.attributes["value"].text.strip
           selects << hash
       end
      select_attr(selects, options)
  end

  def select_attr(selects, options={})
    case options[:format]
      when "texts_values"
        selects
      when "only_values"
        selects.map{|select| select[:value]}
      when "only_texts"
        selects.map{|select| select[:text]}
      else
      selects
    end
  end

  def iframe_embed_srcs(ifrm_embd_detail, options={})
      ifrm_embds = []
      ifrm_embd_detail.each do |ifrmembd|
        hash = {}
        hash[:text] = ifrmembd.text.strip
        hash[:src] = ifrmembd.value.strip
        ifrm_embds << hash
      end
      iframe_embed_attr(ifrm_embds, options)
  end

  def iframe_embed_attr(ifrm_embds, options)
    case options[:format]
      when "texts_srcs"
        ifrm_embds
      when "only_srcs"
        ifrm_embds.map{|ifrmembd| ifrmembd[:src]}
      when "only_texts"
        ifrm_embds.map{|ifrmembd| ifrmembd[:text]}
      else
        ifrm_embds
    end
  end



  def close_browser
    @browser.close if not @browser.nil?
    @headless.destroy if not @headless.nil?
  end

end
