# questionnaire_spec.rb

require 'pstore'
require_relative 'questionnaire'

STORE_NAME = "test_questionnaire.pstore"
store = PStore.new(STORE_NAME)

RSpec.describe 'Questionnaire Assessment Evaluation' do
  let(:store) { PStore.new(STORE_NAME) }

  context 'when working with yes? method' do
    it 'returns true for "yes"' do
      expect(yes?('yes')).to be true
    end

    it 'returns true for "y"' do
      expect(yes?('y')).to be true
    end

    it 'returns false for "no"' do
      expect(yes?('no')).to be false
    end
  end

  describe '#save_rating' do
    it 'saves a rating into the store' do
      expect {
        save_rating(store, 80.0)
      }.to change { store.transaction { store[:all_runs] } }.from(nil).to([80.0])
    end
  end

  describe '#calculate_average_rating' do
    before do
      save_rating(store, 80.0)
      save_rating(store, 100.0)
    end

    it 'calculates average from all runs' do
      expect(calculate_average_rating(store)).to be_within(0.01).of(86.67)
    end

    it 'returns 0.0 if there are no ratings' do
      store.transaction { store.delete(:all_runs) }
      expect(calculate_average_rating(store)).to eq(0.0)
    end
  end

  describe '#prompt_questions' do
    it 'calculates correct rating based on user input' do
      allow_any_instance_of(Kernel).to receive(:gets).and_return('y', 'n', 'yes', 'no', 'y')
      rating = prompt_questions
      expect(rating).to eq(60.0) # 3 out of 5 questions are yes which is 60%
    end
  end

  # Note: Testing #generate_report is tricky because it contains method calls for input/output.
  # You can stub out #prompt_questions and #save_rating to avoid interactions with standard input/output and PStore during the test.
  describe '#generate_report' do
    it 'prints the correct format for current run and average' do
      allow(self).to receive(:prompt_questions).and_return(100.0)
      allow(self).to receive(:save_rating)
      expect { generate_report(store) }.to output(/Rating for this run: 100.00%/).to_stdout
      expect { generate_report(store) }.to output(/Average rating for all runs: \d+.\d+%$/).to_stdout
    end
  end

  # Cleanup after tests by removing the created 'questionnaire.pstore' file
  after(:all) do
    File.delete(STORE_NAME) if File.exist?(STORE_NAME)
  end
end