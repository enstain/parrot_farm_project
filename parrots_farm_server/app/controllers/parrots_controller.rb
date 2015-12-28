class ParrotsController < ApplicationController
  before_action :set_parrot, only: [:show, :show_descendants, :show_ancestry, :edit, :update, :destroy]

  # GET /parrots
  # GET /parrots.json
  def index
    #@parrots = Parrot.all
    @parrots = Parrot.filter(params.slice(:id, :search_name, :brood, :sex_is, :age_equal, :age_lt, :age_gt, :color_is))
  end

  # GET /parrots/1
  # GET /parrots/1.json
  def show
  end

  def show_descendants
    @descendants = @parrot.descendants
  end

  def show_ancestry
    @ancestry = @parrot.ancestry
  end

  # GET /parrots/values/color.json
  def values
    field = params[:field].to_sym
    @values = Parrot.send(field).values
  end

  # GET /parrots/may_be_parents/male.json
  def may_be_parents
    sex = params[:sex]
    @probably_parents = Parrot.candidates_to_parent(sex)
  end

  # GET /parrots/new
  def new
    @parrot = Parrot.new
  end

  # GET /parrots/1/edit
  def edit
  end

  # POST /parrots
  # POST /parrots.json
  def create
    @parrot = Parrot.new(parrot_params)

    respond_to do |format|
      if @parrot.save
        format.html { redirect_to @parrot, notice: 'Parrot was successfully created.' }
        format.json { render :show, status: :created, location: @parrot }
      else
        format.html { render :new }
        format.json { render json: @parrot.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /parrots/1
  # PATCH/PUT /parrots/1.json
  def update
    respond_to do |format|
      if @parrot.update(parrot_params)
        format.html { redirect_to @parrot, notice: 'Parrot was successfully updated.' }
        format.json { render :show, status: :ok, location: @parrot }
      else
        format.html { render :edit }
        format.json { render json: @parrot.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parrots/1
  # DELETE /parrots/1.json
  def destroy
    respond_to do |format|
      if @parrot.destroy
        format.html { redirect_to parrots_url, notice: 'Parrot was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json { render json: @parrot.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_parrot
      @parrot = Parrot.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def parrot_params
      params.require(:parrot).permit(:name, :age, :sex, :color, :brood, :mother, :mother_id, :father, :father_id)
    end
end
