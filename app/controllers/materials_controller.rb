class MaterialsController < ApplicationController
    layout "manager"
    before_action :set_material, only: [:show, :edit, :update, :destroy]
    
    
    # GET /clients
    # GET /clients.json
    def index
    end
    
    # GET /clients/1
    # GET /clients/1.json
    def show
    end
    
    # GET /clients/new
    def new
        @material = Material.new
    end
    
    # GET /clients/1/edit
    def edit
    end
    
    # POST /clients
    # POST /clients.json
    def create
        @material = Material.new
    end
    
    # PATCH/PUT /clients/1
    # PATCH/PUT /clients/1.json
    def update
    end
    
    # DELETE /clients/1
    # DELETE /clients/1.json
    def destroy
    end
    
    private
        # Use callbacks to share common setup or constraints between actions.
        def set_material
        end
    
        # Never trust parameters from the scary internet, only allow the white list through.
        def material_params
        end      
end
