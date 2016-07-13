class Admin::TenantsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:create]
  skip_before_filter :set_current_user_tenant
  # prepend_before_filter :load_session, only: :flash_upload
  #
  # def load_session
  #   unless session.loaded?
  #     se = Marshal.load(ActiveSupport::Base64.decode64(params["_dituhui_session"]))
  #     logger.info("\n--------session is: #{se.inspect}-----------\n")
  #     request.session.update(se)
  #   end
  # end

  def index
    @tenants=Tenant.all
    respond_to do |format|
      format.html
      format.json { render json: @tenants }
    end
  end

  def show
    @tenant = Tenant.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @tenant = Tenant.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end


  def edit
    @tenant=Tenant.find(params[:id])
  end

  def create
    puts params.to_json
    # begin
      @user=User.new
      @user.name=params[:user][:name]
      @user.create_tenant_user!(params[:user][:name],params[:user][:email], params[:user][:password], params[:user][:password], params[:tenant][:name])
      @tenant=@user.tenant
      redirect_to  [:admin, @tenant], notice: 'Tenant was successfully created.'
    # rescue Exception => e
    #   render action: "new", notice: "created error: #{e.message}"
    # end
  end

  def update
    @tenant=Tenant.find(params[:id])

    respond_to do |format|
      if @tenant.update_attributes(params[:tenant])
        format.html { redirect_to [:admin,@tenant], notice: 'Tenant was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tenant.errors, status: :unprocessable_entity }
      end
    end
  end
end
