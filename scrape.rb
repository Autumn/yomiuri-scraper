require 'nokogiri'
require 'open-uri'
require 'sqlite3'

# loads the headlines from a list of subsites on yomiuri and stores them in database
# ensures duplicates are not entered in the same date.

top_url = "http://www.yomiuri.co.jp"
sites = ["latestnews", "net", "politics", "national", "world", "science", "editorial", "e-japan", "eco", "election"]
db = SQLite3::Database.new("headings.db")

date = Time.new.strftime("%Y-%m-%d")

headings = []

sites.each do |site|
   file = open("#{top_url}/#{site}")
   doc = Nokogiri::HTML(file)
   doc.xpath('//ul[@class="list-def"]').each do |list|
     list.css("li").each do |link|
       text = link.text.strip
       test_exist = db.execute("select * from headings where date = ? and category = ? and headline = ?", date, site, text)
       if test_exist[0] == nil
         id = db.execute("select max(_id) from headings")[0]
         if id[0] == nil
           id = 0
         else
           id = id[0].to_i
         end
         db.execute("insert into headings values(?, ?, ?, ?)", id + 1, date, site, text)
       end
     end
   end
end
