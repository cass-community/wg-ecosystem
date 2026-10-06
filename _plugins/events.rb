# frozen_string_literal: true

# Turns seasons/<season>/events/*.md into event pages and attaches the
# upcoming/past lists to each season page. Validates front matter and aborts
# the build with a message naming the file and field.
#
# Files starting with "_" (e.g. _template.md) are ignored. Artifacts live in a
# folder beside the event file with the same name (minus .md); Jekyll copies
# that folder as static files, and links written as ./<slug>/file.pdf are
# rewritten to be relative to the event's own page.

require "yaml"
require "date"

module WgEcosystem
  TYPES = {
    "talk" => "Talk",
    "panel" => "Panel",
    "working-group-session" => "Working group session"
  }.freeze
  ROLES = %w[presenter panelist moderator].freeze
  DATE_RE = /\A(\d{4})-(\d{2})-(\d{2})(?:T(\d{2}):(\d{2}))?\z/.freeze
  FRONT_MATTER_RE = /\A---\s*\n(.*?)\n---\s*(?:\n|\z)(.*)\z/m.freeze

  def self.fail_file(rel, msg)
    Jekyll.logger.abort_with("Event validation:", "#{rel}: #{msg}")
  end

  class Generator < Jekyll::Generator
    safe true
    priority :normal

    def generate(site)
      @site = site
      by_season = Hash.new { |h, k| h[k] = [] }
      site.data["events_all"] = []

      Dir.glob(File.join(site.source, "seasons", "*", "events", "*.md")).sort.each do |path|
        next if File.basename(path).start_with?("_")

        event = load_event(path)
        by_season[event["season"]] << event
        site.data["events_all"] << event
        site.pages << build_page(site, event)
      end

      site.pages.select { |p| p.path.match?(%r{\Aseasons/[^/]+/season\.md\z}) }.each do |page|
        season = page.path.split("/")[1]
        events = by_season[season]
        now = Time.now
        upcoming, past = events.partition { |e| e["ends_at"] > now }
        page.data["layout"] = "season"
        page.data["upcoming"] = upcoming.sort_by { |e| e["starts_at"] }
        page.data["past"] = past.sort_by { |e| e["starts_at"] }.reverse
      end
    end

    private

    def load_event(path)
      rel = path.sub("#{@site.source}/", "")
      m = File.read(path).match(FRONT_MATTER_RE)
      WgEcosystem.fail_file(rel, "missing YAML front matter (--- block at the top)") unless m
      begin
        fm = YAML.safe_load(m[1], permitted_classes: [Date, Time]) || {}
      rescue Psych::Exception => e
        WgEcosystem.fail_file(rel, "front matter is not valid YAML: #{e.message}")
      end
      WgEcosystem.fail_file(rel, "front matter must be a set of key: value pairs") unless fm.is_a?(Hash)

      %w[title type date people description].each do |f|
        v = fm[f]
        WgEcosystem.fail_file(rel, "missing required field '#{f}'") if v.nil? || (v.respond_to?(:empty?) && v.empty?) || v.to_s.strip.empty?
      end
      unless WgEcosystem::TYPES.key?(fm["type"])
        WgEcosystem.fail_file(rel, "field 'type' is '#{fm['type']}'; must be one of #{WgEcosystem::TYPES.keys.join(', ')}")
      end

      starts_at, timed = parse_date(rel, fm["date"])
      duration = fm.fetch("duration_minutes", 60)
      unless duration.is_a?(Integer) && duration.positive?
        WgEcosystem.fail_file(rel, "field 'duration_minutes' must be a positive whole number")
      end
      ends_at = timed ? starts_at + duration * 60 : starts_at + 86_400 # date-only: through end of that day

      people = validate_people(rel, fm["people"])

      slug = File.basename(path, ".md")
      season = path.split("/")[-3]
      date_str = starts_at.strftime("%Y-%m-%d")
      unless slug.start_with?(date_str)
        Jekyll.logger.warn("Event check:", "#{rel}: filename date does not match front matter date #{date_str}")
      end

      body = m[2].gsub("./#{slug}/", "./")
      {
        "title" => fm["title"].to_s,
        "type" => fm["type"],
        "type_label" => WgEcosystem::TYPES[fm["type"]],
        "date" => date_str,
        "date_display" => timed ? starts_at.strftime("%B %-d, %Y, %-l:%M %P %Z") : starts_at.strftime("%B %-d, %Y"),
        "timed" => timed,
        "duration_minutes" => duration,
        "people" => people,
        "description" => fm["description"].to_s.strip,
        "season" => season,
        "slug" => slug,
        "url" => "#{@site.baseurl}/seasons/#{season}/events/#{slug}/",
        "starts_at" => starts_at,
        "ends_at" => ends_at,
        "body" => body,
        "source" => rel
      }
    end

    def parse_date(rel, raw)
      s = raw.is_a?(Date) && !raw.is_a?(DateTime) ? raw.iso8601 : raw.to_s
      if raw.is_a?(Time) || raw.is_a?(DateTime)
        WgEcosystem.fail_file(rel, "field 'date' must be YYYY-MM-DD or YYYY-MM-DDTHH:MM, not '#{raw}'")
      end
      m = s.match(WgEcosystem::DATE_RE)
      WgEcosystem.fail_file(rel, "field 'date' is '#{s}'; use YYYY-MM-DD or YYYY-MM-DDTHH:MM") unless m
      y, mo, d, h, mi = m.captures.map { |x| x&.to_i }
      WgEcosystem.fail_file(rel, "field 'date' '#{s}' is not a real calendar date") unless Date.valid_date?(y, mo, d)
      if h && (h > 23 || mi > 59)
        WgEcosystem.fail_file(rel, "field 'date' '#{s}' has an invalid time")
      end
      timed = !h.nil?
      [Time.local(y, mo, d, h || 0, mi || 0), timed]
    end

    def validate_people(rel, people)
      WgEcosystem.fail_file(rel, "field 'people' must be a list") unless people.is_a?(Array)
      people.each_with_index do |p, i|
        WgEcosystem.fail_file(rel, "people[#{i}] must have 'name' and 'role'") unless p.is_a?(Hash)
        WgEcosystem.fail_file(rel, "people[#{i}] is missing 'name'") if p["name"].to_s.strip.empty?
        unless WgEcosystem::ROLES.include?(p["role"])
          WgEcosystem.fail_file(rel, "people[#{i}] role is '#{p['role']}'; must be one of #{WgEcosystem::ROLES.join(', ')}")
        end
      end
      people.map { |p| { "name" => p["name"].to_s, "role" => p["role"], "affiliation" => p["affiliation"].to_s } }
    end

    def build_page(site, event)
      dir = "seasons/#{event['season']}/events/#{event['slug']}"
      page = Jekyll::PageWithoutAFile.new(site, site.source, dir, "index.md")
      page.content = event["body"]
      page.data.merge!(
        "layout" => "event",
        "header" => { "overlay_filter" => "rgba(0, 146, 202, 0.75)",
                      "overlay_image" => "/assets/images/cass-word-1280x384-transparent.png" },
        "classes" => "wide no-left-sidebar",
        "title" => event["title"],
        "event" => event,
        "season_label" => event["season"]
      )
      page
    end
  end
end
