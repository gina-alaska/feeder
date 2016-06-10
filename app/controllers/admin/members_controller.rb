class Admin::MembersController < AdminController
  authorize_resource

  def index
    @members = Member.all
  end

  def edit
    @member = Member.find(params[:id])
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
    params.require(:member).permit(:name, :email, :admin)
  end
end
