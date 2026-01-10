#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'time'
require 'date'

# Configuration via environment variables
SWITCH_LEAD_MINUTES = (ENV['WAYBAR_SWITCH_LEAD_MINUTES'] || '15').to_i
LEAD_SECONDS = SWITCH_LEAD_MINUTES * 60

class CalendarEvent
  attr_reader :start_time, :end_time, :title, :description, :conference_url, :calendar

  def initialize(start_time:, end_time:, title:, description:, conference_url:, calendar:, service:)
    @start_time = start_time
    @end_time = end_time
    @title = title
    @description = description
    @conference_url = conference_url
    @calendar = calendar
    @service = service
  end

  def self.from_hash(hash)
    new(
      start_time: Time.parse(hash['start_time']),
      end_time: Time.parse(hash['end_time']),
      title: hash['title'],
      description: hash['description'],
      conference_url: hash['conference_url'],
      calendar: hash['calendar'],
      service: hash['service']
    )
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

  def minutes_remaining(now = Time.now)
    return 0 unless ongoing?(now)

    (((end_time - now) / 60.0)).ceil
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

  def remaining_label(now = Time.now)
    minutes = minutes_remaining(now)
    return 'Done' if minutes <= 0

    hours, mins = minutes.divmod(60)
    parts = []
    parts << "#{hours}h" if hours.positive?
    parts << "#{mins}m" if mins.positive? || parts.empty?
    parts.join + ' left'
  end

  def formatted_time
    start_time.strftime('%H:%M')
  end

  def formatted_range
    "#{start_time.strftime('%a %b %d %H:%M')} - #{end_time.strftime('%H:%M')}"
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

  def <=>(other)
    start_time <=> other.start_time
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

def escape_markup(text)
  text.to_s
      .gsub('&', '&amp;')
      .gsub('<', '&lt;')
      .gsub('>', '&gt;')
      .gsub('"', '&quot;')
      .gsub("'", '&apos;')
end

def format_tooltip(now, events)
  # Show all events for the next 2 days
  end_time = now + (2 * 86_400)
  upcoming_events = events.select { |event| event.start_time >= now && event.start_time < end_time }

  return 'No upcoming events' if upcoming_events.empty?

  lines = []
  current_date = nil

  upcoming_events.each do |event|
    event_date = event.start_time.to_date

    # Add date separator when date changes
    if event_date != current_date
      date_emoji = if event_date == now.to_date
                     '📅'
                   elsif event_date == (now + 86_400).to_date
                     '📆'
                   else
                     '🗓️'
                   end

      date_label = if event_date == now.to_date
                     'Today'
                   elsif event_date == (now + 86_400).to_date
                     'Tomorrow'
                   else
                     event_date.strftime('%A, %b %d')
                   end

      lines << '' unless lines.empty? # Add blank line before new date
      lines << "─── #{date_emoji} #{date_label} ───"
      current_date = event_date
    end

    safe_title = escape_markup(event.title)
    safe_calendar = escape_markup(event.calendar)
    calendar_prefix = safe_calendar.empty? ? '' : "[#{safe_calendar}] "
    lines << "#{event.start_time.strftime('%H:%M')} - #{calendar_prefix}#{safe_title}"
  end

  lines.join("\r")
end

def build_output(now, events, fetch_error)
  if fetch_error
    return {
      text: '󰸗 error',
      class: ['error'],
      tooltip: fetch_error
    }
  end

  state, display_event, = select_events(now, events)
  tooltip = format_tooltip(now, events)

  case state
  when :current
    minutes = display_event.minutes_remaining(now)
    safe_title = escape_markup(display_event.title)
    safe_calendar = escape_markup(display_event.calendar)
    calendar_prefix = safe_calendar.empty? ? '' : "[#{safe_calendar}] "
    text = "󰸗 #{display_event.remaining_label(now)} - #{calendar_prefix}#{safe_title}"
    classes = ['current', display_event.service] + urgency_classes(minutes)
    {
      text: text,
      alt: display_event.service,
      class: classes.uniq,
      tooltip: tooltip
    }
  when :upcoming
    minutes = display_event.minutes_until(now)
    event_date = display_event.start_time.to_date
    today = now.to_date
    tomorrow = (now + 86_400).to_date

    # If event is today but more than 8 hours away, or tomorrow, hide module
    if (event_date == today && minutes > 480) || event_date == tomorrow
      return {
        text: '',
        class: ['empty'],
        tooltip: tooltip
      }
    end

    safe_title = escape_markup(display_event.title)
    safe_calendar = escape_markup(display_event.calendar)
    calendar_prefix = safe_calendar.empty? ? '' : "[#{safe_calendar}] "
    text = "󰸗 in #{display_event.relative_label(now)}: #{calendar_prefix}#{safe_title}"
    classes = ['upcoming', display_event.service] + urgency_classes(minutes)
    {
      text: text,
      alt: display_event.service,
      class: classes.uniq,
      tooltip: tooltip
    }
  else
    {
      text: '',
      class: ['empty'],
      tooltip: tooltip
    }
  end
end

if $PROGRAM_NAME == __FILE__
  cache_file = File.expand_path('~/.cache/agenda.json')

  begin
    if File.exist?(cache_file)
      agenda_data = JSON.parse(File.read(cache_file))
      events = agenda_data['events'].map { |hash| CalendarEvent.from_hash(hash) }
      fetch_error = agenda_data['error']
    else
      events = []
      fetch_error = 'No cached agenda data'
    end
  rescue JSON::ParserError, Errno::ENOENT
    events = []
    fetch_error = 'Failed to read cached agenda data'
  end

  output = build_output(Time.now, events, fetch_error)
  puts JSON.generate(output)
end
