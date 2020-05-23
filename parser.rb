# frozen_string_literal: true

require 'date'
require 'terminal-table'

REGEX = /^(?<date>\d+ \w+ \d{2}:\d{2}:\d{2}) (?<action>Buy|Sell) (?<amount>\d+)✕(?<symbol>\w+)\s+@\s(?<price>.*)$/.freeze

def transform_data(data)
  symbols = data.map { |e| e['symbol'] }.uniq
  new_data = {}
  symbols.each do |symbol|
    data_for_symbol = data.find_all { |e| e['symbol'] == symbol }
    sorted = data_for_symbol.sort! { |a, b| a['date'] <=> b['date'] }
    new_data[symbol] = sorted
  end
  new_data
end

data = {}
File.open('./raw.txt', 'r').each_line do |line|
  next unless (matches = line.match(REGEX).named_captures)

  date = Date.parse(matches['date'])
  day = date.strftime('%Y %m %d')
  data[day] = [] unless data[day]
  data[day].push(matches)
end

data.each do |key, value|
  value = transform_data(value)
  daily_total = 0.0
  trade_count = 0
  value.each do |symbol, entries|
    symbol_total = 0.0
    rows = []
    entries.each do |entry|
      row = [
        entry['date'],
        entry['action'],
        entry['symbol'],
        entry['amount'],
        entry['price']
      ]
      direction = entry['action'] == 'Buy' ? -1 : 1
      symbol_total += (entry['amount'].to_i * entry['price'].to_f * direction)
      trade_count += 1
      rows << row
    end
    daily_total += symbol_total

    table = Terminal::Table.new(
      title: "#{symbol} - #{key}",
      headings: %w[Date Action Symbol Amount Price],
      rows: rows
    )
    puts table
    puts "P/L: #{symbol_total}"
    puts ''
  end

  broker_fees = trade_count * 3.00
  summary_table = Terminal::Table.new(
    title: "Summary for #{key}",
    headings: %w[Name Value],
    rows: [
      ['Daily Total', daily_total],
      ['Trade Count', trade_count],
      ['Broker Fees', broker_fees],
      ['Total minus fees', daily_total - broker_fees]
    ]
  )
  puts summary_table
end
