class PostPhotosController < ApplicationController
  before_action :request_for_presigned_url, :set_post_photo, only: [:show, :edit, :update, :destroy]

  require 'open-uri'
  # GET /post_photos
  # GET /post_photos.json
  def index
    request_for_presigned_url
    client = Aws::S3::Client.new(
        region: Rails.application.credentials.aws[:aws_region],
        access_key_id: Rails.application.credentials.aws[:access_key_id],
        secret_access_key: Rails.application.credentials.aws[:secret_access_key])
    @objects = client.list_objects({bucket:'awsprojectbuckett'}).contents
    @post_photos = PostPhoto.all
  end

  def rotate_photo
    sqs = Aws::SQS::Client.new(
        region: Rails.application.credentials.aws[:aws_region],
        access_key_id: Rails.application.credentials.aws[:access_key_id],
        secret_access_key: Rails.application.credentials.aws[:secret_access_key])

    entries = Array.new(params[:keys].size)
    i=0
    params[:keys].each do |key|
      obj = {
          id: 'msg' + i.to_s,
          message_body: rand(10..99).to_s + "R:"+ key,
          message_group_id: rand(1..100).to_s,
      }
      entries[i] = obj
      i += 1
    end
    sqs.send_message_batch({
                               queue_url: 'https://sqs.us-west-2.amazonaws.com/801463284499/awsprojectqueue.fifo',
                               entries: entries
                           })
    redirect_to action: "index"
  end

  def blue_photo
    sqs = Aws::SQS::Client.new(
        region: Rails.application.credentials.aws[:aws_region],
        access_key_id: Rails.application.credentials.aws[:access_key_id],
        secret_access_key: Rails.application.credentials.aws[:secret_access_key])

    entries = Array.new(params[:keys].size)
    i=0
    params[:keys].each do |key|
      obj = {
          id: 'msg' + i.to_s,
          message_body: rand(10..99).to_s + "B:"+ key,
          message_group_id: rand(1..100).to_s,
      }
      entries[i] = obj
      i += 1
    end
    sqs.send_message_batch({
                               queue_url: 'https://sqs.us-west-2.amazonaws.com/801463284499/awsprojectqueue.fifo',
                               entries: entries
                           })

    redirect_to action: "index"
  end

  def flip_photo
    sqs = Aws::SQS::Client.new(
        region: Rails.application.credentials.aws[:aws_region],
        access_key_id: Rails.application.credentials.aws[:access_key_id],
        secret_access_key: Rails.application.credentials.aws[:secret_access_key])
    entries = Array.new(params[:keys].size)
    i=0
    params[:keys].each do |key|
      obj = {
          id: 'msg' + i.to_s,
          message_body: rand(10..99).to_s + "F:"+ key,
          message_group_id: rand(1..100).to_s,
      }
      entries[i] = obj
      i += 1
    end
    sqs.send_message_batch({
                               queue_url: 'https://sqs.us-west-2.amazonaws.com/801463284499/awsprojectqueue.fifo',
                               entries: entries
                           })
    redirect_to action: "index"
  end

  def delete_photo
    s3 = Aws::S3::Client.new(
        region: Rails.application.credentials.aws[:aws_region],
        access_key_id: Rails.application.credentials.aws[:access_key_id],
        secret_access_key: Rails.application.credentials.aws[:secret_access_key])

    params[:keys].each do |key|
      s3.delete_objects(
          bucket: 'awsprojectbuckett',
          delete: {
              objects: [
                  key: key
              ]
          })
    end


    redirect_to action: "index"

  end

  def download_photo
    s3 = Aws::S3::Resource.new(
        region: Rails.application.credentials.aws[:aws_region],
        access_key_id: Rails.application.credentials.aws[:access_key_id],
        secret_access_key: Rails.application.credentials.aws[:secret_access_key])
    params[:keys].each do |key|
      obj = s3.bucket('awsprojectbuckett').object(key)

      data = open(obj.presigned_url(:get, expires_in: 360))
      send_data data.read, filename: "download", type: "image/png", disposition: 'inline', stream: 'true', buffer_size: '4096'
    end
  end
  # GET /post_photos/1
  # GET /post_photos/1.json
  def show
    client = Aws::S3::Client.new(
        region: Rails.application.credentials.aws[:aws_region],
        access_key_id: Rails.application.credentials.aws[:access_key_id],
        secret_access_key: Rails.application.credentials.aws[:secret_access_key])
    @objects = client.list_objects({bucket:'awsprojectbuckett'}).contents
  end

  # GET /post_photos/new
  def new

    request_for_presigned_url
    # @post_photo = PostPhoto.new
  end

  # GET /post_photos/1/edit
  def edit
  end

  # POST /post_photos
  # POST /post_photos.json
  def create
    @post_photo = PostPhoto.new(post_photo_params)

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

  def request_for_presigned_url
    aws_credentials = Aws::Credentials.new(
        Rails.application.credentials.aws[:access_key_id],
        Rails.application.credentials.aws[:secret_access_key]
    )

    s3_bucket = Aws::S3::Resource.new(
        region: Rails.application.credentials.aws[:aws_region],
        credentials: aws_credentials
    ).bucket('awsprojectbuckett')

    @presigned_url = s3_bucket.presigned_post(
        key: "#{Rails.env}/#{SecureRandom.uuid}/${filename}",
        success_action_status: '201',
        signature_expiration: (Time.now.utc + 15.minutes),
        success_action_redirect: request.base_url + "/post_photos"
    )

  end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_photo_params
      params.require(:post_photo).permit(:title, :content)
    end
end
