require 'rails_helper'

RSpec.describe "Api::V1::Courses", type: :request do
  # Set up current, past and future trimesters and courses for each
  let!(:current_trimester) {
    Trimester.create!(
      term: "Term",
      year: "Year",
      start_date: Date.today - 1.month,
      end_date: Date.today + 2.months,
      application_deadline: Date.today - 1.month)
  }
  let!(:past_trimester) {
    Trimester.create!(
      term: "Past Term",
      year: "Past Year",
      start_date: Date.today - 1.year,
      end_date: Date.today - 1.year - 3.months,
      application_deadline: Date.today - 1.year)
  }
  let!(:future_trimester) {
    Trimester.create!(
      term: "Future Term",
      year: "Future Year",
      start_date: Date.today + 1.year,
      end_date: Date.today + 1.year + 3.months,
      application_deadline: Date.today + 1.month)
  }
  let(:coding_class) {
    CodingClass.create!(
      title: "Intro to Javascript"
    )
  }
  let!(:past_course) {
    Course.create!(
      coding_class_id: coding_class.id,
      trimester_id: past_trimester.id)
  }
  let!(:future_course) {
    Course.create!(
      coding_class_id: coding_class.id,
      trimester_id: future_trimester.id)
  }
  let!(:current_course) {
    Course.create!(
      coding_class_id: coding_class.id,
      trimester_id: current_trimester.id)
  }

  describe "GET /api/v1/courses" do
    it "returns a list of courses" do
      get '/api/v1/courses'

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['courses']).to be_an(Array)
      expect(JSON.parse(response.body)['courses'].size).to eq(1)
      expect(JSON.parse(response.body)['courses'].first['id']).to eq(current_course.id)
    end
  end
  describe "GET /courses/:id" do
    it "shows the course name and enrolled students" do
      course = Course.create!(coding_class: coding_class, trimester: current_trimester, max_enrollment: 20)
      student = Student.create!(first_name: "John", last_name: "Doe", email: "john@example.com")
      Enrollment.create!(student: student, course: course)

      get course_path(course)

      expect(response.body).to include(course.title)
      expect(response.body).to include("John Doe")
    end
  end
end
