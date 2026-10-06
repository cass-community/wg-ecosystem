# frozen_string_literal: true

# Generates ICS calendar files at build time:
#   /calendar/<series-id>.ics   one per recurring series in site.config.yml
#   /calendar/<slug>.ics        one per upcoming event that has a time
# UIDs are stable, so re-importing a file updates the entry rather than
# duplicating it. Runs after events.rb (priority :low).

require "date"

module WgEcosystem
  ZONES = {
    "America/New_York"    => ["EST", "EDT", -5],
    "America/Chicago"     => ["CST", "CDT", -6],
    "America/Denver"      => ["MST", "MDT", -7],
    "America/Los_Angeles" => ["PST", "PDT", -8]
  }.freeze
  DAYS = %w[SU MO TU WE TH FR SA].freeze

  class CalendarGenerator < Jekyll::Generator
    safe true
    priority :low

    def generate(site)
      @site = site
      @tz = site.config["timezone"].to_s
      unless ZONES.key?(@tz)
        Jekyll.logger.abort_with("Calendar:", "timezone '#{@tz}' is not supported for ICS output " \
                                 "(supported: #{ZONES.keys.join(', ')}); add its VTIMEZONE rules in _plugins/calendar.rb")
      end
      @host = "#{site.config.dig('group', 'slug') || 'wg'}.cass.community"
      series_ics(site)
      event_ics(site)
    end

    private

    def series_ics(site)
      links = []
      (site.config["series"] || []).each do |s|
        id = s["id"].to_s
        if todo?(s["rrule"]) || todo?(s["start_time"])
          Jekyll.logger.warn("Calendar:", "series '#{id}' has no rrule/start_time yet; no ICS generated")
          links << { "id" => id, "name" => s["name"], "url" => nil }
          next
        end
        zoom = zoom_for(s["zoom"], "series '#{id}'")
        first = first_date(s)
        h, m = s["start_time"].to_s.split(":").map(&:to_i)
        dur = s["duration_minutes"] || 60
        start = Time.local(first.year, first.month, first.day, h, m)
        ev = vevent(uid: "#{id}@#{@host}", summary: s["name"], start: start, minutes: dur,
                    zoom: zoom, extra: ["RRULE:#{s['rrule']}"])
        add_file(site, "calendar", "#{id}.ics", calendar(ev))
        links << { "id" => id, "name" => s["name"], "url" => "#{site.baseurl}/calendar/#{id}.ics", "zoom" => zoom }
      end
      site.data["series_ics"] = links
    end

    def event_ics(site)
      zoom_series = (site.config["series"] || []).find { |s| s["id"] == site.config["event_zoom_series"] }
      zoom = zoom_series && zoom_for(zoom_series["zoom"], "event_zoom_series")
      now = Time.now
      (site.data["events_all"] || []).each do |e|
        next unless e["timed"] && e["ends_at"] > now

        page_url = "#{site.config['url']}#{e['url']}"
        ev = vevent(uid: "#{e['slug']}@#{@host}", summary: e["title"], start: e["starts_at"],
                    minutes: e["duration_minutes"], zoom: zoom, description: e["description"], link: page_url)
        add_file(site, "calendar", "#{e['slug']}.ics", calendar(ev))
        e["ics_url"] = "#{site.baseurl}/calendar/#{e['slug']}.ics"
      end
    end

    def todo?(v)
      v.nil? || v.to_s.strip.empty? || v.to_s.start_with?("TODO")
    end

    def zoom_for(v, what)
      return v.to_s if v.to_s.start_with?("http")

      Jekyll.logger.warn("Calendar:", "#{what} has no Zoom link yet; ICS will omit it")
      nil
    end

    # First occurrence on or after the season start (or today).
    def first_date(s)
      return Date.parse(s["first_date"].to_s) if s["first_date"]

      rule = s["rrule"].to_s
      by = rule[/BYDAY=([1-4])(SU|MO|TU|WE|TH|FR|SA)/, 0]
      unless rule.include?("FREQ=MONTHLY") && by
        Jekyll.logger.abort_with("Calendar:", "series '#{s['id']}': can't derive the first date from rrule '#{rule}'; " \
                                 "set first_date (YYYY-MM-DD) on the series")
      end
      n = rule[/BYDAY=(\d)/, 1].to_i
      wday = DAYS.index(rule[/BYDAY=\d(\w\w)/, 1])
      months = rule[/BYMONTH=([\d,]+)/, 1]&.split(",")&.map(&:to_i)
      from = season_start
      d = Date.new(from.year, from.month, 1)
      36.times do
        if months.nil? || months.include?(d.month)
          day = d + ((wday - d.wday) % 7) + 7 * (n - 1)
          return day if day.month == d.month && day >= from
        end
        d = d >> 1
      end
      Jekyll.logger.abort_with("Calendar:", "series '#{s['id']}': no occurrence found for rrule '#{rule}'")
    end

    def season_start
      page = @site.pages.find { |p| p.path == "seasons/#{@site.config['current_season']}/season.md" }
      raw = page && page.data["starts"].to_s
      raw && raw =~ /\A(\d{4})-(\d{2})/ ? Date.new($1.to_i, $2.to_i, 1) : Date.today
    end

    def stamp(t) = t.strftime("%Y%m%dT%H%M%S")

    def vevent(uid:, summary:, start:, minutes:, zoom:, description: nil, link: nil, extra: [])
      lines = ["BEGIN:VEVENT", "UID:#{uid}", "DTSTAMP:#{Time.now.utc.strftime('%Y%m%dT%H%M%SZ')}",
               "DTSTART;TZID=#{@tz}:#{stamp(start)}", "DTEND;TZID=#{@tz}:#{stamp(start + minutes * 60)}"]
      lines += extra
      lines << "SUMMARY:#{esc(summary)}"
      desc = []
      desc << description if description
      desc << "Join on Zoom: #{zoom}" if zoom
      desc << "Details: #{link}" if link
      lines << "DESCRIPTION:#{esc(desc.join("\n"))}" unless desc.empty?
      lines << "LOCATION:#{esc(zoom)}" if zoom
      lines << "URL:#{link}" if link
      lines << "END:VEVENT"
      lines
    end

    def calendar(vevent_lines)
      std, dst, off = WgEcosystem::ZONES[@tz]
      fmt = ->(h) { format("%+03d00", h) }
      tz = [
        "BEGIN:VTIMEZONE", "TZID:#{@tz}",
        "BEGIN:DAYLIGHT", "TZOFFSETFROM:#{fmt.call(off)}", "TZOFFSETTO:#{fmt.call(off + 1)}", "TZNAME:#{dst}",
        "DTSTART:19700308T020000", "RRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=2SU", "END:DAYLIGHT",
        "BEGIN:STANDARD", "TZOFFSETFROM:#{fmt.call(off + 1)}", "TZOFFSETTO:#{fmt.call(off)}", "TZNAME:#{std}",
        "DTSTART:19701101T020000", "RRULE:FREQ=YEARLY;BYMONTH=11;BYDAY=1SU", "END:STANDARD",
        "END:VTIMEZONE"
      ]
      all = ["BEGIN:VCALENDAR", "VERSION:2.0", "PRODID:-//CASS//wg-ecosystem//EN", "CALSCALE:GREGORIAN"] +
            tz + vevent_lines + ["END:VCALENDAR"]
      all.flat_map { |l| fold(l) }.join("\r\n") + "\r\n"
    end

    def esc(s)
      s.to_s.gsub(/[\\;,\n]/) { |c| c == "\n" ? "\\n" : "\\#{c}" }
    end

    # RFC 5545: lines are at most 75 octets; continuation lines start with a space.
    def fold(line)
      out = []
      cur = +""
      line.each_char do |c|
        limit = out.empty? ? 75 : 74
        if cur.bytesize + c.bytesize > limit
          out << cur
          cur = +""
        end
        cur << c
      end
      out << cur
      out.each_with_index.map { |l, i| i.zero? ? l : " #{l}" }
    end

    def add_file(site, dir, name, content)
      page = Jekyll::PageWithoutAFile.new(site, site.source, dir, name)
      page.content = content
      page.data["layout"] = nil
      page.data["render_with_liquid"] = false
      page.data["sitemap"] = false
      site.pages << page
    end
  end
end
