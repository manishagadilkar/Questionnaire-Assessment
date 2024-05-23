## Usage

```sh
bundle
ruby questionnaire.rb
```

## Goal

The goal is to implement a survey where a user should be able to answer a series of Yes/No questions. After each run, a rating is calculated to let them know how they did. Another rating is also calculated to provide an overall score for all runs.

## Requirements

Possible question answers are: "Yes", "No", "Y", or "N" case insensitively to answer each question prompt.

The answers will need to be **persisted** so they can be used in calculations for subsequent runs >> it is proposed you use the pstore for this, already included in the Gemfile

After _each_ run the program should calculate and print a rating. The calculation for the rating is: `100 * number of yes answers / number of questions`.

The program should also print an average rating for all runs.

The questions can be found in questionnaire.rb

Ensure we can run your exercise

## Approach
Below is an explanation of the approach taken:

## Data Storage
A PStore database, which is a file-based persistence mechanism in Ruby, is utilized to store the ratings from each run of the program.

## Questions and Input Handling
A constant hash, QUESTIONS, stores the prompts that are displayed to the user. To accommodate case insensitivity and allow for abbreviated answers, the yes? method was created to standardize and validate the user's input against acceptable affirmative answers ("Yes", "Y").

## Rating Calculation and Persistence
For each run, the program calculates a rating based on the proportion of affirmative answers to the total number of questions. This rating is saved to the PStore database for future reference.

## Average Rating Computation
The program calculates the average rating from all stored runs to provide historical insight into the user's performance over time.

## User Interaction
The user is prompted with each question one by one, and their input is processed through the do_prompt method. The current run's rating and the average rating are then output to the console using the do_report method.

## Code Structure
The code is structured into reusable methods to handle specific parts of the workflow:

yes? - Validates if the given answer is affirmative.
save_rating - Saves the rating for the current run into the PStore database.
calculate_average_rating - Computes the average rating from all previous runs.
do_prompt - Runs the prompt loop to ask questions and collect answers.
do_report - Generates and prints out the report including the current run's rating and the overall average rating.
By keeping the logic encapsulated within methods, the code remains clean, maintainable, and easy to follow.

## Running the Program
To run the program, simply execute the Ruby script from the command line. It will guide you through the assessment process and provide immediate feedback on your rating and historical performance.

# to run the program use: 
ruby questionnaire.rb

# To run test cases using Rspec 
First install the Respec gem on your madhine which mentioned in Gemfile 
to run the test cases use:
 rspec questionnaire_spec.rb 