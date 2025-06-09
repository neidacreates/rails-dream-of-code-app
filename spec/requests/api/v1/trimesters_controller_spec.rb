require 'rails_helper'

RSpec.describe "Trimesters", type: :request do
    describe "GET /trimesters" do
        context 'trimesters exist' do
            before do
                (1..2).each do |i|
                    Trimester.create!(
                        term: "Term #{i}",
                        year: '2025',
                        start_date: '2025-01-01',
                        end_date: '2025-01-01',
                        application_deadline: '2025-01-01',
                )
                end
            end

            it 'returns a page containing names of all trimesters' do
                get '/trimesters'
                expect(response.body).to include('Term 1 2025')
                expect(response.body).to include('Term 2 2025')
            end
        end
        context 'trimesters do not exist' do
            it 'returns a page containing just a header' do
                get '/trimesters'
                expect(response.body).not_to include('Term 1 2025')
                expect(response.body).not_to include('Term 2 2025')
            end
        end
    end
    describe "GET /trimesters/:id/edit" do
        let!(:trimester) {
            Trimester.create!(
            term: "Fall",
            year: "2025",
            start_date: "2025-09-01",
            end_date: "2025-12-01",
            application_deadline: "2025-08-01"
            )
        }
        it 'renders the edit form with application deadline label' do
            get edit_trimester_path(trimester)
            expect(response).to have_http_status(:ok)
            expect(response.body).to include("Application deadline")
        end
    end
    describe "PUT /trimesters/:id" do
        let!(:trimester) {
            Trimester.create!(
            term: "Winter",
            year: "2025",
            start_date: "2025-01-01",
            end_date: "2025-03-31",
            application_deadline: "2024-12-01"
            )
        }
        context "with valid application deadline" do
            it "updates the application deadline" do
                valid_date = "2024-12-15"
                put trimester_path(trimester), params: {
                trimester: { application_deadline: valid_date }
                }
        
                expect(response).to redirect_to(trimester_path(trimester))
                expect(trimester.reload.application_deadline).to eq(Date.parse(valid_date))
            end
        end
        context "without application deadline" do
            it "returns a 400 Bad Request" do
                put trimester_path(trimester), params: {
                trimester: { application_deadline: "" }
                }
        
                expect(response).to have_http_status(:bad_request)
            end
        end
        context "with non-existent trimester id" do
            it "returns a 404 Not Found" do
                put "/trimesters/999999", params: {
                trimester: { application_deadline: "2025-12-01" }
                }
        
                expect(response).to have_http_status(:not_found)
            end
        end
    end
end