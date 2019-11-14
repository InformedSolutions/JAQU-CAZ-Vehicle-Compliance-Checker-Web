#!/usr/bin/env ruby
require "csv"
require 'httparty'
require 'optparse'
require "aws-sdk-s3"
require 'dotenv/load'
require 'webdrivers'
require 'oauth2'
Dotenv.load('.env')
require_relative 'features/commands/shared_commands'
$vccs_web_username = ENV['VCCS_WEB_USERNAME']
$vccs_web_password = ENV['VCCS_WEB_PASSWORD']

#turns off warning
$VERBOSE = nil

@@JOB_NAME= ''
@@NTR_CSV_FILE_NAME = 'CAZ-2020-01-08-100-5.csv'
@@NTR_API_FILE_NAME = 'api_data.txt'
@@RETRO_FILE_NAME = 'CAZ-2020-01-08-1.csv' 
@@MOD_GREEN_FILE_NAME = 'CAZ-2020-01-30-7.csv'
@@MOD_WHITE_FILE_NAME = 'CAZ-2020-01-30-6.csv'
@@LOAD_TEST_VEHICLES_FILE_NAME = 'load_test/load_test_vehicles.sql'
@@JMETER_COMPLIANT_AND_NC_FILE_NAME = 'load_test/jmeter_NC_AND_C_test_vehicles.txt'
# @@JMETER_COMPLIANT_FILE_NAME = 'load_test/jmeter_compliant_test_vehicles.txt'
# @@JMETER_NON_COMPLIANT_FILE_NAME = 'load_test/jmeter_non_compliant_test_vehicles.txt'
@@JMETER_NON_COMPLIANT_VEHICLE_ENTRANT_FILE_NAME = 'load_test/jmeter_non_compliant_vehicle_entrant_test_vehicles.csv'
@@JMETER_EXEMPT_FILE_NAME = 'load_test/jmeter_exempt_test_vehicles.txt'
@@JMETER_MISSING_DATA_FILE_NAME= 'load_test/jmeter_missing_foreign_test_vehicles.txt'
@@LOAD_TEST_TAXIS_FILE_NAME = 'load_test/CAZ-2020-12-01-LoadTestTaxi-1.csv'
@@LOAD_TEST_RETRO_FILE_NAME = 'load_test/CAZ-2020-12-01-1.csv'
@@LOAD_TEST_MOD_FILE_NAME = 'load_test/CAZ-2020-12-01-2.csv'
@@NTR_API_UPLOAD_FILE_LOCATION = 'test-files/ntr/main/CAZ-2000-01-08-100-1.csv'
@@NTR_API_UPLOAD_FILE_NAME = 'CAZ-2000-01-08-100-1.csv'
@@BUCKET='jaqu-ntr-csv-bucket-dev'
@@JOB_URL='https://6peqaav570.execute-api.eu-west-2.amazonaws.com/dev/v1/scheme-management/register-csv-from-s3/jobs'
@@COGNITO_ID='ea8f5b8e-c663-451c-b3c0-d21db53dba5d'
@@UPPER_ALPHABET_ARRAY = ('A'..'Z').to_a
@@LOWER_ALPHABET_ARRAY = ('a'..'z').to_a
@@NUMBERS_ARRAY = ('1'..'9').to_a
@@LICENSING_AUTHORITY_A = 'Leeds'
@@LICENSING_AUTHORITY_B = 'Leeds'

def remove_newline(file_name)
    csv_text = File.read(file_name)
    new_csv_text = csv_text[0..-2]
    csv = File.open(file_name, 'w')
    csv.write new_csv_text
    csv.close
end

def vehicle_to_text_file(file, isLastItem, vrm, licenseStartDate, licenseEndDate, vehicleType, licensing_authority, reg, isWheelchairAccessible)
    file.puts'    {'
    file.puts'      "vrm": "' + vrm + '",'
    file.puts'      "start": "' + licenseStartDate.strftime("%Y") + '-' + licenseStartDate.strftime("%m") + '-' + licenseStartDate.strftime("%d") + '",'
    file.puts'      "end": "' + licenseEndDate.strftime("%Y") + '-' + licenseEndDate.strftime("%m") + '-' + licenseEndDate.strftime("%d") + '",'
    file.puts'      "taxiOrPHV": "' + vehicleType + '",'
    file.puts'      "licensingAuthorityName": "' + licensing_authority + '",'
    file.puts'      "licensePlateNumber": "' + reg + '",'
    file.puts'      "wheelchairAccessibleVehicle": ' + isWheelchairAccessible + ''
    if isLastItem == false
        file.puts'    },'
    else 
        file.puts'    }'  
    end  
