require 'sqlite3'
require 'trollop'
require 'date'

def date_format?(date)
  parsed_date = Date._strptime(date, "%Y-%m-%d")
  if parsed_date == nil
    false
  else
    true
  end
end

db = SQLite3::Database.new("headings.db")

categories = ["latestnews", "net", "politics", "national", "world", "science", "editorial", "e-japan", "eco", "election"]

opts = Trollop::options do
  opt :date, "YYYY-MM-DD formatted date. Specifies date for articles.", :default => Time.new.strftime("%Y-%m-%d")
  opt :category, "Category for articles.", :type => String
  opt :list, "Lists the available categories."
end

Trollop::die :category, "must be set. Run with --list to see available categories" if opts[:category] == false
Trollop::die :category, "must be valid. Run with --list to see available categories" if (not categories.include? opts[:category])
Trollop::die :date, "must be in format YYYY-MM-DD." if date_format?(opts[:date]) == false

category = opts[:category]
date = opts[:date]

results = db.execute("select headline from headings where category = ? and date = ?", category, date)
puts results
