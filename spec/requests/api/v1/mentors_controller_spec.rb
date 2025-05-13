require 'rails_helper'

RSpec.describe "Mentors", type: :request do
    describe "GET /mentors" do
        context 'mentors exist' do
            before do
                (1..2).each do |i|
                    Mentor.create!(
                        first_name: "Mentor #{i}",
                        last_name: "Last",
                        email: "mentor#{i}@email.com",
                )
                end
            end
            it 'returns a page containing names of all mentors' do
                get '/mentors'
                expect(response.body).to include('Mentor 1')
                expect(response.body).to include('Mentor 2')
            end
        end
        context 'mentors do not exist' do
            it 'returns a page containing no mentors' do
                get '/mentors'
                expect(response.body).not_to include('Mentor 1')
                expect(response.body).not_to include('Mentor 2')
            end
        end
    end
    describe "GET /mentors/:id" do
        context 'selected mentor exists' do
            before do
                (1..2).each do |i|
                    Mentor.create!(
                        first_name: "Mentor #{i}",
                        last_name: "Last",
                        email: "mentor#{i}@email.com",
                )
                end
            end
            it 'returns a page containing just selected mentor' do
                get '/mentors/1'
                expect(response.body).to include('Mentor 1')
                expect(response.body).not_to include('Mentor 2')
            end
        end
        context 'selected mentor does not exist' do
            it 'returns a 404 not found status' do
                get '/mentors/9999'
                expect(response).to have_http_status(:not_found)
            end
        end
    end
end