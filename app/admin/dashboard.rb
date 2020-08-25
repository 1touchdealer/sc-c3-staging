ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Recent Users" do
          ul do
            User.order('created_at desc').limit(5).map do |user|
              li link_to(user.name, admin_user_path(user))
            end
          end
        end
      end

      column do
        panel "Recent Alliances" do
          ul do
            Alliance.order('created_at desc').limit(5).map do |alliance|
              li link_to(alliance.name, admin_alliance_path(alliance))
            end
          end
        end
        panel "Recent Businesses" do
          ul do
            Business.order('created_at desc').limit(5).map do |business|
              li link_to(business.name, admin_business_path(business))
            end
          end
        end
        panel "Recent Churches" do
          ul do
            Church.order('created_at desc').limit(5).map do |church|
              li link_to(church.name, admin_church_path(church))
            end
          end
        end
      end
    end
  end # content
end