end


def generate_ntr_vehicle(vrm=get_valid_vrm)
    reg = make_valid_reg
    vehicleType = ['taxi','PHV'].sample
    licensing_authority = [@@LICENSING_AUTHORITY_A,@@LICENSING_AUTHORITY_B].sample
    isWheelchairAccessible = ['true','false'].sample
    licenseStartDate = rand(Date.civil(1885, 01, 01)..Date.civil(2100, 12, 30))
    licenseEndDate = rand(licenseStartDate..Date.civil(2100, 12, 31))
    [vrm , licenseStartDate, licenseEndDate, vehicleType, licensing_authority, reg, isWheelchairAccessible]
end

def get_valid_vrm
    vrmp1 = @@UPPER_ALPHABET_ARRAY.shuffle[0,2].join
    vrmp2 = @@NUMBERS_ARRAY.shuffle[0,2].join
    vrmp3 = @@UPPER_ALPHABET_ARRAY.shuffle[0,3].join
    vrmp1 + vrmp2 + vrmp3
end

def get_empty_vrm
    vrmp1 = @@NUMBERS_ARRAY.shuffle[0,3].join
    vrmp2 = @@UPPER_ALPHABET_ARRAY.shuffle[0,3].join
    vrmp1 + vrmp2
end

def make_valid_reg
    reg1 = @@LOWER_ALPHABET_ARRAY.shuffle[0,2].join
    reg2 = @@UPPER_ALPHABET_ARRAY.shuffle[0,3].join
    reg1 + reg2
end

def generate_ntr_csv(invalidItems, validItems)
    puts 'Generating ntr csv with ' + invalidItems.to_s + ' invalid items and ' + validItems.to_s + ' valid items.'
    if defined?(@@FILE_NAME) == nil
        @@FILE_NAME = 'CAZ-2020-01-08-100-5.csv'
    end
    puts 'creating file ' + @@FILE_NAME
    CSV.open(@@FILE_NAME, "wb") do |csv|

        for i in 1..invalidItems do
            option = Random.rand(0..6)
            vehicleData = generate_ntr_vehicle
            case option
                when 0
                    vehicleData[0] = '$ABBA$'
                when 1
                    vehicleData[1] = 'Last Tuesday'
                when 2
                    vehicleData[2] = 'Next Tuesday'
                when 3
                    vehicleData[3] = '#13'
                when 4
                    vehicleData[4] = ''
                when 5
                    vehicleData[5] = 'AAA999A'
                when 6
                    vehicleData[6] = 'Dunno'
            end
            csv << vehicleData  
        end
 
        for i in 1..validItems do
            csv << generate_ntr_vehicle
        end

    end
    remove_newline(@@FILE_NAME)
    puts 'CSV generated'
end

def generate_ntr_api_file(numOfRows)
    puts 'Generating a file with ' + numOfRows.to_s + ' data items'
    if defined?(@@FILE_NAME) == nil
        @@FILE_NAME = @@NTR_API_FILE_NAME
    end
    puts 'Creating file ' + @@FILE_NAME
    File.open(@@FILE_NAME, "w") do |file|
        file.puts '{'
        file.puts '  "vehicleDetails": ['
        for i in 1..numOfRows do
            vehicle_data = generate_ntr_vehicle
            isLastItem = (i == numOfRows)
            vehicle_to_text_file(file, isLastItem, *vehicle_data)
        end
        file.puts'  ]'
        file.puts'}'
    end
    puts 'API file generated'
end

def generate_ntr_files(numOfRows)
    puts 'Generating a csv and a file with ' + numOfRows.to_s + ' data items'
    csv = CSV.open(@@NTR_CSV_FILE_NAME, "wb")
    file = File.open(@@NTR_API_FILE_NAME, "w")
    file.puts '{'
    file.puts '  "vehicleDetails": ['
    for i in 1..numOfRows do
        vrm = get_valid_vrm
        reg = make_valid_reg
        vehicleType = ['taxi','PHV'].sample
        licensing_authority = [@@LICENSING_AUTHORITY_A,@@LICENSING_AUTHORITY_B].sample
        isWheelchairAccessible = ['true','false'].sample
        licenseStartDate = rand(Date.civil(1885, 01, 01)..Date.civil(2100, 12, 30))
        licenseEndDate = rand(licenseStartDate..Date.civil(2100, 12, 31))
        csv << [vrm, licenseStartDate, licenseEndDate, vehicleType, licensing_authority, reg, isWheelchairAccessible]
        isLastItem = (i == numOfRows)
        vehicle_to_text_file(file, isLastItem, vrm, licenseStartDate, licenseEndDate, vehicleType, licensing_authority, reg, isWheelchairAccessible)
    end
    file.puts'  ]'
    file.puts'}'
    file.close
    csv.close
    remove_newline(@@NTR_CSV_FILE_NAME)
    puts 'CSV and API files generated'
