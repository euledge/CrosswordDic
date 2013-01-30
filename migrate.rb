# coding:utf-8
require 'rubygems'
require 'sqlite3'
require 'active_support'

TABLE={
  "ｱ" => "ア",
  "ｲ" => "イ",
  "ｳ" => "ウ",
  "ｴ" => "エ",
  "ｵ" => "オ",
  "ｶ" => "カ",
  "ｷ" => "キ",
  "ｸ" => "ク",
  "ｹ" => "ケ",
  "ﾂ" => "ツ",
  "ﾔ" => "ヤ",
  "ﾕ" => "ユ",
  "ﾖ" => "ヨ",
  "ﾜ" => "ワ"
}

def toupper_kana(str)
  str.gsub(/[#{TABLE.keys.join("")}]/){|ch| TABLE[ch]}
end

def add_dictionary(pronounce, word)
  columns = Array.new
  columns[0] = pronounce
  columns[1] = word
  columns[2] = pronounce.size
  sqlcmd = ""
  (1..pronounce.size).each do |i|
    columns[2+i] = pronounce[i-1]
    sqlcmd = "insert into dictionary values(" +
             "'#{columns[0]}', '#{columns[1]}',  #{columns[2]},  '#{columns[3]}', " +
             "'#{columns[4]}', '#{columns[5]}', '#{columns[6]}', '#{columns[7]}', " +
             "'#{columns[8]}', '#{columns[9]}', '#{columns[10]}');\n"
  end
  sqlcmd
end

def execute_sql(db,  sql)
  db.transaction do
    db.execute_batch(sql)
  end
  sql = ""
end
db = SQLite3::Database.new("db/dictionary.db")

begin
  p "start #{Time.now}\n"
  filename = "db/naist-jdic-utf.csv"
  i=0
  bulk_command = ""
  bulk_command = bulk_command + "delete from dictionary;\nvacuum;\n"
  db.execute_batch(bulk_command)
  bulk_command = ""
  File.foreach(filename) do |row|
    fields = row.split(",")
    unless /記号/ =~ fields[4] then
      yomi = toupper_kana(fields[11])
      if 1 < fields[11].size && fields[11].size < 9 then
        bulk_command = bulk_command + add_dictionary("#{yomi}", "#{fields[0]}")
        i=i+1
      end
    end
    if i>=10000
      p "row size #{i} inserted #{Time.now}\n"
      bulk_command = execute_sql(db, bulk_command)
      bulk_command = ""
      i = 0
    end
  end
  execute_sql(db, bulk_command)
  p "row size #{i} inserted #{Time.now}\n"
ensure
  db.close
  p "end #{Time.now}\n"
end
