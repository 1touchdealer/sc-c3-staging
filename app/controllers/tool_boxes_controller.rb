class ToolBoxesController < ApplicationController
  layout  "landing_page"

  before_filter :authenticate_user!, :only => :blog

  def index
    # @job_lead = current_user && !current_user.job_lead ? JobLead.new(user: current_user) : nil
  end

  def documents
    @documents_texts = {
        # alliance: Yomu.new(Rails.root.join('db/pdf/SC C3 Invite Alliance.pdf')).text,
        # business: Yomu.new(Rails.root.join('db/pdf/SC C3 Invite Business.pdf')).text,
        # church: Yomu.new(Rails.root.join('db/pdf/SC C3 Invite Church.pdf')).text,
        # individual: Yomu.new(Rails.root.join('db/pdf/SC C3 Invite Individual.pdf')).text

        alliance:
        "Dear Alliance Leader,\n
        I hope this email finds you well and prospering in all you do!\n
        I recently learned of an organization that is creating a Christian movement across South Carolina, the SC Christian Chamber of Commerce (C3) and I thought about you.\n
        The vision of C3 is to unify Christian Businesses, Alliances (non-profits), Churches, and Individuals to positively impact our community. There are many benefits for your alliance’s investment of $99 per year, which includes: monthly networking meetings to promote your alliance; promotion at the meetings and on the website; statewide calendar where you can post events; platform where you can submit your own campaigns for charitable needs; unity prayer coin and window decal for your car or alliance.\n
        For more information, go to: https://www.sc-c3.org.  Also, if you know others who will benefit from this movement, please share this information with them and encourage them to become a member.\n
        Thanks for all you do to make our community a better place,",

        business:
        "Dear Business Leader,\n
        I hope this email finds you well and prospering in all you do!
        I recently learned of an organization that is creating a Christian movement across South Carolina, the SC Christian Chamber of Commerce (C3) and I thought about you.\n
        The vision of C3 is to unify Christian Businesses, Alliances (non-profits), Churches, and Individuals to positively impact our community. There are many benefits for your company’s investment of $299 per year, which includes: monthly networking meetings to promote your business; promotion at the meetings and on the website; statewide calendar where you can post events; platform where you can submit your own campaigns for charitable needs; unity prayer coin and window decal for your car or business.\n
        For more information, go to: https://www.sc-c3.org.  Also, if you know others who will benefit from this movement, please share this information with them and encourage them to become a member.\n
        Thanks for all you do to make our community a better place,",

        church:
        "Dear Church Leader,\n
        I hope this email finds you well and prospering in all you do!
        I recently learned of an organization that is creating a Christian movement across South Carolina, the SC Christian Chamber of Commerce (C3) and I thought about you.\n
        The vision of C3 is to unify Christian Businesses, Alliances (non-profits), Churches, and Individuals to positively impact our community. There are many benefits for your church’s investment of $99 per year, which includes: monthly networking meetings to promote your church; promotion at the meetings and on the website; statewide calendar where you can post events; platform where you can submit your own campaigns for charitable needs; unity prayer coin and window decal for your car or church.\n
        For more information, go to: https://www.sc-c3.org.  Also, if you know others who will benefit from this movement, please share this information with them and encourage them to become a member.\n
        Thanks for all you do to make our community a better place,",

        individual:
        "Dear Christian professional,\n
        I hope this email finds you well and prospering in all you do!
        I recently learned of an organization that is creating a Christian movement across South Carolina, the SC Christian Chamber of Commerce (C3) and I thought about you.\n
        The vision of C3 is to unify Christian Businesses, Alliances (non-profits), Churches, and Individuals to positively impact our community. There are many benefits for your investment of $49 per year, which includes: monthly networking meetings to promote professional growth; statewide calendar where you can post events; platform where you can submit your own campaigns for charitable needs; unity prayer coin and window decal for your car.\n
        For more information, go to: https://www.sc-c3.org.  Also, if you know others who will benefit from this movement, please share this information with them and encourage them to become a member.\n
        Thanks for all you do to make our community a better place,"
    }
  end

  def resources
    @faith_resources = ToolBoxResource.where(category: "Faith")
    @community_resources = ToolBoxResource.where(category: "Community")
  end

  def events
    @events = ToolBoxEvent.all
  end

  def show
    respond_to do |format|
      format.pdf do
        file = Rails.root.join('db', 'pdf', "#{params[:file_name]}.pdf")
        File.open(file, 'r') do |f|
          send_data f.read.force_encoding('BINARY'),
                    :filename => "#{params[:file_name]}.pdf",
                    :type => "application/pdf",
                    :disposition => "attachment"
        end
      end
    end
  end

  def blog
  end
end
