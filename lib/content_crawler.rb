require "content_crawler/version"
require "content_crawler/crawler_process"
=begin
module ContentCrawler
  include CrawlerProcess
  # Your code goes here...
end
=end
class ContentCrawler
  include CrawlerProcess

  def initialize(crawler, base_url, timeout=300, user_agent=nil)
	    super
  end

  def get_parser_page(crawl_url=nil)
      if (not @browser.nil? and not crawl_url.nil?)
          @browser.goto(crawl_url)
          @page = Nokogiri::HTML(@browser.html)
      elsif (not @agent.nil? and not crawl_url.nil?)
          @page = @agent.get(crawl_url).parser if not crawl_url.nil?
      else
          puts "Please select any one of the parser(selenium_webdriver_with_headless, selenium_webdriver_without_headless, mechanize_parser) and pass the crawl_url to crawl content"
      end
  end

  def get_simple_text(xpath=nil)
      @page.xpath(xpath).text.strip if not xpath.nil?
  end

  def get_all_links(xpath=nil, options={})
      collection_links(@page.xpath(xpath), options) if not xpath.nil?
  end

  def get_remote_image(xpath=nil, image_store_dir=nil)
      store_remote_image(@page.xpath(xpath), image_store_dir) if not xpath.nil?
  end

  def get_select_elements(xpath=nil, options={})
      select_collection(@page.xpath(xpath), options) if not xpath.nil?
  end

  def get_iframe_embed_elements(xpath=nil, options={})
      iframe_embed_collection(@page.xpath(xpath), options) if not xpath.nil?
  end

  def get_audio_video_elements(xpath=nil, options={})
      audio_video_collection(@page.xpath(xpath), options) if not xpath.nil?
  end

  def close_browser
      super
  end

end
