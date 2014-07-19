class MessageListsController < InheritedResources::Base

def group_params
    params.require(:message_list).permit(:messages_id, :users_id)
  end

end
