class TrimestersController < ApplicationController
    def edit
        @trimester = Trimester.find(params[:id])
    end

    def update
        @trimester = Trimester.find(params[:id])

        if params[:trimester][:application_deadline].present? && valid_date?(params[:trimester][:application_deadline])
            @trimester.update(trimester_params)
            redirect_to @trimester, notice: 'Trimester updated successfully.'
        else
            render :edit, status: :bad_request, notice: 'Invalid application deadline.'
        end
    end
    
    def index
        @trimesters = Trimester.all
    end  
    def show
        @trimester = Trimester.find(params[:id])
    end

    def trimester_params
        params.require(:trimester).permit(:term, :year, :start_date, :end_date, :application_deadline)
    end
    
    def valid_date?(date_string)
        Date.parse(date_string) rescue false
    end
end