end

def generate_retrofit_csv(numOfRows)
    puts 'Generating retro csv with: ' + numOfRows.to_s + ' rows'
    if defined?(@@FILE_NAME) == nil
        @@FILE_NAME = @@RETRO_FILE_NAME
    end
    puts 'creating file ' + @@FILE_NAME
    CSV.open(@@FILE_NAME, "wb") do |csv|
        for i in 1..numOfRows do
            vrm = get_valid_vrm
            csv << generate_retro_line(vrm)
        end
    end
    remove_newline(@@FILE_NAME)
    puts 'CSV generated'
end


def generate_retro_line(vrm)
    licenseStartDate = rand(Date.civil(1885, 01, 01)..Date.civil(2100, 12, 30))
    return [vrm , "category-1", "model-1", licenseStartDate]
end


def generate_mod_white_csv(numOfRows)
    puts 'Generating MOD csv with: ' + numOfRows.to_s + ' rows'
    if defined?(@@FILE_NAME) == nil
        @@FILE_NAME = @@MOD_WHITE_FILE_NAME
    end
    puts 'creating file ' + @@FILE_NAME
    CSV.open(@@FILE_NAME, "wb") do |csv|
        for i in 1..numOfRows do
            vrm = get_valid_vrm
            csv << [vrm]
        end
    end
    remove_newline(@@FILE_NAME)
    puts 'CSV generated'
end

def generate_mod_green_csv(numOfRows)
    puts 'Generating MOD csv with: ' + numOfRows.to_s + ' rows'
    if defined?(@@FILE_NAME) == nil
        @@FILE_NAME = @@MOD_GREEN_FILE_NAME
    end
    puts 'creating file ' + @@FILE_NAME
    CSV.open(@@FILE_NAME, "wb") do |csv|
        for i in 1..numOfRows do
            vrm1 = get_valid_vrm
            option = Random.rand(1..3)
            case option
            when 1
                csv << [vrm1]
            when 2  
                csv << [nil, vrm1]
            when 3
                vrm2 = get_valid_vrm
                csv << [vrm1, vrm2] 
            end
        end
    end
    remove_newline(@@FILE_NAME)
    puts 'CSV generated'
end

def get_model
    option = Random.rand(1..5)
    case option
    when 1
        return 'Hyundai'
    when 2  
        return 'Reliant-Robin'
    when 3
        return 'Volkswagen'
    when 4
        return 'Caterpillar'
    when 5
        return 'Bugatti'
    end
end

#using only 1 color in the end so i can clear the db faster for cleanup
def get_colour
    # option = Random.rand(1..5)
    # case option
    # when 1
    #     return 'Beige'
    # when 2  
    #     return 'Salmon'
    # when 3
    #     return 'Chartreuse'
    # when 4
    #     return 'Violet'
    # when 5
    #     return 'Chrome'
    # end
    return 'BlueLoadTest'
end

