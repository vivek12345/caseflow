# frozen_string_literal: true

# Service to profile a web request.
class ProfilerService
  class << self
    def profile(request)
      result = profile_route { yield }

      callgrind_report(result, request)
      html_report(result)
    end

    private

    def profile_route
      profile = RubyProf::Profile.new
      profile.exclude_common_methods!
      profile.start
      yield
      profile.stop
    end

    def html_report(result)
      out = StringIO.new
      RubyProf::GraphHtmlPrinter.new(result).print(out, min_percent: 0.5)
      out.string
    end

    def callgrind_report(result, request)
      timestamp = Time.zone.now.strftime("%Y-%m-%d-%H-%M-%S")
      benchmark_folder = "profile/#{request.path_info.parameterize}"

      FileUtils.mkdir_p(benchmark_folder)

      RubyProf::CallTreePrinter.new(result).print(profile: "#{benchmark_folder}/#{timestamp}-profile")
    end
  end
end
