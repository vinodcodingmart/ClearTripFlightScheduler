
class ApplicationProcessor

 def to_time(timeObj)
      begin
        timeObj.strftime("%H:%M %p")
      rescue
        ""
      end
    end
  def url_escape(url_string)
    unless url_string.blank?
      result = url_string.encode("UTF-8", :invalid => :replace, :undef => :replace).to_s
      result = result.gsub(/[\/]/,'-')
      result = result.gsub(/[^\x00-\x7F]+/, '') # Remove anything non-ASCII entirely (e.g. diacritics).
      result = result.gsub(/[^\w_ \-]+/i,   '') # Remove unwanted chars.
      result = result.gsub(/[ \-]+/i,      '-') # No more than one of the separator in a row.
      result = result.gsub(/^\-|\-$/i,      '') # Remove leading/trailing separator.
      result = result.downcase
    end
  end
  
  def host_country_code(host)
    # host = host || ""
    # puts "country_code - #{country_code}"
    if host == 'https://www.cleartrip.ae'
      return ['AE',"United Arab Emirates"]
    elsif host == 'https://kw.cleartrip.com'
      return ['KW',"Kuwait"]
    elsif host == 'https://www.cleartrip.sa'
      return ['SA',"Saudi Arabia"]
    elsif host == 'https://bh.cleartrip.com'
      return ['BH',"Bahrain"]
    elsif host == 'https://qa.cleartrip.com'
      return ['QA',"Qatar"]
    elsif host == 'https://om.cleartrip.com'
      return ['OM',"Oman"]
    elsif host == 'https://www.cleartrip.com'
    return ['IN',"India"]
    else
     ['IN',"India"]
    end
  end

  def host_name(country_code)
    # puts "country_code - #{country_code}"
    if country_code == 'AE'
      return 'https://www.cleartrip.ae'
    elsif country_code == 'KW'  
      return 'https://kw.cleartrip.com'
    elsif country_code == 'SA'
      return 'https://www.cleartrip.sa'
    elsif country_code == 'BH'
      return 'https://bh.cleartrip.com'
    elsif country_code == 'QA'
      return 'https://qa.cleartrip.com'
    elsif country_code == 'OM'
      return 'https://om.cleartrip.com'
    elsif country_code == 'IN'
      return 'https://www.cleartrip.com'
    else
      ''
    end
  end

 def currency_code(country_code)
  if country_code == 'AE'
    return 'AED'
  elsif country_code == 'KW'
    return 'KWD'
  elsif country_code == 'SA'
    return 'SAR'
  elsif country_code == 'BH'
    return 'BHD'
  elsif country_code == 'QA'
    return 'QAR'
  elsif country_code == 'OM'
    return 'OMR'
  elsif country_code == 'IN'
    return '₹'
  else
    ''
  end
end

  def currency_name(country_code)
    if country_code == 'AE'
      return 'AED'
    elsif country_code == 'KW'
      return 'KWD'
    elsif country_code == 'SA'
      return 'SAR'
    elsif country_code == 'BH'
      return 'BHD'
    elsif country_code == 'QA'
      return 'QAR'
    elsif country_code == 'OM'
      return 'OMR'
    elsif country_code == 'IN'
      return 'Rs.'
    else
      ''
    end
  end
end