def load_test_process(compliant_items, non_compliant_items, exempt_items, missing_data_vehicles)
    compliant_taxis = (compliant_items / 7 .to_f).ceil
    compliant_vehicles = compliant_items - compliant_taxis
    non_compliant_taxis = (non_compliant_items / 10 .to_f).ceil
    non_compliant_vehicles = non_compliant_items - non_compliant_taxis
    exempt_taxis = (exempt_items / 7 .to_f).ceil
    exempt_vehicles = exempt_items - exempt_taxis
    total = compliant_taxis+compliant_vehicles+non_compliant_taxis+non_compliant_vehicles+exempt_taxis+exempt_vehicles + missing_data_vehicles

    puts '***** Generating load test files ******'
    puts 'compliant vehicles:' + compliant_vehicles.to_s
    puts 'compliant taxis:' + compliant_taxis.to_s
    puts 'non compliant vehicles:' + non_compliant_vehicles.to_s
    puts 'non compliant taxis:' + non_compliant_taxis.to_s
    puts 'exempt vehicles:' + exempt_vehicles.to_s
    puts 'exempt taxis:' + exempt_taxis.to_s
    puts 'missing data/foreign vehicles: ' +  missing_data_vehicles.to_s
    puts 'Total:' + total.to_s
    puts '************************************'

    File.open(@@LOAD_TEST_VEHICLES_FILE_NAME, "w") do |file|
        File.open(@@JMETER_COMPLIANT_AND_NC_FILE_NAME, "w") do |j_nc_c_file|
            File.open(@@JMETER_EXEMPT_FILE_NAME, "w") do |j_e_file|
                CSV.open(@@LOAD_TEST_TAXIS_FILE_NAME, "wb") do |csv|
                    CSV.open(@@LOAD_TEST_RETRO_FILE_NAME, "wb") do |retro_csv|
                        CSV.open(@@LOAD_TEST_MOD_FILE_NAME, "wb") do |mod_csv|
                            File.open(@@JMETER_MISSING_DATA_FILE_NAME, "wb") do |missing_data_file|
                                for i in 1..compliant_taxis do
                                    vrm = get_valid_vrm
                                    j_nc_c_file.puts vrm
                                    csv << generate_ntr_vehicle(vrm)
                                    file.puts "INSERT INTO vehicle (registrationNumber, typeApproval, make, colour, fuelType, euroStatus, expectedexempt, expectedcompliant, expectedtype) values ('" + vrm + "', 'M1', '" + get_model + "', '" + get_colour + "', 'Petrol', '4', false, true, 'Car');"
                                end
                                for i in 1..compliant_vehicles do
                                    vrm = get_valid_vrm
                                    j_nc_c_file.puts vrm
                                    file.puts "INSERT INTO vehicle (registrationNumber, typeApproval, make, colour, fuelType, euroStatus, expectedexempt, expectedcompliant, expectedtype) values ('" + vrm  + "', 'M1', '" + get_model + "', '" + get_colour + "', 'Petrol', '4', false, true, 'Car');"
                                end
                                for i in 1..non_compliant_taxis do
                                    vrm = get_valid_vrm
                                    j_nc_c_file.puts vrm           
                                    csv << generate_ntr_vehicle(vrm)
                                    file.puts "INSERT INTO vehicle(registrationNumber, typeApproval, make, colour, fuelType, euroStatus, grossWeight, massInService, seatingCapacity, expectedexempt, expectedcompliant, expectedtype) values ('" + vrm + "', 'M2', '" + get_model + "', '" + get_colour + "', 'Diesel', '4', '4999', '2583', '8', false, true, 'Car');"
                                end
                                for i in 1..non_compliant_vehicles do
                                    vrm = get_valid_vrm
                                    j_nc_c_file.puts vrm
                                    file.puts "INSERT INTO vehicle(registrationNumber, typeApproval, make, colour, fuelType, euroStatus, grossWeight, massInService, seatingCapacity, expectedexempt, expectedcompliant, expectedtype) values  ('" + vrm + "', 'M2', '" + get_model + "', '" + get_colour + "', 'Diesel', '4', '4999', '2583', '8', false, true, 'Car');"
                                end
                                for i in 1..exempt_taxis do
                                    vrm = get_valid_vrm
                                    j_e_file.puts vrm
                                    retro_csv << generate_retro_line(vrm)
                                    csv << generate_ntr_vehicle(vrm)
                                    file.puts "INSERT INTO vehicle (registrationNumber, typeApproval, make, colour, fuelType, euroStatus, expectedexempt, expectedcompliant, expectedtype) values ('" + vrm + "', 'M1', '" + get_model + "', '" + get_colour + "', 'Electric', '79', true, false, 'Car');"
                                end
                                for i in 1..exempt_vehicles do
                                    vrm = get_valid_vrm
                                    j_e_file.puts vrm
                                    mod_csv << [vrm]
                                    file.puts "INSERT INTO vehicle (registrationNumber, typeApproval, make, colour, fuelType, euroStatus, expectedexempt, expectedcompliant, expectedtype) values ('" + vrm + "', 'M1', '" + get_model + "', '" + get_colour + "', 'Electric', '79', true, false, 'Car');"
                                end
                                for i in 1..missing_data_vehicles do
                                    vrm = get_empty_vrm
                                    missing_data_file.puts vrm
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    vrns = []

    # Create a file with 10 vrns in each line to mimic an anpr camera sending data
    File.truncate(@@JMETER_NON_COMPLIANT_VEHICLE_ENTRANT_FILE_NAME, 0)
    File.foreach(@@JMETER_COMPLIANT_AND_NC_FILE_NAME).with_index do |line, line_num|
        line.delete!("\n")
        vrns.push(line)
        if vrns.length().eql? 10 
            IO.write(@@JMETER_NON_COMPLIANT_VEHICLE_ENTRANT_FILE_NAME, vrns.join(","),  mode: 'a')
            IO.write(@@JMETER_NON_COMPLIANT_VEHICLE_ENTRANT_FILE_NAME, "\n",  mode: 'a')
            vrns = []
        end
     end
