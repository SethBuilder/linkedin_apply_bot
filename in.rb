require 'watir'

Selenium::WebDriver::Firefox.driver_path = 'C:\Users\bnbih\Desktop\ig_bot\geckodriver.exe' 
def start

	#read my linkedin username and password
	username = "Fill Your Username"
	password = "Fill Your Password"

	# Fill in keywords for desired job posts. For ex: python, php, full stack. Replace spaces with 20%
	domains = ['laravel', 'php', 'full%20stack']

	# Apply for first three pages (recommended so not to get caught by bot traps)
	pages = ['0','25', '50',]

	# Open Browser (firefox), Navigate to Login
	browser = Watir::Browser.new :firefox
	browser.goto 'https://www.linkedin.com/uas/login'

	# Navigate to Username and Password fields, inject info
	puts "Loging in ..."
	sleep(2)
	browser.text_field(:id => 'session_key-login').set "#{username}"
	sleep(1)
	browser.text_field(:id => 'session_password-login').set "#{password}"
	sleep(1)
	# Click Login Button
	browser.button(:class => ['btn-primary'],:tag_name=>"button").click
	sleep(2)


	# Loop through job domains
	domains.each { |dom|

		# Loop through pagination
		pages.each { |val|

			# Go to the job search page
			browser.goto "https://www.linkedin.com/jobs/search/?currentJobId=677376543&f_LF=f_AL&f_TP=1&keywords=#{dom}&location=Worldwide&locationId=OTHERS.worldwide&start=#{val}"

			puts "Applying in progress, close me when done!"

			#scroll down a bit to make more jobs visible to the bot
			for i in 0..2
			   	browser.driver.execute_script("document.querySelector('.jobs-search-results').scrollTop=10000;")
				sleep(1)
				browser.driver.execute_script("document.querySelector('.jobs-search-results').scrollTop=0;")
			end
			
			r = Random.rand(13...20)

			#Collect the "Job Cards" buttons
			browser.divs(:class => 'job-card-search--two-pane',  :tag_name=>"div").take(r.to_i).each_with_index do |b, index|
				puts index
				if index == 0
					b.click
					puts "Started applying!"
				else
					begin
						#Click them! One by one.
						b.click
						sleep(5)

						# Click Apply Button
						browser.button(:class => ['jobs-s-apply__button'],:tag_name=>"button").click

						sleep(3)
					rescue
						puts "This button wasn't clickable, moving on!"
					end
				end

				# Generate random sleep period
				r = Random.rand(2...5)

				#Sleep so not to appear like a bot.
				sleep(r)
			end
		}
	}

end


# Start execution 
begin
	start()
# Write a log in case of error
rescue Exception => e
	puts e.inspect
	puts e.backtrace
	File.open("except.log", "w") do |f|
		f.puts e.inspect
		f.puts e.backtrace
	end


	end

