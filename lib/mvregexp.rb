# This is a wrapper around a Regexp object, with
# some handy added methods for further functionality
class MVRegexp
  # The regexp we'll be matching against
  attr_accessor :regexp

  # This is the string that we'll be replacing it with
  attr_accessor :replace

  # Creates a new MVRegexp with a find string (converted to regular expression) and a replacement string
  # @param find [String] a string with the pattern we should find. Does not require ^ or $ on either end - these are added automatically
  # @param replace [String] the string to replace it with. $1 is expanded to match 1. $(1) is also expanded to match 1. $$ is a normal dollar sign
  def initialize find, replace
    @regexp = Regexp.new("^#{find}$")
    @replace = replace
  end

  # Matches a string and returns match data
  # @param filename [String] a file name to match
  # @return [MatchData, Array] a MatchData object or nil if the file doesn't match
  def match_against filename
      @regexp.match(filename)
  end

  # Performs subsitution based on the match data passed.
  # @param match_data [MatchData] a set of regexp match data, usually obtained via `match_against`
  # @return [String] the file name
  def populate_based_on match_data
    # We need to gsub three things:
    gsub_lambdas = {
      /(?<!\$)\$\d+/ => lambda{ |m| match_data[m[1..-1].to_i] }, # Simple $1 => match 1
      /(?<!\$)\$\(.*?\)/ => lambda{ |m| match_data[m[2..-2].to_i] }, # Somewhat more complex $(1) => match 1
      '$$' => lambda{ |m| '$' } # Real simple $$ => $
    }

    return gsub_lambdas.reduce(replace){ |replace, (replace_this, with_this)| replace.gsub(replace_this, &with_this) }
  end

  # Runs on a number of files, returning what they should be renamed as
  # @param [Array] files
  # @return [Hash] the listing of transformations. Files that don't match aren't included in this listing.
  def [] files
    # This stores all our matches
    match_hash = {}

    # Go through each file, check if the file basename matches the regexp.
    files.each do |f|
      path, file = File.split(f)

      if (m = match_against(file))
        replacement = populate_based_on(m)
        match_hash[f] = if path == '.'
          replacement
        else
          File.join(path, replacement)
        end
      end
    end
    match_hash
  end
end
