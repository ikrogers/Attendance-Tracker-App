class MessageListsController < InheritedResources::Base
  before_action :authenticate_user!
    layout 'application1'


def group_params
    params.require(:message_list).permit(:messages_id, :users_id)
  end

end
