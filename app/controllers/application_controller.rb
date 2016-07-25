class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery with: :exception

  before_action :require_user
  #before_action :authenticate_user!

  set_current_tenant_through_filter
  before_action :set_current_user_tenant

  protected

  def require_user
    if current_user.blank?
      respond_to do |format|
        format.html { authenticate_user! }
        format.all { head(:unauthorized) }
      end
    end
  end

  def set_current_user_tenant
    set_current_tenant(current_user.tenant)
  end

  private
  def set_model
    @model=self.class.name.gsub(/Controller/, '').tableize.singularize
  end
end
