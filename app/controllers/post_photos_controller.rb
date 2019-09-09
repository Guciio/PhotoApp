class PostPhotosController < ApplicationController
  before_action :set_post_photo, only: [:show, :edit, :update, :destroy]

  # GET /post_photos
  # GET /post_photos.json
  def index
    @post_photos = PostPhoto.all
  end

  # GET /post_photos/1
  # GET /post_photos/1.json
  def show
  end

  # GET /post_photos/new
  def new
    @post_photo = PostPhoto.new
  end

  # GET /post_photos/1/edit
  def edit
  end

  # POST /post_photos
  # POST /post_photos.json
  def create
    @post_photo = PostPhoto.new(post_photo_params)
    #@post_photo.image.attach(params[:image])

    respond_to do |format|
      if @post_photo.save
        format.html { redirect_to @post_photo, notice: 'Post photo was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /post_photos/1
  # PATCH/PUT /post_photos/1.json
  def update
    respond_to do |format|
      if @post_photo.update(post_photo_params)
        format.html { redirect_to @post_photo, notice: 'Post photo was successfully updated.' }
        format.json { render :show, status: :ok, location: @post_photo }
      else
        format.html { render :edit }
        format.json { render json: @post_photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /post_photos/1
  # DELETE /post_photos/1.json
  def destroy
    @post_photo.destroy
    respond_to do |format|
      format.html { redirect_to post_photos_url, notice: 'Post photo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post_photo
      @post_photo = PostPhoto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_photo_params
      params.require(:post_photo).permit(:title, :content)
    end
end
