class Admin::MembersController < AdminController
  respond_to :html, :json, :js
  
  def index
    @members = Member.all
    
    respond_with(@members)
  end
  
  def edit
    @member = Member.find(params[:id])
    
    respond_with(@member)
  end
  
  def update
    @member = Member.find(params[:id])
    
    if @member.update_attributes(member_params)
      flash[:success] = "Updated member information"
      redirect_to admin_members_path
    else
      render 'edit'
    end
  end
  
  def new
    @member = Member.new
    
    respond_with @member
  end
  
  def create
    @member = Member.new(member_params)
    
    if @member.save
      flash[:success] = "Created new member"
      redirect_to admin_members_path
    else
      render 'new'
    end
  end
  
  protected
  
  def member_params
    p  ||= params[:member].slice(:name, :email, :admin)
    
    p
  end
end
