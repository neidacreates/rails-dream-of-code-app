require 'rails_helper'

RSpec.describe 'Dashboard', type: :request do
    describe 'GET /dashboard' do
        before do
            current_trimester = Trimester.create!(
                term: 'Current Term',
                year: Date.today.year.to_s,
                start_date: Date.today - 1.day,
                end_date: Date.today + 2.months,
                application_deadline: Date.today - 16.days
            )
            
            ['Intro to Programming', 'Node.js', 'Python', 'React'].each do |class_title|
                class_instance = CodingClass.create!(title: "#{class_title}")
                Course.create!(trimester: current_trimester, coding_class: class_instance)
            end

            future_trimester = Trimester.create!(
                term: 'Next Term',
                year: Date.today.year.to_s,
                start_date: Date.today + 5.months,
                end_date: Date.today + 7.months,
                application_deadline: Date.today - 16.days
            )


            ['Intro to Programming', 'React'].each do |class_title|
                class_instance = CodingClass.create!(title: "#{class_title}")
                Course.create!(trimester: future_trimester, coding_class: class_instance)
            end
        end
        it 'returns a 200 OK status' do
            get "/dashboard"
            expect(response).to have_http_status(:ok)
        end

        it 'displays the current trimester' do
            get "/dashboard"
            expect(response.body).to include('Current Term - 2025')
        end

        it 'displays links to the courses in the current trimester' do
            get "/dashboard"
            expect(response.body).to include('Intro to Programming')
            expect(response.body).to include('Node.js')
            expect(response.body).to include('Python')
            expect(response.body).to include('React')
        end

        it 'displays the upcoming trimester' do
            get "/dashboard"
            expect(response.body).to include('Next Term - 2025')
        end

        it 'displays links to the courses in the upcoming trimester' do
            get "/dashboard"
            expect(response.body).to include('Intro to Programming')
            expect(response.body).to include('React')
        end
    end
end