module Transferchat
  VERSION = ENV.fetch("APP_VERSION", "development")
  DEPLOYED_AT = ENV.fetch("DEPLOYED_AT", Time.current.to_s)
end
