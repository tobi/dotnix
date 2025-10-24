#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'
require 'json'

def year_progress_percentage
  today = Date.today
  start_of_year = Date.new(today.year, 1, 1)
  end_of_year = Date.new(today.year, 12, 31)

  # Calculate days elapsed and total days in year
  days_elapsed = (today - start_of_year).to_i + 1 # +1 because we want inclusive
  total_days = (end_of_year - start_of_year).to_i + 1

  # Calculate percentage
  percentage = (days_elapsed.to_f / total_days * 100).round(1)

  {
    text: "#{percentage}%",
    tooltip: "#{days_elapsed}/#{total_days} days (#{percentage}% of #{today.year} complete)",
    class: ['year-progress']
  }
end

if $PROGRAM_NAME == __FILE__
  output = year_progress_percentage
  puts JSON.generate(output)
end
