require 'csv'
module NationalInsurance
  # A class to model the personal data from the CSV file and to store the generated NI number
  class Person
    attr_accessor :first_names, :last_name, :date_of_birth, :country_of_birth, :ni_number
    def initialize(first_names, last_name, date_of_birth, country_of_birth)
      @first_names = first_names
      @last_name = last_name
      @date_of_birth = date_of_birth
      @country_of_birth = country_of_birth
      @ni_number = nil
    end
  end

  # Load a CSV file from give path
  def self.load_csv_file(path_to_file)
    CSV.parse(File.read(path_to_file), headers: true)
  end

  # create a person from a single CSV row of data
  def self.create_person_from_csv_data(csv_data)
      person = Person.new(
        csv_data['First names'],
        csv_data['Last name'],
        csv_data['Date of Birth'],
        csv_data['Country of Birth']
      )
      person
  end

  # Build a NI number from a person object
  def self.build_ni_number_from_person(person)
    ni_number = []
    ni_number << get_initial_character_from_string(person.first_names)
    ni_number << get_initial_character_from_string(person.last_name)
    ni_number << get_last_two_digits_from_year_of_birth(person.date_of_birth)
    ni_number << generate_random_digits
    ni_number << extract_country_code(person.country_of_birth)
    ni_number.join
  end

  # Load a csv file and remove any title or post-nominal and build an NI number
  # push each person to an array
  def self.generate_ni_numbers(file)
    people = []
    @table_data = load_csv_file(file)
    @table_data.each do |table_row|
      person = create_person_from_csv_data(table_row)
      person.first_names = remove_title(person.first_names)
      person.first_names = remove_post_nominals(person.first_names)
      person.ni_number = build_ni_number_from_person(person)
      people << person
    end
    people
  end

  # Print out each person in nice format
  def self.print_person(person)
    puts "First name: #{person.first_names}"
    puts "Last name: #{person.last_name}"
    puts "DOB: #{person.date_of_birth}"
    puts "COB: #{person.country_of_birth}"
    puts "NI: #{person.ni_number}"
    puts "\n"
  end

  # Generate a random 4 digit number
  def self.generate_random_digits
    rand(1000..9999).to_s
  end

  # extract first letter of given country
  def self.extract_country_code(country)
    country_code = if ['Wales', 'England', 'Scotland', 'Northern Ireland'].include?(country)
                     country[0...1]
                   else
                     'O'
                   end
    country_code
  end

  # get first character of string
  def self.get_initial_character_from_string(string)
    string[0...1]
  end

  # Get last two digits from given year of birth
  def self.get_last_two_digits_from_year_of_birth(date_of_birth)
    date_of_birth[0...4]
  end

  # Remove any titles from first names
  def self.remove_title(name)
    name_array = name.split
    name_array.each {|n| name_array.delete(n) if n.include?('.')}
    name_array.join(' ')
  end

  # Removes post-nominals from first names
  def self.remove_post_nominals(name)
    name_array = name.split
    name_array.each {|n| name_array.delete(n) if n == n.upcase || n == 'PhD'}
    name_array.join(' ')
  end

  # Takes an argument of people and counts the NI numbers for each country
  def self.count_ni_numbers(people)
    if people.nil?
      raise StandardError 'nil value passed in'
    else
      countries = {'Wales': 0, 'Scotland': 0, 'England': 0, 'Northern Ireland': 0, 'Other':0}
      people.each do |person|
        countries.each do |key, _value|
          if key[0] == person.ni_number[-1]
            countries[key] += 1
          end
        end
      end
      puts countries
    end
  end
end
