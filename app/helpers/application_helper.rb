  module ApplicationHelper

    def format_duration(duration)
    if duration.include?(":")
      r =  duration.gsub(":00",'').gsub(":00:00",'').split(":")
      if r[0].to_i < 24
        d = duration.to_time.strftime("%Hh %Mm")
      elsif r[0].to_i >= 24 && r[0].to_i <=  48
        d = (r[0].to_i - 24).to_s + ":#{r[1]}"
        d = d.to_time.strftime("%Hh %Mm")
        d = "1d #{d}"
      elsif r[0].to_i >= 48 && r[0].to_i <= 72
        d = (r[0].to_i - 48).to_s + ":#{r[1]}"
        d = d.to_time.strftime("%Hh %Mm")
        d = "2d #{d}"
      end
    else
      d = Time.at(duration.to_i*60).utc.strftime("%Hh %Mm")
    end
    return d
  end

    def seo_header
      meta_title = meta_keywords = meta_description = ""
      meta_info = SEO_META[@meta_page_type]
      host = get_domain
      case @meta_page_type
      when "flight-schedule"
        if @language == "ar"
          title = (@title_min_price.present? && @title_min_price!=0) ? "title_with_price" : "title_without_price"
          meta_title = meta_info["#{@country_code.downcase}_#{@section[3..5]}"]["#{@language.downcase}"]["#{title}"] %{dep_city_name: @dep_city_name_ar,arr_city_name: @arr_city_name_ar,price: @title_min_price} rescue ""
          meta_description = meta_info["#{@country_code.downcase}_#{@section[3..5]}"]["#{@language.downcase}"]["description"] %{dep_city_name: @dep_city_name_ar,arr_city_name: @arr_city_name_ar,host: host} rescue ""
          meta_keywords = meta_info["#{@country_code.downcase}_#{@section[3..5]}"]["#{@language.downcase}"]["keywords"] %{dep_city_name: @dep_city_name_ar,arr_city_name: @arr_city_name_ar} rescue ""
          amp_url = meta_info["#{@country_code.downcase}_#{@section[3..5]}"]["#{@language.downcase}"]["amp_url"] %{dep_city_name_formated: @dep_city_name_formated,arr_city_name_formated: @arr_city_name_formated}
        else
          title = (@title_min_price.present? && @title_min_price > 0) ? "title_with_price" : "title_without_price"
          meta_title = meta_info["#{@country_code.downcase}_#{@section[3..5]}"]["#{@language.downcase}"]["#{title}"] %{dep_city_name: @dep_city_name,arr_city_name: @arr_city_name,price: @title_min_price} rescue ""
          meta_description = meta_info["#{@country_code.downcase}_#{@section[3..5]}"]["#{@language.downcase}"]["description"] %{dep_city_name: @dep_city_name,arr_city_name: @arr_city_name} rescue ""
          meta_keywords = meta_info["#{@country_code.downcase}_#{@section[3..5]}"]["#{@language.downcase}"]["keywords"] %{dep_city_name: @dep_city_name,arr_city_name: @arr_city_name} rescue ""
          amp_url = meta_info["#{@country_code.downcase}_#{@section[3..5]}"]["#{@language.downcase}"]["amp_url"] %{dep_city_name_formated: @dep_city_name_formated,arr_city_name_formated: @arr_city_name_formated}
        end
      when "from"
        if @language == "ar"
          meta_title = meta_info["#{@country_code.downcase}_from"]["#{@language.downcase}"]["title"] %{city_name: @city_name_ar} rescue ""
          meta_description = meta_info["#{@country_code.downcase}_from"]["#{@language.downcase}"]["description"] %{city_name: @city_name_ar} rescue ""
          meta_keywords = meta_info["#{@country_code.downcase}_from"]["#{@language.downcase}"]["keywords"] %{city_name: @city_name_ar} rescue ""
          amp_url = ""
        else
          meta_title = meta_info["#{@country_code.downcase}_from"]["#{@language.downcase}"]["title"] %{city_name: @city_name} rescue ""
          meta_description = meta_info["#{@country_code.downcase}_from"]["#{@language.downcase}"]["description"] %{city_name: @city_name} rescue ""
          meta_keywords = meta_info["#{@country_code.downcase}_from"]["#{@language.downcase}"]["keywords"] %{city_name: @city_name} rescue ""
          amp_url = ""
        end
      when "to"
        if @language == "ar"
          meta_title = meta_info["#{@country_code.downcase}_to"]["#{@language.downcase}"]["title"] %{city_name: @city_name_ar} rescue ""
          meta_description = meta_info["#{@country_code.downcase}_to"]["#{@language.downcase}"]["description"] %{city_name: @city_name_ar} rescue ""
          meta_keywords = meta_info["#{@country_code.downcase}_to"]["#{@language.downcase}"]["keywords"] %{city_name: @city_name_ar} rescue ""
          amp_url = ""
        else
          meta_title = meta_info["#{@country_code.downcase}_to"]["#{@language.downcase}"]["title"] %{city_name: @city_name} rescue ""
          meta_description = meta_info["#{@country_code.downcase}_to"]["#{@language.downcase}"]["description"] %{city_name: @city_name} rescue ""
          meta_keywords = meta_info["#{@country_code.downcase}_to"]["#{@language.downcase}"]["keywords"] %{city_name: @city_name} rescue ""
          amp_url = ""
        end
      when "schedule_index"
        if @language == "ar"
          meta_title = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section}"]["title"] rescue ""
          meta_description = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section}"]["description"] rescue ""
          meta_keywords = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section}"]["keywords"]  rescue ""
        else
          meta_title = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section}"]["title"] rescue ""
          meta_description = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section}"]["description"] rescue ""
          meta_keywords = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section}"]["keywords"] rescue ""
        end
      when "booking-overview"
        if @language == "ar"
          meta_title =  @meta_title.present? ? @meta_title : meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section[3..5]}"]["title"] %{airline_name: @carrier_name_ar} rescue ""
          meta_description = @meta_description.present? ? @meta_description : meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section[3..5]}"]["description"] %{airline_name: @carrier_name_ar} rescue ""
          meta_keywords = @meta_keywords.present? ? @meta_keywords : meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section[3..5]}"]["keywords"] %{airline_name: @carrier_name_ar} rescue ""
          amp_url = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["amp_url"] %{file_name: @file_name}
        else
          meta_title = @meta_title.present? ? @meta_title :  meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section[3..5]}"]["title"] %{carrier_name: @carrier_name} rescue ""
          meta_description = @meta_description.present? ? @meta_description : meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section[3..5]}"]["description"] %{carrier_name: @carrier_name} rescue ""
          meta_keywords = @meta_keywords.present? ? @meta_keywords : meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section[3..5]}"]["keywords"] %{carrier_name: @carrier_name} rescue ""
          amp_url = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["amp_url"] %{file_name: @file_name}
        end
      when "pnr_status"
        if @language == "ar"
          meta_title = "#{@carrier_name_ar} الحالة طيران | #{@carrier_name_ar} الحالة | تحقق #{@carrier_name_ar} الطيران و الحالة أون لاين"
          meta_description = "التحقق #{@carrier_name_ar} وضع الطيران و الحالة في Cleartrip.com . ونحن نقدم حالة الطيران عبر الإنترنت و وضع مرفق فحص لجميع #{@carrier_name_ar} الجوية. البحث في الوقت الحقيقي حالة الرحلة ، وكذلك الوضع من #{@carrier_name_ar} رحلات طيران قبل تاريخ السفر"
          meta_keywords = "#{@carrier_name_ar} حالة رحلات الطيران ، شيك #{@carrier_name_ar} حالة الرحلة ، #{@carrier_name_ar} تحقيق حالة رحلات الطيران ، #{@carrier_name_ar} الحالة PNR ، شيك #{@carrier_name_ar} الحالة ، #{@carrier_name_ar} PNR تحقيق الحالة"
        else
          meta_title = "check your #{@carrier_name} flight PNR Status on Cleartrip."
          meta_description = "Check #{@carrier_name} flight status and PNR Status at Cleartrip.com. We provide online flight status and PNR status checking facility for all #{@carrier_name} flights. Find the real time flight status as well as PNR status of #{@carrier_name} flights before your travel date"
          meta_keywords = "#{@carrier_name} web checkin, #{@carrier_name} Online Check in, #{@carrier_name}  flights, #{@carrier_name} booking, United #{@carrier_name} booking, #{@carrier_name} flights, #{@carrier_name}  tickets, #{@carrier_name} , #{@carrier_name} air tickets, #{@carrier_name} air fares, #{@carrier_name} flight schedule"
        end
        amp_url = ""
      when "web_checkin"
        if @language == "ar"
          meta_title = "فحص الأمتعة على الويب #{@carrier_name_ar}، فحص الأمتعة على الانترنت #{@carrier_name_ar} – كليرتريب"
          meta_description = "استخدم تسهيلات فحص الأمتعة على الويب #{@carrier_name_ar} بسرعة و اطبع بطاقة الصعود على الطائرة من المنزل/ المكتب وتابع مباشرة إلى الفحص الأمني على الطائرة."
          meta_keywords = "فحص الأمتعة على الويب #{@carrier_name_ar}، فحص الأمتعة على الانترنت #{@carrier_name_ar}، رحلات  #{@carrier_name_ar}، الحجز على #{@carrier_name_ar}، حجز #{@carrier_name_ar} المتحد، رحلات #{@carrier_name_ar}، تذاكر #{@carrier_name_ar}، #{@carrier_name_ar}، تذاكر طيران على #{@carrier_name_ar}، أسعار تذاكر طيران #{@carrier_name_ar}، تقويم رحلات #{@carrier_name_ar}،"
        else
          meta_title = "#{@carrier_name} Web Check-In,  #{@carrier_name} Online Check in - Cleartrip"
          meta_description = "Quickly use #{@carrier_name} web check-in facility and print your boarding pass from home/office and proceed directly to the security check at the airport."
          meta_keywords = "#{@carrier_name} web checkin, #{@carrier_name} Online Check in, #{@carrier_name}  flights, #{@carrier_name} booking, United #{@carrier_name} booking, #{@carrier_name} flights, #{@carrier_name}  tickets, #{@carrier_name} , #{@carrier_name} air tickets, #{@carrier_name} air fares, #{@carrier_name} flight schedule"
        end
        amp_url = ""
      when "airline_routes"
        title = (@title_min_price.present? && @title_min_price!=0) ? "title_with_price" : "title_without_price"
        if @language == "ar"
          meta_title = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section[3..5]}"]["#{title}"] %{dep_city_name: @dep_city_name_ar,arr_city_name: @arr_city_name_ar,airline_name: @carrier_name_ar,least_rate: @title_min_price} rescue ""
          meta_description = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section[3..5]}"]["description"] %{dep_city_name: @dep_city_name_ar,arr_city_name: @arr_city_name_ar,airline_name: @carrier_name_ar} rescue ""
          meta_keywords = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section[3..5]}"]["keywords"]  %{dep_city_name: @dep_city_name_ar,arr_city_name: @arr_city_name_ar,airline_name: @carrier_name_ar} rescue ""
          amp_url = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["amp_url"]
        else
          meta_title = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section[3..5]}"]["#{title}"] %{dep_city_name: @dep_city_name,arr_city_name: @arr_city_name,airline_name: @carrier_name,least_rate: @title_min_price} rescue ""
          meta_description = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section[3..5]}"]["description"] %{dep_city_name: @dep_city_name,arr_city_name: @arr_city_name,airline_name: @carrier_name} rescue ""
          meta_keywords = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section[3..5]}"]["keywords"]  %{dep_city_name: @dep_city_name,arr_city_name: @arr_city_name_,airline_name: @carrier_name} rescue ""
          amp_url = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["amp_url"] %{file_name: @file_name}
        end
      when "booking_index"
      if @language == "ar"
        I18n.locale = :ar
        meta_title = I18n.t("booking_index.#{@section}_title",country: @country_name) rescue ""
        meta_description = I18n.t("booking_index.#{@section}_description",airlines_count: @airlines_count,airlines: @airlines) rescue ""
        meta_keywords = I18n.t("booking_index.#{@section}_keywords",country: @country_name)  rescue ""
        amp_url = ""
      else
        meta_title = I18n.t("booking_index.#{@section}_title",country: @country_name) rescue ""
        meta_description = I18n.t("booking_index.#{@section}_description",airlines_count: @airlines_count,airlines: @airlines) rescue ""
        meta_keywords = I18n.t("booking_index.#{@section}_keywords",country: @country_name) rescue ""
        amp_url  = ""
      end
      when "flight-tickets"
        title = (@title_min_price.present? && @title_min_price!=0) ? "title_with_price" : "title_without_price"
        if @language == "ar"
          meta_title = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section[3..5]}"]["#{title}"] %{dep_city_name: @dep_city_name_ar,arr_city_name: @arr_city_name_ar,dep_city_code: @route.dep_city_code,arr_city_code: @route.arr_city_code} rescue ""
          meta_description = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section[3..5]}"]["description"] %{dep_city_name: @dep_city_name_ar,arr_city_name: @arr_city_name_ar} rescue ""
          meta_keywords = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section[3..5]}"]["keywords"]  %{dep_city_name: @dep_city_name_ar,arr_city_name: @arr_city_name_ar} rescue ""
          amp_url = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["amp_url"] %{file_name: @file_name}
        else
          meta_title = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section[3..5]}"]["#{title}"] %{dep_city_name: @dep_city_name,arr_city_name: @arr_city_name,dep_city_code: @route.dep_city_code,arr_city_code: @route.arr_city_code,min_pirce: @title_min_price} rescue ""
          meta_description = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section[3..5]}"]["description"] %{dep_city_name: @dep_city_name,arr_city_name: @arr_city_name} rescue ""
          meta_keywords = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section[3..5]}"]["keywords"] %{dep_city_name: @dep_city_name,arr_city_name: @arr_city_name} rescue ""
          amp_url = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["amp_url"] %{file_name: @file_name}
        end
      when "schedule_index"
        if @language == "ar"
          meta_title = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section}"]["title"] rescue ""
          meta_description = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section}"]["description"] rescue ""
          meta_keywords = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section}"]["keywords"]  rescue ""
        else
          meta_title = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section}"]["title"] rescue ""
          meta_description = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section}"]["description"] rescue ""
          meta_keywords = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section}"]["keywords"] rescue ""
        end
      when "ticket_index"
        if @language == "ar"
          meta_title = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section}"]["title"] rescue ""
          meta_description = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section}"]["description"] rescue ""
          meta_keywords = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section}"]["keywords"]  rescue ""
        else
          meta_title = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section}"]["title"] rescue ""
          meta_description = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section}"]["description"] rescue ""
          meta_keywords = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section}"]["keywords"] rescue ""
        end
      end
        {:title =>meta_title,:keywords=>meta_keywords,:description=>meta_description,amp_url: amp_url}
    end

  def og_tags
     if  (@meta_page_type=="airline_routes" || @meta_page_type=="from" || @meta_page_type == "to" ) 
      lang_countries = ["en-IN","ar-AE","en-AE","ar-BH","en-BH","ar-KW","en-KW","ar-OM","en-OM"]
     else 
      lang_countries = ["en-IN","ar-AE","en-AE","ar-SA","en-SA","ar-BH","en-BH","ar-KW","en-KW","ar-OM","en-OM","ar-QA","en-QA"]
     end
    main_content = "#{@language.downcase}-#{@country_code}"
    alts = []
    lang_countries.each do |l|
      unless main_content === l
        alts << l
      end
    end
      {main_content: main_content, alts: alts}
  end

  def get_google_verification_code(country_code)
    google_site_verification_codes = ["sa" => "gCx6_gimha6TLW708CmIcEmmaQcXdW8V-91K4SggqNs","ae" => "W3BVt2i_Z_vsMckoK6HlhvCEXsPIRze2c5IkbCwQnyo","in"=>"ZpTI71xKZu31T17eN0r66mskYFtkUK4q2SFUx23o24Q"]
    verification_code = google_site_verification_codes.map{|c| c[country_code.downcase]}.first
  end

  def domain_section_banner(country_code)
      section = @section.include?("dom")
      case country_code
      when "IN"
        if  section
          src="https://s3-ap-southeast-1.amazonaws.com/waytogo-banners/flights/in/flight-schedule/en/domestic/amp/SEO-PAYLESS.png"
        else
          src = "https://s3-ap-southeast-1.amazonaws.com/waytogo-banners/flights/in/flight-schedule/en/international/amp/SEO-INTLTRAVEL.png"
        end
      when "AE"
        if  section
          src= ""
        else
          src= ""
          src="https://s3-ap-southeast-1.amazonaws.com/waytogo-banners/flights/ae/flight-schedule/en/international/amp/AE-amp-int.jpg"
        end
      when "SA"
        if  section
          src="https://s3-ap-southeast-1.amazonaws.com/waytogo-banners/flights/sa/flight-schedule/en/domestic/amp/sa_dom_amp_banner.png"
        else
          src="https://s3-ap-southeast-1.amazonaws.com/waytogo-banners/flights/sa/flight-schedule/en/international/amp/intl_code_flights.jpg"
        end
      end
      return src
    end

  def custom_pagination(page_no,routes,file_name)
    prev_no = next_no = 0
    routes_count = routes.count
    pagination_routes_count = routes_count-44
    total_pages,remaing_routes_count = pagination_routes_count.divmod(45)
    file_name = file_name.gsub(/-\d/,'').gsub(/\d/,'').gsub(".html",'')
    if remaing_routes_count > 0
      total_pages += 1
    end
    start_index = 46*page_no
    end_index = start_index + 44
    if page_no == 0
      next_no = page_no + 1
      prev_url = "#{file_name}.html"
      next_url = "#{file_name}-#{next_no}.html"
      routes = routes[start_index..end_index]
    elsif page_no == 1
      next_no = page_no + 1
      prev_url = "#{file_name}.html"
      next_url = "#{file_name}-#{next_no}.html"
      routes = routes[start_index..end_index]
    else
      prev_no = page_no - 1
      next_no = page_no + 1
      prev_url = "#{file_name}-#{prev_no}.html"
      next_url  = "#{file_name}-#{next_no}.html"
      routes = routes[start_index..end_index]
    end
    return {routes: routes,current_page_no: page_no,prev_url: prev_url,next_url: next_url,prev_no: prev_no,next_no: next_no,total_pages: total_pages}
  end

  def get_domain
    protocol = request.protocol
    unless protocol.include? "s"
        protocol = "https://"
    end
    hostname = request.host
    "#{protocol}#{hostname}"
  end

    # def to_time(timeObj)
    #   begin
    #     timeObj.strftime("%H:%M %p")
    #   rescue
    #     ""
    #   end
    # end

  def check_domain(language,country_code)
    country_codes = ["AE","SA","BH","QA","KW","OM"]
    if language=="ar" && country_code=="IN"
      return true
    elsif language=="hi" && country_codes.include?(country_code)
      if country_code=="AE" || country_code=="SA"
        return true
      else
        return true
      end
    else
      return false
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

  def format_overview_link(carrier_name, locale = nil)
  	unless carrier_name.blank?
     if(carrier_name.downcase.include?('airlines') || carrier_name.downcase.include?('airline')|| carrier_name.downcase.include?('air lines'))
       result = carrier_name.downcase
       result = result.gsub("airlines","")
       result = result.gsub("airline","")
       result = result.gsub("air lines","")
       result = result.strip.downcase.gsub(" ", "-")
       result = result+"-airlines"
     else
       result = carrier_name.downcase.gsub(" ","-")+ "-airlines"
     end
   end
 end

 def format_baggage_link(carrier_name)
  unless carrier_name.blank?
    if(carrier_name.downcase.include?('airlines') || carrier_name.downcase.include?('airline')|| carrier_name.downcase.include?('air lines'))
      result = carrier_name.downcase
      result = result.gsub("airlines","")
      result = result.gsub("airline","")
      result = result.gsub("air lines","")
      result = result.strip.downcase.gsub(" ", "-")
      result = result+"-baggages"
    else
      result = carrier_name.downcase.gsub(" ","-")+ "-baggages"
    end
  end
