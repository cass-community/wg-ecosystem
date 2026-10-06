# frozen_string_literal: true

# Reads resources/*.md (one file per resource), validates the front matter, and
# exposes the list, newest first, as site.data.resources_all for resources.md.
# Files starting with "_" are ignored. There is no per-resource page: each entry
# links straight to its url or hosted file.

require "yaml"
require "date"

module WgEcosystem
  KINDS = {
    "white-paper" => "White paper",
    "article" => "Article",
    "report" => "Report",
    "link" => "Link"
  }.freeze

  class ResourceGenerator < Jekyll::Generator
    safe true
    priority :low

    def generate(site)
      list = Dir.glob(File.join(site.source, "resources", "*.md")).sort.map do |path|
        next if File.basename(path).start_with?("_")

        load_resource(site, path)
      end.compact
      site.data["resources_all"] = list.sort_by { |r| [r["date"], r["title"].downcase] }.reverse
    end

    private

    def fail_file(rel, msg)
      Jekyll.logger.abort_with("Resource validation:", "#{rel}: #{msg}")
    end

    def blank?(v) = v.nil? || v.to_s.strip.empty?

    def load_resource(site, path)
      rel = path.sub("#{site.source}/", "")
      m = File.read(path).match(WgEcosystem::FRONT_MATTER_RE)
      fail_file(rel, "missing YAML front matter (--- block at the top)") unless m
      begin
        fm = YAML.safe_load(m[1], permitted_classes: [Date, Time]) || {}
      rescue Psych::Exception => e
        fail_file(rel, "front matter is not valid YAML: #{e.message}")
      end
      fail_file(rel, "front matter must be a set of key: value pairs") unless fm.is_a?(Hash)

      %w[title kind authors date description].each do |f|
        fail_file(rel, "missing required field '#{f}'") if blank?(fm[f]) || (fm[f].is_a?(Array) && fm[f].reject { |x| blank?(x) }.empty?)
      end
      fail_file(rel, "field 'tags' is required (a list; may be empty: tags: [])") unless fm.key?("tags") && fm["tags"].is_a?(Array)
      unless KINDS.key?(fm["kind"])
        fail_file(rel, "field 'kind' is '#{fm['kind']}'; must be one of #{KINDS.keys.join(', ')}")
      end
      fail_file(rel, "field 'authors' must be a list") unless fm["authors"].is_a?(Array)

      date = fm["date"]
      date = date.iso8601 if date.is_a?(Date)
      unless date.to_s =~ /\A(\d{4})-(\d{2})-(\d{2})\z/ && Date.valid_date?($1.to_i, $2.to_i, $3.to_i)
        fail_file(rel, "field 'date' is '#{fm['date']}'; use YYYY-MM-DD")
      end

      has_url = !blank?(fm["url"])
      has_file = !blank?(fm["file"])
      fail_file(rel, "set exactly one of 'url' or 'file' (neither is set)") if !has_url && !has_file
      fail_file(rel, "set exactly one of 'url' or 'file' (both are set)") if has_url && has_file

      link = if has_url
               fm["url"].to_s.strip
             else
               file = fm["file"].to_s.strip.sub(%r{\A\./}, "")
               unless File.file?(File.join(site.source, "resources", file))
                 fail_file(rel, "field 'file' points to 'resources/#{file}', which does not exist")
               end
               "#{site.baseurl}/resources/#{file}"
             end

      related = nil
      unless blank?(fm["related_event"])
        slug = File.basename(fm["related_event"].to_s, ".md")
        ev = (site.data["events_all"] || []).find { |e| e["slug"] == slug }
        if ev
          related = { "title" => ev["title"], "url" => ev["url"] }
        else
          Jekyll.logger.warn("Resource check:", "#{rel}: related_event '#{fm['related_event']}' matches no event")
        end
      end

      {
        "title" => fm["title"].to_s,
        "kind" => fm["kind"],
        "kind_label" => KINDS[fm["kind"]],
        "authors" => fm["authors"].map(&:to_s),
        "date" => date,
        "tags" => fm["tags"].map(&:to_s),
        "description" => fm["description"].to_s.strip,
        "href" => link,
        "external" => has_url,
        "related_event" => related,
        "source" => rel
      }
    end
  end
end
