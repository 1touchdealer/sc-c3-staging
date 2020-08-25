# ActiveAdmin.register Match do
#   menu parent: 'NonProfit Entities'
#
#   actions :all, :except => [:destroy, :edit]
#
#   index do
#     column :category
#     column 'Item Owner' do |m|
#       link_to m.first_matchable.resourceful.email, admin_user_path(m.first_matchable.resourceful), :class => "member_link"
#     end
#     column 'Need Owner' do |m|
#       m.second_matchable.user.email
#       link_to m.second_matchable.user.email, admin_user_path(m.second_matchable.user), :class => "member_link"
#     end
#     column :created_at
#     column :updated_at
#     column 'Item Owner Accepted', :first_matchable_acceptance
#     column 'Need Owner Accepted', :second_matchable_acceptance
#     actions
#   end
#
#   filter :category
#   filter :created_at
#   filter :updated_at
#
#   config.per_page = 20
#
# end
