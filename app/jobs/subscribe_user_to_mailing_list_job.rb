require 'digest/md5'

class SubscribeUserToMailingListJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    email = args[0][:email].present? ? args[0][:email] : ""
    name  = args[0][:name].present? ? args[0][:name] : ""

    if email.present? and name.present?
      # need lower case of email
      email = email.downcase

      # create the md5 hash
      email_md5_hash = Digest::MD5.hexdigest(email)

      # an upsert will create if not exists / update
      gb = Gibbon::Request.new
      gb.lists(ENV["MAILCHIMP_LIST_ID"]).members(email_md5_hash).upsert(body: {email_address: email, status: "subscribed", merge_fields: {FNAME: name}})
    else
      puts "User was not added to mailing list::::args: " + args.inspect
    end
  end
end
