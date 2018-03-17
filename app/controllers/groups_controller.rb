class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :update, :destroy]

  # GET /groups
  def index
    @groups = Group.all

    render 'index', formats: 'json', handlers: 'jbuilder'
  end

  # GET /groups/1
  def show
    render 'show', formats: 'json', handlers: 'jbuilder'
  end

  def result
    @group = Group.find(params[:group_id])
    members_num_per_group = params[:members_num_per_group].to_i
    group_num = @group.members.length.fdiv(members_num_per_group).ceil
    restaurants = Restaurant.where(id: @group.restaurants.pluck(:id).sample(group_num))
    members_ids = @group.members.pluck(:id).shuffle

    random_restaurants = restaurants.map do |restaurant|
      {
        restaurant: restaurant,
        members: Member.where(id: members_ids.slice!(0..(members_num_per_group - 1)))
      }
    end

    render json: { restaurants: random_restaurants }
  end

  # POST /groups
  def create
    @group = Group.new(group_params)

    if @group.save
      render json: @group, status: :created, location: @group
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /groups/1
  def update
    if @group.update(group_params)
      render json: @group
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  # DELETE /groups/1
  def destroy
    @group.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def group_params
      params.require(:group).permit(:name)
    end
end
