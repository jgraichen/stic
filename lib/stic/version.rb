module Stic
  module VERSION
    MAJOR = 0
    MINOR = 1
    PATCH = 0
    STAGE = 0
    STRING= [MAJOR, MINOR, PATCH, STAGE].reject(&:nil?).join(".").freeze

    def self.to_s; STRING end
  end
end
