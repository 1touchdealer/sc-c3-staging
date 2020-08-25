ActiveAdmin.register AboutCategory do
  menu parent: 'About'

  permit_params :name, :position
end
