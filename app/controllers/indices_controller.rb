class IndicesController < ApplicationController
  skip_before_action :verify_authenticity_token
  # GET /indices
  # GET /indices.json
  def index
    get_photos
    @indices = Index.all
  end

  def rotate_photo
    sqs = Aws::SQS::Client.new(
        region: Rails.application.credentials.aws[:aws_region],
        access_key_id: Rails.application.credentials.aws[:access_key_id],
        secret_access_key: Rails.application.credentials.aws[:secret_access_key])
    sqs.send_message(queue_url: 'https://sqs.us-west-2.amazonaws.com/801463284499/awsprojectqueue.fifo',
                     message_body: "rotate: " + params[:choosen_photo].to_s,
                     message_group_id: rand(1..100).to_s)
    redirect_to action: "index"
  end

  def send_mesage
    sqs = Aws::SQS::Client.new(
        region: Rails.application.credentials.aws[:aws_region],
        access_key_id: Rails.application.credentials.aws[:access_key_id],
        secret_access_key: Rails.application.credentials.aws[:secret_access_key])
    # entries = Array.new(params[:keys].size)
    # i=0
    # params[:keys].each do |key|
    #   body = {
    #       key: key,
    #       operation: params[:operation],
    #       value: params[:value]
    #   }
    #   obj = {
    #       id: 'msg' + i.to_s,
    #       message_body: JSON[body].to_s
    #   }
    #   entries[i] = obj
    #   i += 1
    # end
    sqs.send_message(queue_url: 'https://sqs.us-west-2.amazonaws.com/801463284499/awsprojectqueue.fifo', message_body: params[:message],message_group_id: "1")
    redirect_to action: "index"
  end

  def delete_photo
    s3 = Aws::S3::Resource.new(region: Rails.application.credentials.aws[:aws_region],
                               access_key_id: Rails.application.credentials.aws[:access_key_id],
                               secret_access_key: Rails.application.credentials.aws[:secret_access_key])
    s3.bucket('awsprojectbuckett').delete_objects({
        delete: {
            objects: [
                {
                    key: params[:choosen_photo].to_s
                },
            ],
        },
                                                  })
    redirect_to action: "index"
  end

  def get_photos
    s3 = Aws::S3::Resource.new(region: Rails.application.credentials.aws[:aws_region],
                               access_key_id: Rails.application.credentials.aws[:access_key_id],
                               secret_access_key: Rails.application.credentials.aws[:secret_access_key])
    obj = s3.bucket('awsprojectbuckett').objects
    @readedPhoto = obj
  end

  def send_photo
    s3 = Aws::S3::Resource.new(region: Rails.application.credentials.aws[:aws_region],
                               access_key_id: Rails.application.credentials.aws[:access_key_id],
                               secret_access_key: Rails.application.credentials.aws[:secret_access_key])
    obj = s3.bucket('awsprojectbuckett').object(params[:photo])
    pathToFile = File.expand_path(params[:photo])
    obj.upload_file(pathToFile )
    redirect_to action: "index"
  end

  # GET /indices/1
  # GET /indices/1.json
  def show
  end

  # GET /indices/new
  def new
    @index = Index.new
  end

  # GET /indices/1/edit
  def edit
  end

  # POST /indices
  # POST /indices.json
  def create
    @index = Index.new(index_params)

    respond_to do |format|
      if @index.save
        format.html { redirect_to @index, notice: 'Index was successfully created.' }
        format.json { render :show, status: :created, location: @index }
      else
        format.html { render :new }
        format.json { render json: @index.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /indices/1
  # PATCH/PUT /indices/1.json
  def update
    respond_to do |format|
      if @index.update(index_params)
        format.html { redirect_to @index, notice: 'Index was successfully updated.' }
        format.json { render :show, status: :ok, location: @index }
      else
        format.html { render :edit }
        format.json { render json: @index.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /indices/1
  # DELETE /indices/1.json
  def destroy
    @index.destroy
    respond_to do |format|
      format.html { redirect_to indices_url, notice: 'Index was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_index
      @index = Index.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def index_params
      params.fetch(:index, :image,{})
    end

end
