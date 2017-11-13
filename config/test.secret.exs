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
#
config :vr, Vr.Mailer,
  #adapter: Bamboo.MailgunAdapter,
  domain: "mail.dreamreality.cn",
  adapter: Bamboo.AliyunAdapter,
  uri: "https://dm.aliyuncs.com",
  version: "2015-11-23",
  region_id: "cn-hangzhou",
  access_key_id: "HhBbxlBtSk0rL5wm",
  account_name: "admin@mail.dreamreality.cn",
  access_key_secret: "YJrHRqxAfpC2xmc6DT04SWgc4tPr5c",
  address_type: 1,
  reply_to_address: false,
  click_trace: 1
