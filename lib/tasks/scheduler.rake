desc "This task is called by the Heroku scheduler add-on to pull the Newletter and Charleston Master List Members"
task :update_members => :environment do
  gibbon = Gibbon::Request.new

  response = gibbon.lists("c01d6cdf23").members.retrieve(params: {"count": "99999999"})
  NewsLetterMember.delete_all

  response.body["members"].each do |res|
	  newsletter_memeber = NewsLetterMember.new
	  newsletter_memeber.email = res["email_address"]
	  newsletter_memeber.first_name = res["merge_fields"]["FNAME"]
	  newsletter_memeber.last_name = res["merge_fields"]["LNAME"]
	  newsletter_memeber.status = res["status"]
	  newsletter_memeber.date_added = res["timestamp_opt"]
	  newsletter_memeber.last_changed = res["last_changed"]
	  puts newsletter_memeber
	  newsletter_memeber.save!
  end

  response1 = gibbon.lists("79163eadfe").members.retrieve(params: {"count": "99999999"})
  CharlestonMasterMember.delete_all

	response1.body["members"].each do |res|
	  charleston_master_member = CharlestonMasterMember.new
	  charleston_master_member.email = res["email_address"]
	  charleston_master_member.first_name = res["merge_fields"]["FNAME"]
	  charleston_master_member.last_name = res["merge_fields"]["LNAME"]
	  charleston_master_member.status = res["status"]
	  charleston_master_member.date_added = res["timestamp_opt"]
	  charleston_master_member.last_changed = res["last_changed"]
	  puts charleston_master_member
	  charleston_master_member.save!
	end
end