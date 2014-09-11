require 'content_crawler'

RSpec.describe ContentCrawler::Crawler do

  it "started the crawler to initialize" do
    content_crawler = ContentCrawler::Crawler.new("mechanize_parser", "file:///home/prakashn/Practise/html_practise.html", {:user_agent => "Mac Safari"})
  end

  it "started to crawl the content without crawl_url" do
    content_crawler = ContentCrawler::Crawler.new("mechanize_parser", "file:///home/prakashn/Practise/html_practise.html", {:user_agent => "Mac Safari"})
    expect(content_crawler.get_parser_page).to eq("Please select any one of the parser(selenium_webdriver_with_headless, selenium_webdriver_without_headless, mechanize_parser) and pass the crawl_url to crawl content")
  end

  it "checking the parser class, wheather it is possible or not" do
    content_crawler = ContentCrawler::Crawler.new("mechanize_parser", "file:///home/prakashn/Practise/html_practise.html", {:user_agent => "Mac Safari"})
    expect(content_crawler.get_parser_page("file:///home/prakashn/Practise/html_practise.html").class.name).to eq("Nokogiri::HTML::Document")
  end

  it "started to get the select tag texts and values" do
    content_crawler = ContentCrawler::Crawler.new("mechanize_parser", "file:///home/prakashn/Practise/html_practise.html", {:user_agent => "Mac Safari"})
    content_crawler.get_parser_page("file:///home/prakashn/Practise/html_practise.html")
    expect(content_crawler.get_select_elements("//select/option")).to eq([{:text=>"Bestelling geannuleerd", :value=>"23"}, {:text=>"Bestelling ontvangen", :value=>"17"}, {:text=>"Bestelling verzonden", :value=>"24"}, {:text=>"Betaling mislukt", :value=>"22"}, {:text=>"Betaling ontvangen via Bank", :value=>"20"}, {:text=>"Betaling ontvangen via PayPal", :value=>"19"}, {:text=>"Betaling via Bank mislukt", :value=>"21"}, {:text=>"Betaling via PayPal mislukt", :value=>"18"}, {:text=>"Gereed voor afhalen (Delft)", :value=>"25"}, {:text=>"Wachten op betaling", :value=>"26"}])
    expect(content_crawler.get_select_elements("//select/option", {:format=>"texts_values"})).to eq([{:text=>"Bestelling geannuleerd", :value=>"23"}, {:text=>"Bestelling ontvangen", :value=>"17"}, {:text=>"Bestelling verzonden", :value=>"24"}, {:text=>"Betaling mislukt", :value=>"22"}, {:text=>"Betaling ontvangen via Bank", :value=>"20"}, {:text=>"Betaling ontvangen via PayPal", :value=>"19"}, {:text=>"Betaling via Bank mislukt", :value=>"21"}, {:text=>"Betaling via PayPal mislukt", :value=>"18"}, {:text=>"Gereed voor afhalen (Delft)", :value=>"25"}, {:text=>"Wachten op betaling", :value=>"26"}])
    expect(content_crawler.get_select_elements("//select/option", {:format=>"only_texts"})).to eq(["Bestelling geannuleerd", "Bestelling ontvangen", "Bestelling verzonden", "Betaling mislukt", "Betaling ontvangen via Bank", "Betaling ontvangen via PayPal", "Betaling via Bank mislukt", "Betaling via PayPal mislukt", "Gereed voor afhalen (Delft)", "Wachten op betaling"])
    expect(content_crawler.get_select_elements("//select/option", {:format=>"only_values"})).to eq(["23", "17", "24", "22", "20", "19", "21", "18", "25", "26"])
  end

  it "started to get the anchor tag texts and hrefs" do
    content_crawler = ContentCrawler::Crawler.new("mechanize_parser", "file:///home/prakashn/Practise/html_practise.html", {:user_agent => "Mac Safari"})
    content_crawler.get_parser_page("file:///home/prakashn/Practise/html_practise.html")
    expect(content_crawler.get_link_elements("//a")).to eq([{:href=>"http://www.test.test", :text=>"Opmerkingen"}, {:href=>" ", :text=>"Geschiedenis bijwerken"}])
    expect(content_crawler.get_link_elements("//a", {:format=>"texts_hrefs"})).to eq([{:href=>"http://www.test.test", :text=>"Opmerkingen"}, {:href=>" ", :text=>"Geschiedenis bijwerken"}])
    expect(content_crawler.get_link_elements("//a", {:format=>"only_texts"})).to eq(["Opmerkingen", "Geschiedenis bijwerken"])
    expect(content_crawler.get_link_elements("//a", {:format=>"only_hrefs"})).to eq(["http://www.test.test", " "])
  end

  it "started to get the iframe texts and srcs" do
    content_crawler = ContentCrawler::Crawler.new("mechanize_parser", "file:///home/prakashn/Practise/html_practise.html", {:user_agent => "Mac Safari"})
    content_crawler.get_parser_page("file:///home/prakashn/Practise/html_practise.html")
    expect(content_crawler.get_iframe_embed_elements("//iframe/@src", {:format=>"only_srcs"})).to eq(["http://www.tutorialspoint.com/html/menu.htm"])
    expect(content_crawler.get_iframe_embed_elements("//iframe/@src")).to eq([{:src => "http://www.tutorialspoint.com/html/menu.htm"}])
  end

  it "started to store the remote image into local system" do
    content_crawler = ContentCrawler::Crawler.new("mechanize_parser", "file:///home/prakashn/Practise/html_practise.html", {:user_agent => "Mac Safari"})
    content_crawler.get_parser_page("file:///home/prakashn/Practise/html_practise.html")
    expect(content_crawler.get_remote_image("//img/@src")).to eq(["#{Dir.home}/crawled_images/2462582861_31d51f157c_b.jpg"])
    expect(content_crawler.get_remote_image("//img/@src", "/home/prakashn/Desktop/crawled_images")).to eq(["/home/prakashn/Desktop/crawled_images/2462582861_31d51f157c_b.jpg"])
  end

end
