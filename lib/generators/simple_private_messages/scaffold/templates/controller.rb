class <%= plural_camel_case_name %>Controller < ApplicationController
  
  before_filter :set_user
  
  def index
    if params[:mailbox] == "sent"
      @<%= plural_lower_case_name %> = @<%= singular_lower_case_parent %>.sent_messages.page(params[:page])
    else
      @<%= plural_lower_case_name %> = @<%= singular_lower_case_parent %>.received_messages.page(params[:page])
    end
  end
  
  def show
    @<%= singular_lower_case_name %> = <%= singular_camel_case_name %>.read_message(params[:id], current_user)
  end
  
  def new
    @<%= singular_lower_case_name %> = <%= singular_camel_case_name %>.new

    if params[:reply_to]
      @reply_to = @<%= singular_lower_case_parent %>.received_messages.find(params[:reply_to])
      unless @reply_to.nil?
        @<%= singular_lower_case_name %>.to = @reply_to.sender.email
        @<%= singular_lower_case_name %>.subject = "Re: #{@reply_to.subject}"
        @<%= singular_lower_case_name %>.body = "\n\n*Original message*\n\n #{@reply_to.body}"
      end
    end
  end
  
  def create
    @<%= singular_lower_case_name %> = <%= singular_camel_case_name %>.new(params[:<%= singular_lower_case_name %>])
    @<%= singular_lower_case_name %>.sender = @<%= singular_lower_case_parent %>
    @<%= singular_lower_case_name %>.recipient = <%= singular_camel_case_parent %>.find_by_email(params[:<%= singular_lower_case_name %>][:to])

    if @<%= singular_lower_case_name %>.save
      flash[:notice] = "Message sent"
      redirect_to user_<%= plural_lower_case_name %>_path(@<%= singular_lower_case_parent %>)
    else
      render :action => :new
    end
  end
  
  def delete_selected
    if request.post?
      if params[:delete]
        params[:delete].each { |id|
          @<%= singular_lower_case_name %> = <%= singular_camel_case_name %>.find(:first, :conditions => ["<%= plural_lower_case_name %>.id = ? AND (sender_id = ? OR recipient_id = ?)", id, @<%= singular_lower_case_parent %>, @<%= singular_lower_case_parent %>])
          @<%= singular_lower_case_name %>.mark_deleted(@<%= singular_lower_case_parent %>) unless @<%= singular_lower_case_name %>.nil?
        }
        flash[:notice] = "Messages deleted"
      end
      redirect_to :back
    end
  end
  
  private
    def set_user
      @<%= singular_lower_case_parent %> = current_user)
    end
end