end

  def search_widget_popular_routes_ar
    popular_cities =  {
                      "sa" =>  [
                          {city_code: "AUH",city_name: "الدولي",airport_name: "AE - مطار أبو ظبي الدولي"},
                          {city_code: "BAH",city_name: "البحرين الدولي",airport_name: "BH - مطار البحرين الدولي"},
                          {city_code: "DMM",city_name: "الدمام",airport_name: "SA - مطار الملك فهد الدولي "},
                          {city_code: "DOH",city_name: "الدوحة",airport_name: "QA - مطار الدوحة الدولي"},
                          {city_code: "DXB",city_name: "دبى",airport_name: "AE - مطار دبي الدولي "},
                          {city_code: "JED",city_name: "جدة",airport_name: "SA - مطار الملك عبد العزيز الدولي"},
                          {city_code: "KWI",city_name: "الكويت",airport_name: "KW - مطار الكويت الدولي"},
                          {city_code: "MCT",city_name: "مسقط",airport_name: "OM - مطار سيب الدولي"},
                          {city_code: "MED",city_name: "المدينة",airport_name: "SA - الأمير محمد بن عبدالعزيز"},
                          {city_code: "RUH",city_name: "الرياض",airport_name: "SA - مطار الملك خالد الدولي "},
                          {city_code: "SHJ",city_name: "الشارقة",airport_name: "AE - مطار الشارقة"}
                      ],
                      "ae" => [
                          {city_code: "AUH",city_name: "الدولي",airport_name: "AE - مطار أبو ظبي الدولي"},
                          {city_code: "BAH",city_name: "البحرين الدولي",airport_name: "BH - مطار البحرين الدولي"},
                          {city_code: "DMM",city_name: "الدمام",airport_name: "SA - مطار الملك فهد الدولي "},
                          {city_code: "DOH",city_name: "الدوحة",airport_name: "QA - مطار الدوحة الدولي"},
                          {city_code: "DXB",city_name: "دبى",airport_name: "AE - مطار دبي الدولي "},
                          {city_code: "JED",city_name: "جدة",airport_name: "SA - مطار الملك عبد العزيز الدولي"},
                          {city_code: "KWI",city_name: "الكويت",airport_name: "KW - مطار الكويت الدولي"},
                          {city_code: "MCT",city_name: "مسقط",airport_name: "OM - مطار سيب الدولي"},
                          {city_code: "MED",city_name: "المدينة",airport_name: "SA - الأمير محمد بن عبدالعزيز"},
                          {city_code: "RUH",city_name: "الرياض",airport_name: "SA - مطار الملك خالد الدولي "},
                          {city_code: "SHJ",city_name: "الشارقة",airport_name: "AE - مطار الشارقة"}
                      ],
                    "bh" => [
                       {city_code: "AUH",city_name: "الدولي",airport_name: "AE - مطار أبو ظبي الدولي"},
                          {city_code: "BAH",city_name: "البحرين الدولي",airport_name: "BH - مطار البحرين الدولي"},
                          {city_code: "DMM",city_name: "الدمام",airport_name: "SA - مطار الملك فهد الدولي "},
                          {city_code: "DOH",city_name: "الدوحة",airport_name: "QA - مطار الدوحة الدولي"},
                          {city_code: "DXB",city_name: "دبى",airport_name: "AE - مطار دبي الدولي "},
                          {city_code: "JED",city_name: "جدة",airport_name: "SA - مطار الملك عبد العزيز الدولي"},
                          {city_code: "KWI",city_name: "الكويت",airport_name: "KW - مطار الكويت الدولي"},
                          {city_code: "MCT",city_name: "مسقط",airport_name: "OM - مطار سيب الدولي"},
                          {city_code: "MED",city_name: "المدينة",airport_name: "SA - الأمير محمد بن عبدالعزيز"},
                          {city_code: "RUH",city_name: "الرياض",airport_name: "SA - مطار الملك خالد الدولي "},
                          {city_code: "SHJ",city_name: "الشارقة",airport_name: "AE - مطار الشارقة"}
                    ],
                    "qa" => [
                          {city_code: "AUH",city_name: "الدولي",airport_name: "AE - مطار أبو ظبي الدولي"},
                          {city_code: "BAH",city_name: "البحرين الدولي",airport_name: "BH - مطار البحرين الدولي"},
                          {city_code: "DMM",city_name: "الدمام",airport_name: "SA - مطار الملك فهد الدولي "},
                          {city_code: "DOH",city_name: "الدوحة",airport_name: "QA - مطار الدوحة الدولي"},
                          {city_code: "DXB",city_name: "دبى",airport_name: "AE - مطار دبي الدولي "},
                          {city_code: "JED",city_name: "جدة",airport_name: "SA - مطار الملك عبد العزيز الدولي"},
                          {city_code: "KWI",city_name: "الكويت",airport_name: "KW - مطار الكويت الدولي"},
                          {city_code: "MCT",city_name: "مسقط",airport_name: "OM - مطار سيب الدولي"},
                          {city_code: "MED",city_name: "المدينة",airport_name: "SA - الأمير محمد بن عبدالعزيز"},
                          {city_code: "RUH",city_name: "الرياض",airport_name: "SA - مطار الملك خالد الدولي "},
                          {city_code: "SHJ",city_name: "الشارقة",airport_name: "AE - مطار الشارقة"}
                    ],
                     "om" => [
                          {city_code: "AUH",city_name: "الدولي",airport_name: "AE - مطار أبو ظبي الدولي"},
                          {city_code: "BAH",city_name: "البحرين الدولي",airport_name: "BH - مطار البحرين الدولي"},
                          {city_code: "DMM",city_name: "الدمام",airport_name: "SA - مطار الملك فهد الدولي "},
                          {city_code: "DOH",city_name: "الدوحة",airport_name: "QA - مطار الدوحة الدولي"},
                          {city_code: "DXB",city_name: "دبى",airport_name: "AE - مطار دبي الدولي "},
                          {city_code: "JED",city_name: "جدة",airport_name: "SA - مطار الملك عبد العزيز الدولي"},
                          {city_code: "KWI",city_name: "الكويت",airport_name: "KW - مطار الكويت الدولي"},
                          {city_code: "MCT",city_name: "مسقط",airport_name: "OM - مطار سيب الدولي"},
                          {city_code: "MED",city_name: "المدينة",airport_name: "SA - الأمير محمد بن عبدالعزيز"},
                          {city_code: "RUH",city_name: "الرياض",airport_name: "SA - مطار الملك خالد الدولي "},
                          {city_code: "SHJ",city_name: "الشارقة",airport_name: "AE - مطار الشارقة"}
                     ],
                     "kw" => [
                          {city_code: "AUH",city_name: "الدولي",airport_name: "AE - مطار أبو ظبي الدولي"},
                          {city_code: "BAH",city_name: "البحرين الدولي",airport_name: "BH - مطار البحرين الدولي"},
                          {city_code: "DMM",city_name: "الدمام",airport_name: "SA - مطار الملك فهد الدولي "},
                          {city_code: "DOH",city_name: "الدوحة",airport_name: "QA - مطار الدوحة الدولي"},
                          {city_code: "DXB",city_name: "دبى",airport_name: "AE - مطار دبي الدولي "},
                          {city_code: "JED",city_name: "جدة",airport_name: "SA - مطار الملك عبد العزيز الدولي"},
                          {city_code: "KWI",city_name: "الكويت",airport_name: "KW - مطار الكويت الدولي"},
                          {city_code: "MCT",city_name: "مسقط",airport_name: "OM - مطار سيب الدولي"},
                          {city_code: "MED",city_name: "المدينة",airport_name: "SA - الأمير محمد بن عبدالعزيز"},
                          {city_code: "RUH",city_name: "الرياض",airport_name: "SA - مطار الملك خالد الدولي "},
                          {city_code: "SHJ",city_name: "الشارقة",airport_name: "AE - مطار الشارقة"}
                     ]

                  }
    return popular_cities["#{@country_code.downcase}"]
  end
  def search_widget_popular_routes
    popular_cities =  {
                      "in" => [{city_code: "BLR ",city_name:  "Bangalore", airport_name:  "IN - Kempegowda International Airport"},
                        {city_code: "BOM",city_name:  "Mumbai",airport_name:  "IN - Chatrapati Shivaji Airport"},
                        {city_code: "CCU" , city_name:  "Kolkata" , airport_name: "IN - Netaji Subhas Chandra Bose Airport"} ,
                        {city_code: "DEL" , city_name: "New Delhi"  , airport_name:  "IN - Indira Gandhi Airport"},
                        {city_code: "DXB" , city_name: "Dubai"  , airport_name: "AE - Dubai International Airport"},
                        {city_code: "GOI" , city_name:  "Goa" , airport_name: "IN - Dabolim Airport"},
                        {city_code: "HYD" , city_name:  "Hyderabad" , airport_name: "IN - Rajiv Gandhi International"},
                        {city_code: "KTM" , city_name:  "Kathmandu" , airport_name: "NP - Tribuvan"} ,
                        {city_code: "MAA" , city_name: "Chennai"  , airport_name: "IN - Chennai Airport"},
                        {city_code: "SFO" , city_name:  "San Francisco" , airport_name: "US - San Francisco"}
                        ],
                      "sa" =>  [
                        {city_code: 'AUH',city_name: "Abu Dhabi",airport_name: "AE - Abu Dhabi International Airport"},
                        {city_code: "BAH" ,city_name: "Bahrain",airport_name: "BH - Bahrain"},
                        {city_code: "DMM" ,city_name: "Dammam",airport_name: "SA - King Fahad"},
                        {city_code: "DOH" ,city_name: "Doha",airport_name: "QA - Doha"},
                        {city_code: "DXB" ,city_name: "Dubai",airport_name: "AE - Dubai International Airport"},
                        {city_code: "JED" ,city_name: "Jeddah",airport_name: "SA - Jeddah"},
                        {city_code: "KWI" ,city_name: "Kuwait",airport_name: "KW - Kuwait"},
                        {city_code: "MCT" ,city_name: "Muscat",airport_name: "OM - Seeb"},
                        {city_code: "RUH" ,city_name: "Riyadh",airport_name: "SA - King Khaled"},
                        {city_code: "SHJ" ,city_name: "Sharjah" , airport_name: "AE - Sharjah]"}
                      ],
                      "ae" =>   [
                        {city_code: 'AUH',city_name: "Abu Dhabi",airport_name: "AE - Abu Dhabi International Airport"},
                        {city_code: "BAH" ,city_name: "Bahrain",airport_name: "BH - Bahrain"},
                        {city_code: "DMM" ,city_name: "Dammam",airport_name: "SA - King Fahad"},
                        {city_code: "DOH" ,city_name: "Doha",airport_name: "QA - Doha"},
                        {city_code: "DXB" ,city_name: "Dubai",airport_name: "AE - Dubai International Airport"},
                        {city_code: "JED" ,city_name: "Jeddah",airport_name: "SA - Jeddah"},
                        {city_code: "KWI" ,city_name: "Kuwait",airport_name: "KW - Kuwait"},
                        {city_code: "MCT" ,city_name: "Muscat",airport_name: "OM - Seeb"},
                        {city_code: "RUH" ,city_name: "Riyadh",airport_name: "SA - King Khaled"},
                        {city_code: "SHJ" ,city_name: "Sharjah" , airport_name: "AE - Sharjah]"}
                      ],
                    "bh" => [
                      {city_code: "AUH" , city_name: "Abu Dhabi" , airport_name: "AE - Abu Dhabi International Airport " },
                      {city_code: "BAH"  , city_name: "Bahrain" ,  airport_name: "BH - Bahrain" } , 
                      {city_code: "DMM" , city_name: "Dammam" ,  airport_name: "SA - King Fahad"} , 
                      {city_code: "DOH" , city_name: "Doha" ,  airport_name: "QA - Doha" } , 
                      {city_code: "DXB" , city_name: "Dubai" ,  airport_name: "AE - Dubai International Airport"} , 
                      {city_code: "JED" , city_name: "Jeddah" ,  airport_name: "SA - Jeddah" } , 
                      {city_code: "KWI"  , city_name: "Kuwait" ,  airport_name: "KW - Kuwait"} , 
                      {city_code: "MCT" , city_name:  "Muscat" ,  airport_name: "OM - Seeb"} , 
                      {city_code: "RUH" , city_name: "Riyadh" ,  airport_name: "SA - King Khaled" } , 
                      {city_code: "SHJ"  , city_name:  "Sharjah" ,  airport_name: "AE - Sharjah" }
                    ],
                    "qa" =>   [
                        {city_code: 'AUH',city_name: "Abu Dhabi",airport_name: "AE - Abu Dhabi International Airport"},
                        {city_code: "BAH" ,city_name: "Bahrain",airport_name: "BH - Bahrain"},
                        {city_code: "DMM" ,city_name: "Dammam",airport_name: "SA - King Fahad"},
                        {city_code: "DOH" ,city_name: "Doha",airport_name: "QA - Doha"},
                        {city_code: "DXB" ,city_name: "Dubai",airport_name: "AE - Dubai International Airport"},
                        {city_code: "JED" ,city_name: "Jeddah",airport_name: "SA - Jeddah"},
                        {city_code: "KWI" ,city_name: "Kuwait",airport_name: "KW - Kuwait"},
                        {city_code: "MCT" ,city_name: "Muscat",airport_name: "OM - Seeb"},
                        {city_code: "RUH" ,city_name: "Riyadh",airport_name: "SA - King Khaled"},
                        {city_code: "SHJ" ,city_name: "Sharjah" , airport_name: "AE - Sharjah]"}
                      ],
                     "om" =>   [
                        {city_code: 'AUH',city_name: "Abu Dhabi",airport_name: "AE - Abu Dhabi International Airport"},
                        {city_code: "BAH" ,city_name: "Bahrain",airport_name: "BH - Bahrain"},
                        {city_code: "DMM" ,city_name: "Dammam",airport_name: "SA - King Fahad"},
                        {city_code: "DOH" ,city_name: "Doha",airport_name: "QA - Doha"},
                        {city_code: "DXB" ,city_name: "Dubai",airport_name: "AE - Dubai International Airport"},
                        {city_code: "JED" ,city_name: "Jeddah",airport_name: "SA - Jeddah"},
                        {city_code: "KWI" ,city_name: "Kuwait",airport_name: "KW - Kuwait"},
                        {city_code: "MCT" ,city_name: "Muscat",airport_name: "OM - Seeb"},
                        {city_code: "RUH" ,city_name: "Riyadh",airport_name: "SA - King Khaled"},
                        {city_code: "SHJ" ,city_name: "Sharjah" , airport_name: "AE - Sharjah]"}
                      ],
                     "kw" =>   [
                        {city_code: 'AUH',city_name: "Abu Dhabi",airport_name: "AE - Abu Dhabi International Airport"},
                        {city_code: "BAH" ,city_name: "Bahrain",airport_name: "BH - Bahrain"},
                        {city_code: "DMM" ,city_name: "Dammam",airport_name: "SA - King Fahad"},
                        {city_code: "DOH" ,city_name: "Doha",airport_name: "QA - Doha"},
                        {city_code: "DXB" ,city_name: "Dubai",airport_name: "AE - Dubai International Airport"},
                        {city_code: "JED" ,city_name: "Jeddah",airport_name: "SA - Jeddah"},
                        {city_code: "KWI" ,city_name: "Kuwait",airport_name: "KW - Kuwait"},
                        {city_code: "MCT" ,city_name: "Muscat",airport_name: "OM - Seeb"},
                        {city_code: "RUH" ,city_name: "Riyadh",airport_name: "SA - King Khaled"},
                        {city_code: "SHJ" ,city_name: "Sharjah" , airport_name: "AE - Sharjah]"}
                      ]

                  }
    return popular_cities["#{@country_code.downcase}"]
  end
  # def translate_airport(code)
  #   begin
  #     unless code.blank?
  #       I18n.with_locale(:en) { t("airlines.PPgdf") }
  #     end
  #   rescue => error
  #     puts error
  #     return ''
  #   end
  # end

  def format_airline_name(carrier_name, locale = nil)
    unless carrier_name.blank?
      result = carrier_name
      if(carrier_name.include?('Airlines') || carrier_name.include?('Airline')|| carrier_name.include?('Air line') || carrier_name.include?('Air Lines') || carrier_name.include?('airline'))
        result = result.gsub("Airlines","")
        result = result.gsub("Airline","")
        result = result.gsub("Air lines","")
        result = result.gsub("Air Lines","")
        result = result.gsub("airline", "")

        if locale == :hi
          result = result+" एयरलाइंस "
        elsif locale == :ar
          result = result+" الخطوط الجوية "
        else
          result = result +" Airlines"
        end

      else
        result = carrier_name + " Airlines"
      end
      if locale == :hi
        if(result.include?('एयरलाइंस') || result.include?('एयरलाइन')|| result.include?('एयर लाइन') || result.include?('एयर लाइन्स')) || result.include?('Airlines')
          result = result.gsub("एयरलाइंस","")
          result = result.gsub("एयरलाइन","")
          result = result.gsub("एयर लाइन","")
          result = result.gsub("एयर लाइन्स","")
          result = result.gsub("Airlines","")
          result = result+" एयरलाइंस "
        else
          result = result + " एयरलाइंस "
        end
      end
      if locale == :ar
        if(result.include?('الخطوط الجوية') || result.include?('الطيران')|| result.include?('خط جوي') || result.include?('الخطوط الجوية')) || result.include?('Airlines')

          result = result.gsub("الخطوط الجوية","")
          result = result.gsub("الخط الجوي","")
          result = result.gsub("خط جوي","")
          result = result.gsub("الخطوط الجوية","")
          result = result.gsub("Airlines","")
          result = result + " الخطوط الجوية "
        else
          result = result + " الخطوط الجوية "
        end
      end
    end
    return result

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


  def display_host(country_code)
    # puts "country_code - #{country_code}"
    if country_code == 'AE'
      return 'Cleartrip.ae'
    elsif country_code == 'KW'
      return 'kw.cleartrip.com'
    elsif country_code == 'SA'
      return 'Cleartrip.sa'
    elsif country_code == 'BH'
      return 'bh.cleartrip.com'
    elsif country_code == 'QA'
      return 'qa.cleartrip.com'
    elsif country_code == 'OM'
      return 'om.cleartrip.com'
    elsif country_code == 'IN'
      return 'Cleartrip.com'
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

  def booking_index_host_country_code(host)
    # host = host || ""
    # puts "country_code - #{country_code}"
    if host == 'AE'
      return "United Arab Emirates"
    elsif host == 'KW'
      return "Kuwait"
    elsif host == 'SA'
      return "Saudi Arabia"
    elsif host == 'BH'
      return "Bahrain"
    elsif host == 'QA'
      return "Qatar"
    elsif host == 'OM'
      return "Oman"
    elsif host == 'SA'
      return "Saudi Arabia"
    else
      return "India"
    end
  end

  def retrieve_days(days)
     if !days.nil?
       if days.delete(" ").length == 7
         return I18n.t("daily")
       else
        day_names = I18n.t('date.abbr_day_names')
        days = days.delete(" ")
        str = ""
        i = 1
        days.each_char  do |day|
          if (i == 1)
            if ((day.to_i) == 7)
              str  = (day_names[0])
            else
              str  = (day_names[(day.to_i)])
            end
          else
            if ((day.to_i) == 7)
              str  = str + ", " + (day_names[0])
            else
              str  = str + ", " + (day_names[(day.to_i)])
            end
          end
          i = i  + 1
        end
        return str
      end
    end
  end
end
