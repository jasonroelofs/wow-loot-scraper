require 'rubygems'
require 'hpricot'
require 'open-uri'

# Read the various dungeon pages on wow-loot.com, parse, and build up
# usable Lua tables with the found information

PAGES = [
  %w(Naxxramas-Normal raid_naxx10.htm),
  %w(Naxxramas-Heroic raid_naxx25.htm),
  %w(OS-Normal raid_obsidian10.htm),
  %w(OS-Heroic raid_obsidian25.htm),
  %w(EOE-Normal raid_eternity10.htm),
  %w(EOE-Heroic raid_eternity25.htm)
].freeze

# Given a td row, parse through the images and
# return a list of strings representing the classes / specs
# this item is for
def parse_classes_from(node)
  found = []
  node.search("img").each do |image|
    found << image.get_attribute("alt")
  end

  found
end

items = []

PAGES.each do |use|

  puts "Scraping loot for #{use[0]}"

  doc = open("http://wow-loot.com/#{use[1]}") { |f|
    Hpricot(f)
  }

  doc.search("td.wowrowtitle").each do |row|
    item = []

    # Item id
    x = row.next_sibling
    next if x.nil? || x.at("a").nil?
    item << x.at("a").get_attribute("href").split("?item=")[1]

    # Primary classes
    x = x.next_sibling
    item << parse_classes_from(x)

    # Secondary classes
    x = x.next_sibling
    item << parse_classes_from(x)

    # Tertiary classes
    x = x.next_sibling
    item << parse_classes_from(x)

    items << item
  end

end

File.open("items.lua", "w+") do |f|
  f.puts %q(WowLootItems = {)

  items.each do |item|
    f.puts %Q(\t["#{item[0]}"] = {)
    f.puts %Q(\t\t["Primary"] = "#{item[1].join(", ")}",)
    f.puts %Q(\t\t["Secondary"] = "#{item[2].join(", ")}",)
    f.puts %Q(\t\t["Tertiary"] = "#{item[3].join(", ")}",)
    f.puts "\t},"
  end

  f.puts "}"
end
