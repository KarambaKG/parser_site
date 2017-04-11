require_relative 'init.rb'

db = SQLite3::Database.new('test.db')

db.execute 'CREATE TABLE IF NOT EXISTS information (id INTEGER PRIMARY KEY,
                                            rating TEXT,
                                            date TEXT,
                                            number TEXT,
                                            text TEXT);'
url = 'http://bash.im'
html = open(url)

doc = Nokogiri::HTML(html)

doc.css('.quote').each do |info|
  rating = info.css('.rating').text
  date = info.css('.date').text
  number = info.css('.id').text
  text = info.css('.text').text
  if rating == '???'
    rating = 'NULL'
  end

  db.execute "INSERT INTO information (rating,date,number,text) values
 ('#{rating}','#{date}','#{number}','#{text}');"
  db.results_as_hash = true
  db.execute 'SELECT * FROM information;' do |info|
    puts format('id: %s | rating: %s | date: %s | number: %s | text: %s |',
                info['id'], info['rating'], info['date'], info['number'], info['text'])
  end
end
