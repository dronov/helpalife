class NeedsController < ApplicationController

  def new

  end

  def index
    @needs = Need.paginate(page: params[:page], :per_page => 25)

  end

  def create
    @need = Need.create(need_params)
    need_date = DateTime.strptime(need_params[:required_date], '%m/%d/%y')
    @need.required_date  = need_date
    @need.user_id = current_user.id
    if @need.save!
       redirect_to need_path(@need)
    end
  end

  def show
    @need = Need.find(params[:id])
    get_users
  end

  def update
    @need = Need.find(params[:id])
    @need.update_attributes(need_params)
    get_users
    redirect_to need_path(@need)
  end

  def get_users
    @users = User.where(blood_group: @need.blood_group,
                        district_id: @need.district.id,
                        district_id: @need.district.id,
                        state_id: @need.state.id).paginate(page: params[:page], :per_page => 50)

  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def need_params
    params.require(:need).permit(:required_date,:required_units,:hospital_name,:blood_group,:state_id,
                                 :district_id,:contact_number,:reason,:patient_name)
  end

end
