# frozen_string_literal: true

require 'pstore' # Require PStore for file based persistence.

STORE_NAME = 'questionnaire.pstore' # Define the PStore database file name.

# Freeze the QUESTIONS hash to prevent modifications.
QUESTIONS = {
  'q1' => 'Can you code in Ruby? ',
  'q2' => 'Can you code in JavaScript? ',
  'q3' => 'Can you code in Swift? ',
  'q4' => 'Can you code in Java? ',
  'q5' => 'Can you code in C#? '
}.freeze

# Affirmative answers standardized for comparison.
AFFIRMATIVE_ANSWERS = %w[yes y].freeze

# Check if an answer is affirmative.
def yes?(answer)
  AFFIRMATIVE_ANSWERS.include?(answer.downcase.strip)
end

# Save the rating of the current run into the PStore database.
def save_rating(store, rating)
  store.transaction do
    # Initialize :all_runs key if it doesn't exist and append the rating.
    (store[:all_runs] ||= []) << rating
  end
end

# Calculate the average rating from all runs.
def calculate_average_rating(store)
  store.transaction(true) do
    all_runs = store[:all_runs] || []
    all_runs.empty? ? 0.0 : all_runs.sum / all_runs.size.to_f
  end
end

# Prompt the questions and calculate the rating for the current run.
def prompt_questions
  # Count the number of affirmative answers.
  yes_count = QUESTIONS.values.count do |question|
    print question
    yes?(gets.chomp)
  end
  # Calculate the percentage rating.
  (100 * yes_count / QUESTIONS.size).to_f
end

# Generate a report with the rating for this run and the average of all runs.
def generate_report(store)
  current_run_rating = prompt_questions
  save_rating(store, current_run_rating)
  average_rating = calculate_average_rating(store)
  # Output formatted results.
  puts format('Rating for this run: %.2f%%', current_run_rating)
  puts format('Average rating for all runs: %.2f%%', average_rating)
end

# Entry point: Create a PStore instance and generate a report.
store = PStore.new(STORE_NAME)
generate_report(store)
