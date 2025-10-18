#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'time'
require 'date'

# Configuration via environment variables to keep the script self-contained.
FETCH_INTERVAL_SECONDS = (ENV['WAYBAR_CAL_FETCH_SECONDS'] || '60').to_i
DISPLAY_REFRESH_SECONDS = (ENV['WAYBAR_DISPLAY_REFRESH_SECONDS'] || '5').to_i
SWITCH_LEAD_MINUTES = (ENV['WAYBAR_SWITCH_LEAD_MINUTES'] || '15').to_i
LOOKAHEAD_DAYS = (ENV['WAYBAR_LOOKAHEAD_DAYS'] || '2').to_i
CALENDAR_ID = ENV['WAYBAR_CALENDAR']
GCALCLI_BIN = ENV['WAYBAR_GCALCLI_BIN'] || 'gcalcli'
LEAD_SECONDS = SWITCH_LEAD_MINUTES * 60

class FetchError < StandardError; end

# Representation of a calendar event returned by gcalcli.
class CalendarEvent
  attr_reader :start_time, :end_time, :title, :description, :conference_url

  def initialize(start_time:, end_time:, title:, description:, conference_url:)
    @start_time = start_time
    @end_time = end_time
    @title = title
    @description = description
    @conference_url = conference_url
  end

  def self.from_row(row)
    return nil if row['start_time'].to_s.strip.empty?

    start_date = row['start_date']
    start_time = parse_time(start_date, row['start_time'])
    end_time = if row['end_time'].to_s.strip.empty?
                 start_time + 3600
               else
                 end_date = row['end_date'].to_s.strip.empty? ? start_date : row['end_date']
                 parse_time(end_date, row['end_time'])
               end

    conference_url = extract_conference_url(row)

    new(
      start_time: start_time,
      end_time: end_time,
      title: row['title'].to_s.strip,
      description: row['description'].to_s.strip,
      conference_url: conference_url
    )
  rescue ArgumentError
    nil
  end

  def ongoing?(now = Time.now)
    start_time <= now && now < end_time
  end

  def upcoming?(now = Time.now)
    now < start_time
  end

  def minutes_until(now = Time.now)
    return 0 unless upcoming?(now)

    (((start_time - now) / 60.0)).ceil
  end

  def relative_label(now = Time.now)
    minutes = minutes_until(now)
    return 'Now' if minutes <= 0

    hours, mins = minutes.divmod(60)
    parts = []
    parts << "#{hours}h" if hours.positive?
    parts << "#{mins}m" if mins.positive? || parts.empty?
    parts.join
  end

  def service
    if conference_url&.match?(/meet\.google\.com/)
      'google-meet'
    elsif conference_url&.match?(/zoom\.us/)
      'zoom'
    elsif conference_url&.match?(/teams\.microsoft\.com/)
      'teams'
    else
      'default'
    end
  end

  def formatted_time
    start_time.strftime('%H:%M')
  end

  def formatted_range
    "#{start_time.strftime('%a %b %d %H:%M')} - #{end_time.strftime('%H:%M')}"
  end

  def <=>(other)
    start_time <=> other.start_time
  end

  TIME_FORMATS = [
    '%m/%d/%Y %H:%M',
    '%m/%d/%Y %H:%M:%S',
    '%m/%d/%Y %I:%M %p',
    '%m/%d/%Y %I:%M:%S %p',
    '%Y-%m-%d %H:%M',
    '%Y-%m-%d %H:%M:%S'
  ].freeze

  def self.parse_time(date_str, time_str)
    timestamp = "#{date_str} #{time_str}".strip
    TIME_FORMATS.each do |format|
      begin
        return Time.strptime(timestamp, format)
      rescue ArgumentError
        next
      end
    end
    raise ArgumentError, "Unparseable time #{timestamp.inspect}"
  end

  def self.extract_conference_url(row)
    explicit = row['conference_uri'].to_s.strip
    return explicit unless explicit.empty?

    description = row['description'].to_s
    link_match = description.match(%r{https?://[^\s>]+})
    link_match&.[](0)
  end
end

class CalendarFetcher
  def initialize(calendar_id:, lookahead_days:)
    @calendar_id = calendar_id
    @lookahead_days = lookahead_days
  end

  def fetch_events
    output = run_gcalcli
    parse_events(output)
  rescue Errno::ENOENT
    raise FetchError, 'gcalcli not found in PATH'
  end

  private

  def run_gcalcli
    start_time = Time.now
    end_time = start_time + @lookahead_days * 86_400
    from = start_time.strftime('%m/%d/%Y')
    to = end_time.strftime('%m/%d/%Y')

    args = [
      GCALCLI_BIN,
      'agenda',
      from,
      to,
      '--tsv',
      '--details', 'conference',
      '--details', 'description'
    ]
    args += ['--calendar', @calendar_id] if @calendar_id && !@calendar_id.empty?

    IO.popen(args, &:read).tap do
      status = $?.exitstatus
      raise FetchError, "gcalcli exited with #{status}" unless status&.zero?
    end
  end

  def parse_events(output)
    lines = output.to_s.split("\n").map(&:chomp)
    return [] if lines.empty?

    header = lines.shift.split("\t")
    lines.map do |line|
      row = header.zip(line.split("\t")).to_h
      CalendarEvent.from_row(row)
    end.compact.sort
  end
end

def select_events(now, events)
  current = events.find { |event| event.ongoing?(now) }
  upcoming = events.select { |event| event.upcoming?(now) }
  next_event = upcoming.first

  if next_event && (!current || (next_event.start_time - now <= LEAD_SECONDS))
    [:upcoming, next_event, next_event]
  elsif current
    [:current, current, next_event]
  elsif next_event
    [:upcoming, next_event, next_event]
  else
    [:none, nil, nil]
  end
end

def urgency_classes(minutes)
  classes = []
  classes << 'soon' if minutes <= 10
  classes << 'now' if minutes <= 2
  classes
end

def build_output(now, events, fetch_error)
  if fetch_error
    return {
      text: 'calendar error',
      class: ['error'],
      tooltip: fetch_error.message
    }
  end

  state, display_event, next_event = select_events(now, events)
  agenda_lines = events.select { |event| event.start_time.to_date == now.to_date && event.end_time > now }
                       .map { |event| "#{event.start_time.strftime('%H:%M')} - #{event.title}" }
  agenda_tooltip = agenda_lines.empty? ? 'Free time' : agenda_lines.join("\r")

  case state
  when :current
    minutes = display_event.minutes_until(now)
    text = "#{display_event.relative_label(now)} - #{display_event.title}"
    classes = ['current', display_event.service] + urgency_classes(minutes)
    {
      text: text,
      alt: display_event.service,
      class: classes.uniq,
      tooltip: agenda_tooltip
    }
  when :upcoming
    minutes = display_event.minutes_until(now)
    text = "#{display_event.relative_label(now)} - #{display_event.title}"
    classes = ['upcoming', display_event.service] + urgency_classes(minutes)
    {
      text: text,
      alt: display_event.service,
      class: classes.uniq,
      tooltip: agenda_tooltip
    }
  else
    {
      text: '',
      class: ['empty'],
      tooltip: agenda_tooltip
    }
  end
end

if $PROGRAM_NAME == __FILE__
  fetcher = CalendarFetcher.new(calendar_id: CALENDAR_ID, lookahead_days: LOOKAHEAD_DAYS)
  events_store = []
  fetch_error = nil
  next_fetch_at = Time.at(0)

  running = true
  %w[INT TERM].each do |signal|
    trap(signal) { running = false }
  end

  while running
    now = Time.now

    if now >= next_fetch_at
      begin
        events_store = fetcher.fetch_events
        fetch_error = nil
      rescue FetchError => e
        warn e.message
        fetch_error = e
      ensure
        next_fetch_at = Time.now + FETCH_INTERVAL_SECONDS
      end
    end

    output = build_output(Time.now, events_store, fetch_error)
    puts JSON.generate(output)
    STDOUT.flush

    sleep DISPLAY_REFRESH_SECONDS
  end
end
