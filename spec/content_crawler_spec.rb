require 'content_crawler'

RSpec.describe ContentCrawler::Crawler do

  it "started the crawler to initialize" do
    content_crawler = ContentCrawler::Crawler.new("mechanize_parser", "file://#{Dir.pwd}/public/html_test.html", {:user_agent => "Mac Safari"})
  end

  it "started to crawl the content without crawl_url" do
    content_crawler = ContentCrawler::Crawler.new("mechanize_parser", "file://#{Dir.pwd}/public/html_test.html", {:user_agent => "Mac Safari"})
    expect(content_crawler.get_parser_page).to eq("Please select any one of the parser(selenium_webdriver_with_headless, selenium_webdriver_without_headless, mechanize_parser) and pass the crawl_url to crawl content")
  end

  it "checking the parser class, wheather it is possible or not" do
    content_crawler = ContentCrawler::Crawler.new("mechanize_parser", "file://#{Dir.pwd}/public/html_test.html", {:user_agent => "Mac Safari"})
    expect(content_crawler.get_parser_page("file://#{Dir.pwd}/public/html_test.html").class.name).to eq("Nokogiri::HTML::Document")
  end

  it "started to get the select tag texts and values" do
    content_crawler = ContentCrawler::Crawler.new("mechanize_parser", "file://#{Dir.pwd}/public/html_test.html", {:user_agent => "Mac Safari"})
    content_crawler.get_parser_page("file://#{Dir.pwd}/public/html_test.html")
    expect(content_crawler.get_select_elements("//select/option")).to eq([{:text=>"Bestelling geannuleerd", :value=>"23"}, {:text=>"Bestelling ontvangen", :value=>"17"}, {:text=>"Bestelling verzonden", :value=>"24"}, {:text=>"Betaling mislukt", :value=>"22"}, {:text=>"Betaling ontvangen via Bank", :value=>"20"}, {:text=>"Betaling ontvangen via PayPal", :value=>"19"}, {:text=>"Betaling via Bank mislukt", :value=>"21"}, {:text=>"Betaling via PayPal mislukt", :value=>"18"}, {:text=>"Gereed voor afhalen (Delft)", :value=>"25"}, {:text=>"Wachten op betaling", :value=>"26"}])
    expect(content_crawler.get_select_elements("//select/option", {:format=>"texts_values"})).to eq([{:text=>"Bestelling geannuleerd", :value=>"23"}, {:text=>"Bestelling ontvangen", :value=>"17"}, {:text=>"Bestelling verzonden", :value=>"24"}, {:text=>"Betaling mislukt", :value=>"22"}, {:text=>"Betaling ontvangen via Bank", :value=>"20"}, {:text=>"Betaling ontvangen via PayPal", :value=>"19"}, {:text=>"Betaling via Bank mislukt", :value=>"21"}, {:text=>"Betaling via PayPal mislukt", :value=>"18"}, {:text=>"Gereed voor afhalen (Delft)", :value=>"25"}, {:text=>"Wachten op betaling", :value=>"26"}])
    expect(content_crawler.get_select_elements("//select/option", {:format=>"only_texts"})).to eq(["Bestelling geannuleerd", "Bestelling ontvangen", "Bestelling verzonden", "Betaling mislukt", "Betaling ontvangen via Bank", "Betaling ontvangen via PayPal", "Betaling via Bank mislukt", "Betaling via PayPal mislukt", "Gereed voor afhalen (Delft)", "Wachten op betaling"])
    expect(content_crawler.get_select_elements("//select/option", {:format=>"only_values"})).to eq(["23", "17", "24", "22", "20", "19", "21", "18", "25", "26"])
  end

  it "started to get the anchor tag texts and hrefs" do
    content_crawler = ContentCrawler::Crawler.new("mechanize_parser", "file://#{Dir.pwd}/public/html_test.html", {:user_agent => "Mac Safari"})
    content_crawler.get_parser_page("file://#{Dir.pwd}/public/html_test.html")
    expect(content_crawler.get_link_elements("//a")).to eq([{:href=>"http://www.test.test", :text=>"Opmerkingen"}, {:href=>" ", :text=>"Geschiedenis bijwerken"}])
    expect(content_crawler.get_link_elements("//a", {:format=>"texts_hrefs"})).to eq([{:href=>"http://www.test.test", :text=>"Opmerkingen"}, {:href=>" ", :text=>"Geschiedenis bijwerken"}])
    expect(content_crawler.get_link_elements("//a", {:format=>"only_texts"})).to eq(["Opmerkingen", "Geschiedenis bijwerken"])
    expect(content_crawler.get_link_elements("//a", {:format=>"only_hrefs"})).to eq(["http://www.test.test", " "])
  end

  it "started to get the iframe texts and srcs" do
    content_crawler = ContentCrawler::Crawler.new("mechanize_parser", "file://#{Dir.pwd}/public/html_test.html", {:user_agent => "Mac Safari"})
    content_crawler.get_parser_page("file://#{Dir.pwd}/public/html_test.html")
    expect(content_crawler.get_iframe_embed_elements("//iframe/@src", {:format=>"only_srcs"})).to eq(["http://www.tutorialspoint.com/html/menu.htm"])
    expect(content_crawler.get_iframe_embed_elements("//iframe/@src")).to eq([{:src => "http://www.tutorialspoint.com/html/menu.htm"}])
  end

  it "started to store the remote image into local system" do
    content_crawler = ContentCrawler::Crawler.new("mechanize_parser", "file://#{Dir.pwd}/public/html_test.html", {:user_agent => "Mac Safari"})
    content_crawler.get_parser_page("file://#{Dir.pwd}/public/html_test.html")
    expect(content_crawler.get_remote_image("//img/@src")).to eq(["#{Dir.home}/crawled_images/2462582861_31d51f157c_b.jpg"])
    expect(content_crawler.get_remote_image("//img/@src", "#{Dir.home}/Desktop/crawled_images")).to eq(["#{Dir.home}/Desktop/crawled_images/2462582861_31d51f157c_b.jpg"])
  end

  it "start to get video source urls" do 
    content_crawler = ContentCrawler::Crawler.new("mechanize_parser", "file://#{Dir.pwd}/public/html_test.html", {:user_agent => "Mac Safari"})
    content_crawler.get_parser_page("file://#{Dir.pwd}/public/html_test.html")
    expect(content_crawler.get_audio_video_elements("//video/source")).to eq([{:src=>"http://www.w3schools.com/movie.ogg", :type=>"video/ogg"}, {:src=>"http://www.w3schools.com/movie.mp4", :type=>"video/mp4"}])
    expect(content_crawler.get_audio_video_elements("//video/source", {:format=>"srcs_types"})).to eq([{:src=>"http://www.w3schools.com/movie.ogg", :type=>"video/ogg"}, {:src=>"http://www.w3schools.com/movie.mp4", :type=>"video/mp4"}])
    expect(content_crawler.get_audio_video_elements("//video/source", {:format=>"only_srcs"})).to eq(["http://www.w3schools.com/movie.ogg", "http://www.w3schools.com/movie.mp4"])
    expect(content_crawler.get_audio_video_elements("//video/source", {:format=>"only_types"})).to eq(["video/ogg", "video/mp4"])
  end

  it "start to get audio source urls" do 
    content_crawler = ContentCrawler::Crawler.new("mechanize_parser", "file://#{Dir.pwd}/public/html_test.html", {:user_agent => "Mac Safari"})
    content_crawler.get_parser_page("file://#{Dir.pwd}/public/html_test.html")
    expect(content_crawler.get_audio_video_elements("//audio/source")).to eq([{:src=>"http://www.w3schools.com/horse.mp3", :type=>"audio/mpeg"}, {:src=>"http://www.w3schools.com/horse.ogg", :type=>"audio/ogg"}])
    expect(content_crawler.get_audio_video_elements("//audio/source", {:format=>"srcs_types"})).to eq([{:src=>"http://www.w3schools.com/horse.mp3", :type=>"audio/mpeg"}, {:src=>"http://www.w3schools.com/horse.ogg", :type=>"audio/ogg"}])
    expect(content_crawler.get_audio_video_elements("//audio/source", {:format=>"only_srcs"})).to eq(["http://www.w3schools.com/horse.mp3", "http://www.w3schools.com/horse.ogg"])
    expect(content_crawler.get_audio_video_elements("//audio/source", {:format=>"only_types"})).to eq(["audio/mpeg", "audio/ogg"])
  end

  it "start to get object source urls" do 
    content_crawler = ContentCrawler::Crawler.new("mechanize_parser", "file://#{Dir.pwd}/public/html_test.html", {:user_agent => "Mac Safari"})
    content_crawler.get_parser_page("file://#{Dir.pwd}/public/html_test.html")
    expect(content_crawler.get_object_elements("//object/@data")).to eq([{:text=>"http://www.youtube.com/v/XGSy3_Czz8k", :value=>"http://www.youtube.com/v/XGSy3_Czz8k"}, {:text=>"http://www.youtube.com/v/XGSy3_Czz9k", :value=>"http://www.youtube.com/v/XGSy3_Czz9k"}])
    expect(content_crawler.get_object_elements("//object/@data", {:format=>"texts_values"})).to eq([{:text=>"http://www.youtube.com/v/XGSy3_Czz8k", :value=>"http://www.youtube.com/v/XGSy3_Czz8k"}, {:text=>"http://www.youtube.com/v/XGSy3_Czz9k", :value=>"http://www.youtube.com/v/XGSy3_Czz9k"}])
    expect(content_crawler.get_object_elements("//object/@data", {:format=>"only_texts"})).to eq(["http://www.youtube.com/v/XGSy3_Czz8k", "http://www.youtube.com/v/XGSy3_Czz9k"])
    expect(content_crawler.get_object_elements("//object/@data", {:format=>"only_values"})).to eq(["http://www.youtube.com/v/XGSy3_Czz8k", "http://www.youtube.com/v/XGSy3_Czz9k"])
  end

  it "start to get datalist values" do 
    content_crawler = ContentCrawler::Crawler.new("mechanize_parser", "file://#{Dir.pwd}/public/html_test.html", {:user_agent => "Mac Safari"})
    content_crawler.get_parser_page("file://#{Dir.pwd}/public/html_test.html")
    expect(content_crawler.get_datalist_elements("//datalist/option")).to eq([{:value=>"Internet Explorer"}, {:value=>"Firefox"}, {:value=>"Chrome"}, {:value=>"Opera"}, {:value=>"Safari"}])
    expect(content_crawler.get_datalist_elements("//datalist/option", {:format=>"only_values"})).to eq(["Internet Explorer", "Firefox", "Chrome", "Opera", "Safari"])
  end

end
