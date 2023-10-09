# national-insurance-number-generate
This program is used to generate a National Insurance number (NI Number) from personal data.

You can run this program from Irb and require the 'national_insurance_number.rb' file.

`irb -r ./national_insurance_number.rb`

To create National Insurance numbers for each person in a CSV file you can run this method which takes a csv file name as an argument:

`people = NationalInsurance::generate_ni_numbers(file_name)` eg: 'data_files/list_of_people.csv'

This then generates an array of people from the file and saves them with their NI number to an array called `@people`.

To count how many national insurance numbers for each country you can pass in a list of people to this method:

`NationalInsurance::count_ni_numbers(people)`





