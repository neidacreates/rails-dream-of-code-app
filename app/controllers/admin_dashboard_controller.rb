class AdminDashboardController < ApplicationController
    def index
        @current_trimester = Trimester.where("start_date <= ?", Date.today).where("end_date >= ?", Date.today).first
        @future_trimester = Trimester.where("start_date < ?", Date.today + 6.months).where("end_date >= ?", Date.today + 6.months).first
    end  
end