class DeploymentsController < ApplicationController
  # # GET /deployments
  # # GET /deployments.json
  # def index
  #   @deployments = Deployment.all
  # end

  # # GET /deployments/1
  # # GET /deployments/1.json
  # def show
  # end

  # # GET /deployments/new
  # def new
  #   @deployment = Deployment.new
  # end

  # GET /deployments/1/edit
  def edit
    @deployment_name = params[:id]
    @notice = params[:notice]
    `credhub login --username=credhub-cli --password=k4ieqxg4pp8vb0y8c4mj`
    @variables = {}
    variable_names = JSON.parse(`credhub find -n "/Bosh Lite Director/#{@deployment_name}" --output-json`)['credentials'].map{ |c| c['name'] }
    variable_names.each do |var_name|
      @variables[var_name] = JSON.parse(`credhub get -n "#{var_name}" --output-json`)['value']
    end
  end

  # # POST /deployments
  # # POST /deployments.json
  # def create
  #   @deployment = Deployment.new(deployment_params)
  #
  #   respond_to do |format|
  #     if @deployment.save
  #       format.html { redirect_to @deployment, notice: 'Deployment was successfully created.' }
  #       format.json { render :show, status: :created, location: @deployment }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @deployment.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /deployments/1
  # PATCH/PUT /deployments/1.json
  def update
    `bosh2 login -e vbox --client=admin --client-secret=6c4ns4r4uog1gl2ohq7y`
    `credhub login --username=credhub-cli --password=k4ieqxg4pp8vb0y8c4mj`
    params['vars'].each do |var_name, var_value|
      `credhub set -n "#{var_name}" -v "#{var_value}" -t value`
    end

    `bosh2 -e vbox -d bui-example manifest > ./manifest.yml`
    `bosh2 -e vbox -d bui-example deploy ./manifest.yml -n`
     redirect_to edit_deployment_path params[:id], notice: 'Deployment was successfully updated.'
  end

  # # DELETE /deployments/1
  # # DELETE /deployments/1.json
  # def destroy
  #   @deployment.destroy
  #   respond_to do |format|
  #     format.html { redirect_to deployments_url, notice: 'Deployment was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
end
