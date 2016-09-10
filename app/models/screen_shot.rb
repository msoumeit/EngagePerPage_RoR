require 'capybara/poltergeist'
require "capybara/dsl"
require 'aws/s3'
class ScreenShot
  include Capybara::DSL

  # Captures a screenshot of +url+ saving it to +path+.
  def self.capture(url, path)   
    session = Capybara::Session.new(:poltergeist)
    # Browser settings
    session.driver.resize(200 , 100)
    session.driver.headers = {
      "User-Agent" => "EngagePerPage 1.0",
    }

      
    # Open page
    session.visit url

    if session.driver.status_code == 200
      # Save screenshot
      session.driver.save_screenshot(path, :full => true)
      uploadscreen = upload_screen_file(path)
      # Resize image
      # ...
    else
      # Handle error
    end
    session.driver.quit
    return uploadscreen
  end  
  
  def self.upload_screen_file(local_file)
    bucket_name = "gamtiscreen"

      s3 = AWS::S3.new(
        :access_key_id     => ENV["AWS_ACCESS_KEY_ID"], 
        :secret_access_key => ENV["AWS_SECRET_ACCESS_KEY"] 
      )


    key = File.basename(local_file)

    amazon_object = s3.buckets[bucket_name].objects[key].write(:file => local_file)
    return amazon_object #How can I get the URL of the object here?

  end
end