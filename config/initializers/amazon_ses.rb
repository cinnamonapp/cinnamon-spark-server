ActionMailer::Base.add_delivery_method :ses_system_message, AWS::SES::Base,
                                       :access_key_id     => ENV['MAILER_USERNAME'],
                                       :secret_access_key => ENV['MAILER_PASSWORD'],
                                       :server => 'email.us-west-2.amazonaws.com'
