use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or you later on).

# Configure your database
config :vr, Vr.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "smtp.126.com",
  port: 25,
  username: "soarpatriot@126.com",
  password: "soar@1116",
  tls: :if_available, # can be `:always` or `:never`
  ssl: false, # can be `true`
  retries: 1
