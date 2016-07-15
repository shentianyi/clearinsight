class Admin::ApplicationController<ActionController::Base

  #skip_before_filter :verify_authenticity_token, :only => [:create]
  before_action :require_user_as_admin


  protected

  def require_user_as_admin
    if current_user.blank?
      respond_to do |format|
        format.html { authenticate_user! }
        format.all { head(:unauthorized) }
      end
    elsif !current_user.is_system?
      respond_to do |format|
        format.html { render file: File.join(Rails.root, 'public/404.html'), status: 404, layout: false }
        format.json { render json: {access: false, errorCode: -4000}, status: 403 }
      end
    end
  end

end