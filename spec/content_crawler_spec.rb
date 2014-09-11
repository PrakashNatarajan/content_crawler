require 'content_crawler'

RSpec.describe "Started" do
  it "started to crawl the content" do
    content_crawler = ContentCrawler::Crawler.new("mechanize_parser", "file:///home/prakashn/Practise/html_practise.html", {:user_agent => "Mac Safari"})
  end
end
