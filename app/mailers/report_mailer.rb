class ReportMailer < ActionMailer::Base
  default from: "ctseoinfra@gmail.com", to: "subash@codingmart.com"
  def send_report(csv,file_name)
    file_name.each_with_index do |file,index|
      file = file.gsub("/health_check_reports/",'')
      attachments[file] = csv[index]
    end
    begin
#      mail(to: "sireesh@codingmart.com", subject: 'Cleartrip Url health check report')
     mail(to: "subash@codingmart.com", subject: 'Cleartrip Url health check report',
     :bcc => ["kundan.kumar@cleartrip.com","kiran.gupta@cleartrip.com","charmis.p@cleartrip.com","sen@codingmart.com","rohan.jha@cleartrip.com","sireesh@codingmart.com","giridhar@codingmart.com","lekkala@codingmart.com"])
  rescue StandardError => e
    e.message
  end
end
end