end

def upload_file_with_selenium(service, filename)
    @screenshot_path = './screenshots/'+ ENV['SCREENSHOT_TYPE'] +'/gtd/'
    options = Selenium::WebDriver::Chrome::Options.new
    #options.add_argument('--headless')
    options.add_option(:detach, true)
    $driver = Selenium::WebDriver.for :chrome, options: options
    $wait = Selenium::WebDriver::Wait.new(timeout: 500)
    if service.eql? 'ntr'
        @base_url = ENV['BASEURL_NTR']
        if filename.eql? nil
            filename = @@NTR_CSV_FILE_NAME
        end
    elsif service.eql? 'retro'
        @base_url = ENV['BASEURL_RETRO']
        if filename.eql? nil
            filename = @@RETRO_FILE_NAME
        end
    elsif service.eql? 'mod_green'
        @base_url = ENV['BASEURL_MOD']
        if filename.eql? nil
            filename = @@MOD_GREEN_FILE_NAME
        end
    elsif service.eql? 'mod_white'
        @base_url = ENV['BASEURL_MOD']
        if filename.eql? nil
            filename = @@MOD_WHITE_FILE_NAME
        end
        $driver.get(@base_url)
        $driver.manage.add_cookie(opts={name:'seen_cookie_message', value: 'true'})
        SharedCommands.login_with_credentials(ENV['WHITE_MOD_VALID_USERNAME'], ENV['WHITE_MOD_VALID_PASSWORD'])
        SharedCommands.upload_file(File.expand_path(filename))

        return
    end

    $driver.get(@base_url)
    $driver.manage.add_cookie(opts={name:'seen_cookie_message', value: 'true'})
    SharedCommands.login_with_credentials
    SharedCommands.upload_file(File.expand_path(filename))
    $driver.quit
end

def upload_csv
    puts 'Uploading file to s3 with metadata'
    s3 = Aws::S3::Resource.new(region:'eu-west-2')
    obj = s3.bucket(@@BUCKET).object(@@NTR_API_UPLOAD_FILE_NAME)
    new_metadata = {'uploader-id' => @@COGNITO_ID}

    obj.upload_file(@@NTR_API_UPLOAD_FILE_LOCATION, metadata:new_metadata)
end

def initiate_register_job
    puts 'initiating register job'
    body = { 
        s3Bucket: @@BUCKET,
        filename: @@NTR_API_UPLOAD_FILE_NAME
    }

    headers = { 
    "Content-Type" =>"application/json",
    "X-Correlation-ID" => @@COGNITO_ID
    }

    response = HTTParty.post(
        @@JOB_URL, 
        body: body.to_json,
        headers: headers
    )
    
    body = JSON.parse(response.body)
    @@JOB_NAME = body['jobName']
end

def poll_status_job(job_name=@@JOB_NAME)
    headers = {
        "X-Correlation-ID" => @@COGNITO_ID
    }
    loop do 
        response = HTTParty.get(
            @@JOB_URL + '/'+ job_name,
            headers: headers
        )
        break if response.body.include? 'SUCCESS' or response.body.include? 'FAILURE'
    end 

    response = HTTParty.get(
        @@JOB_URL + '/'+ job_name,
        headers: headers
    )
    puts response.body
end

def upload_to_api()
    # if defined?(@@FILE_NAME) == nil
    #     @@FILE_NAME = @@NTR_API_UPLOAD_FILE_NAME
    # end
    upload_csv()
    initiate_register_job()
    poll_status_job()
end

def upload_to_api_via_body()
    body = File.read("api_data.txt")

        
    client = OAuth2::Client.new(
    ENV['CLIENT_ID'], 
    ENV['CLIENT_SECRET'], 
    site: ENV['BASEURL_NTR_OAUTH'], 
    token_url: "oauth2/token"
    )

    token = client.client_credentials.get_token()
    
    headers = { 
        "Content-Type" =>"application/json",
        "X-Correlation-ID" => SharedCommands.ntr_sub_id,
        "x-api-key" => SharedCommands.ntr_sub_id,
        "Authorization " => 'Bearer ' + token.token
    }
        t1 = Time.now
        queryAnswer = HTTParty.post(ENV['BASEURL_NTR_API'] + '/v1/scheme-management/taxiphvdatabase',
            :headers => headers,
            :body => body)
        t2 = Time.now
        
        puts queryAnswer.body

        delta = t2 - t1
        puts delta
    end

