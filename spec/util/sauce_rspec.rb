module SauceRSpec
  class Config
    def sauce?
      true
    end

    def caps
      { yes: true }
    end
  end

  def self.config
    @config ||= SauceRSpec::Config.new
  end
end
