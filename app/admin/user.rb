ActiveAdmin.register User do

  controller do
    def update_resource(object, attributes)

      update_method = attributes.first[:password].present? ? :update_attributes : :update_without_password

      object.send(update_method, *attributes)

    end

  end

  form do |f|
    f.inputs "User Details" do
      f.input :fname
      f.input :lname
      f.input :phone
      f.input :carrier,:as => :select, :collection => options_for_select(["AT&T","Verizon", "Boost Mobile", "Cellular One", "Metro PCS", "Nextel", "Sprint", "T-Mobile", "Tracfone"])
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :admin
      f.input :tracker
    end
    f.actions
  end

  permit_params :email, :password, :password_confirmation, :admin, :tracker, :fname, :lname, :carrier

# See permitted parameters documentation:
# https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#  permitted = [:permitted, :attributes]
#  permitted << :other if resource.something?
#  permitted
# end

end