options = {}
optparse = OptionParser.new do|opts|
# TODO: Put command-line options here
# This displays the help screen, all programs are
# assumed to have this option.
    opts.on( '-h', '--help', 'Display this screen' ) do
        puts opts
        exit
    end

    opts.on('-f [FILENAME]',"Set the name of the file to be generated (MUST BE WRITTEN IN FRONT OF ANY OTHER COMMANDS)") do |file_name|
        @@FILE_NAME = file_name
    end

    opts.on('-l [LICENCEAUTH',"Set the la (MUST BE WRITTEN IN FRONT OF ANY OTHER COMMANDS)") do |licence_auth|
        @@LICENSING_AUTHORITY_A = licence_auth
        @@LICENSING_AUTHORITY_B = licence_auth
    end

    opts.on('--ntrcsv [INVALID],[VALID]',"Generate [INVALID] invalid and [VALID] valid taxi data items in CSV form") do |input|
        if input == nil
            generate_ntr_csv(0,5)
        else
            invalid_items, valid_items = input.split(",")
            generate_ntr_csv(invalid_items.to_i, valid_items.to_i)
        end
    end

    opts.on('--ntrapi [NUMBER]',"Generate [NUMBER] valid taxi data items in a text file, ready for API upload") do |number|
        if number == nil
            generate_ntr_api_file(5)
        else
            generate_ntr_api_file(number.to_i)
        end
    end

    opts.on('--ntrboth [NUMBER]',"Generate [NUMBER] valid taxi data items in both CSV and API form") do |number|
        if number == nil
            generate_ntr_files(5)
        else
            generate_ntr_files(number.to_i)
        end
    end

    opts.on('--retro [NUMBER]',"Generate [NUMBER] valid retrofitted vehicle data items in CSV form") do |number|
    if number == nil
        generate_retrofit_csv(5)
        else
            generate_retrofit_csv(number.to_i)
        end
    end

    opts.on('--modwhite [NUMBER]',"Generate [NUMBER] valid white category Ministry of Defence vehicle data items in CSV form") do |number|
        if number == nil
            generate_mod_white_csv(5)
        else
            generate_mod_white_csv(number.to_i)
        end
    end

    opts.on('--modgreen [NUMBER]',"Generate [NUMBER] valid green category Ministry of Defence vehicle data items in CSV form") do |number|
        if number == nil
            generate_mod_green_csv(5)
        else
            generate_mod_green_csv(number.to_i)
        end
    end

    opts.on('--ldtst [COMPLIANT],[NON-COMPLIANT],[EXEMPT],[MISSING_DATA]',"Generate [COMPLIANT] compliant, [NON-COMPLIANT] non_compliant, [MISSING_DATA/foreign] vehicles etc. data items for a VCCS load test") do |input|
        if input == nil
            load_test_process(5,0,0,0)
        else
            compliant_items, non_compliant_items, exempt_items, missing_data = input.split(",")
            load_test_process(compliant_items.to_i, non_compliant_items.to_i, exempt_items.to_i, missing_data.to_i)
        end
    end    

    opts.on('--upldntr [FILENAME]', 'Uploads the [FILENAME] csv to the NTR') do |filename|
        upload_file_with_selenium('ntr', filename)
    end

    opts.on('--upldretro [FILENAME]', 'Uploads the [FILENAME] csv to the Retrofit service') do |filename|
        upload_file_with_selenium('retro', filename) 
    end

    opts.on('--upldmodg [FILENAME]', 'Uploads the [FILENAME] csv to the MOD green service') do |filename|
        upload_file_with_selenium('mod_green', filename)
    end

    opts.on('--upldmodw [FILENAME]', 'Uploads the [FILENAME] csv to the MOD white service') do |filename|
        upload_file_with_selenium('mod_white', filename)
    end

    opts.on('--upldntrapi', 'Uploads a CSV via the NTR API system') do
        upload_to_api()
    end

    opts.on('--upldntrapibody', 'Uploads a CSV via the NTR API system') do
        upload_to_api_via_body()
    end
end

optparse.parse!
