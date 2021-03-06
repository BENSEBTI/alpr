require "alpr/version"

require 'shellwords'
require 'JSON'


class Alpr
  attr_reader :region, :max, :glob, :output, :command

  def initialize(file, region = :detect, max = 10, glob = false)
    @file = file
    @region = region
    @max = max
    @glob = glob

    @output = []
    begin
      if @glob
        Dir.glob(glob).each do |picture|
          @output.push  JSON.parse(checkFile(picture))
        end
      else
        @output = JSON.parse(checkFile(file))
      end
    rescue JSON::ParserError
      @output = nil
    end
  end

  private

  def checkFile(file)
    @command = "alpr -j -n #{@max} #{regionString} #{Shellwords.shellescape file}"
    `#{@command}`
  end

  def regionString
    case @region
    when :us
      "-c us"
    when :eu
      "-c eu"
    when :dz
      "-c dz"
    when :au
      "-c au"
    when :detect
      "--detect_region"
    else
      ""
    end
  end
end
