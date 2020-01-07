class UrlHealthChecker
  def initialize(url,page_type,page)
    @url = url
    @page_type = page_type
    @page = page
  end

  def get_flights_result
    flights_result
  end

  def is_title?
    title =  @page.at_css("title").text rescue ""
     return {title: title.present?,title_content: title}
  end

  def is_description?
    description = @page.at("meta[name='description']")['content'] rescue ""
    return {description: description.present?,description_content: description}
  end

  def is_keywords?
    keywords =   @page.at("meta[name='keywords']")['content'] rescue ""
    return keywords.present?
  end

  def is_hreflangs?
    hreflangs = @page.search("link[rel='alternate']").map{|m| m['hreflang']} rescue []
    link_alternatives = {}
    unless hreflangs.empty?
      hreflangs.each do |hl|
        link_alternatives["#{hl}"] = @page.at_css("link[hreflang='#{hl}']").values[2]
      end
    end
    return link_alternatives.values.any?
  end

  def is_x_default?
    x_default = @page.at("link[hreflang='x-default']")['href'] rescue ""
    return x_default.present?
  end

  def is_canonical?
    canonical = @page.at("link[rel='canonical']")['href'] rescue ""
    return canonical.present?
  end

  def is_h1_tag?
    if @page_type == "overview" || @page_type == "schedule_route"
      h1_tag = @page.css("h1.main-title").text rescue ""
    elsif @page_type == "pnr_status" || @page_type == "web_checkin"
      h1_tag = @page.css('div.airline-brand-cnt h1').text rescue ""
    elsif @page_type == "flight_tickets"
      h1_tag = @page.css('h1').text rescue ""
    else
      h1_tag = @page.css('h1').text rescue ""
    end
    return h1_tag.present?
  end

  def is_calendar?
    calendar = @page.css('div.calendar-new').text rescue ""
    return calendar.present?
  end

   
  def is_content?
    if @page_type == "overview" 
      content = @page.css('div.unique-content').text rescue ""
    elsif @page_type == "pnr_status" || @page_type == "web_checkin"
      content = @page.css('div.content-desc')
      content = content.present? ? content : @page.css('div.airline-cnt').text rescue ""
    elsif @page_type== "schedule_route"
      content = @page.css("div.unique-content").text rescue ""
    elsif @page_type == "airports"
      content = @page.css('div.airport-information').text rescue ""
      content = content.present? ? content : @page.css('div.cnt-odd').text rescue ""
    else
      content = @page.css('div.content-desc').text rescue ""
      content = content.present? ? content : @page.css('div.airline-cnt').text rescue ""
    end

    return (content.present? && content != "")
  end

  def is_schema?
    li_schema = @page.search("li[itemtype]").map{|m| m.text}.any? rescue false
    div_schema = @page.search("div[itemtype]").map{|m| m.text}.any? rescue false
    ul_schema = @page.search("ul[itemtype]").map{|m| m.text}.any? rescue false
    return (li_schema || div_schema || ul_schema)
  end

  def is_ga_code?
    ga_codes = {"IN"=>"UA-8292447-1","AE"=>"UA-16109308-1","SA"=>"UA-16109308-8","BH"=>"UA-16109308-3","QA"=>"UA-16109308-4","OM"=>"UA-16109308-2","KW"=>"UA-16109308-5"}
    host = "https://" + URI.parse(@url).host
    application_processor = ApplicationProcessor.new
    country_code = application_processor.host_country_code(host)[0]
    ga_code = ga_codes["#{country_code}"]
    return @page.search('script').text.include?("#{ga_code}")
  end

  def is_hotel_content?
    city_hotel_content_1 = @page.css('div.topContent').text rescue ""
    city_hotel_content_2 = @page.css('div.intl_city_content').text rescue ""
    city_hotel_content = city_hotel_content_1.present? || city_hotel_content_2.present?
    info_page_content = @page.css('div.hotel-description').text rescue ""
    weekend_getaway_content = @page.css('div.top-content').text  rescue ""
    weekend_getaway_content = (weekend_getaway_content.present? && weekend_getaway_content != "") ? weekend_getaway_content : @page.css('div.weekend-about').text 
    other_hotel_types_content_arr = @page.css("div.topContent").map{|m| m.text}
    other_hotel_types_content = ""
    if other_hotel_types_content_arr.any?
      other_hotel_types_content  =  other_hotel_types_content_arr.first rescue ""
    else
      other_hotel_types_content = @page.css("div.city_content").text rescue ""
      other_hotel_types_content = (other_hotel_types_content.present? && other_hotel_types_content != "") ? other_hotel_types_content : @page.css("div.intl_city_content").text
    end
    return (city_hotel_content || info_page_content.present?) || (weekend_getaway_content.present? || other_hotel_types_content.present?)
  end

  def is_trains_h1_tag?
    train_routes_or_list_h1_tag = @page.css('div.detail h1').text rescue ""
    trains_stations_list_h1_tag = @page.css('div.trains-contents h1.main-title').text rescue ""
    h1_tag = @page.css('h1').text rescue ""
    return (h1_tag.present? || trains_stations_list_h1_tag || h1_tag)
  end
  def is_trains_content?
    train_routes_or_list_content = @page.css('div.trains-contents').text rescue ""
    tourism_routes_content = @page.css('div.contdes').text rescue ""
    city_tourism_content = @page.css('div.detail p').map{|m| m.text}.any?
    trains_dynamic_content = @page.css('div.train-dynamic-content').text rescue ""
    train_city_station = @page.css('div.trainDetails p').map{|m| m.text}.any?
    trains_stations_list_content = @page.css('div.trains-contents p').map{|m| m.text}.any?
    return ((train_routes_or_list_content.present? || tourism_routes_content.present?) || (city_tourism_content || trains_dynamic_content.present?) || (train_city_station || trains_stations_list_content))
  end
  def is_locals_h1_tag?
    h1_tag1 = @page.css('h1.header-row__title').text rescue ""
    h1_tag2 = @page.css('h1').text rescue ""
    return h1_tag1.present? || h1_tag2.present?
  end

  def is_locals_content?
    locals_content = @page.css('div.details-row__content p').text rescue ""
    return locals_content.present?
  end
  def is_locals_hreflangs?
    hreflangs = @page.search("link[rel='alternate']").map{|m| m['hreflang']} rescue ""
    link_alternatives = {}
    hreflangs.each do |hl|
      link_alternatives["#{hl}"] = @page.at_css("link[hreflang='#{hl}']").values[2] rescue ''
    end
    return link_alternatives.values.any?
  end
  def flights_result
    return { title: is_title?, description: is_description?, keywords: is_keywords?,href_langs:  is_hreflangs?, x_default: is_x_default?, canonical: is_canonical?, h1_tag: is_h1_tag?, calendar: is_calendar?,content: is_content?,schema: is_schema?,ga_code: is_ga_code? }
  end

  def hotels_result
    return { title: is_title?, description: is_description?, keywords: is_keywords?,href_langs:  is_hreflangs?, x_default: is_x_default?, canonical: is_canonical?, h1_tag: is_h1_tag?, calendar: is_calendar?,content: is_hotel_content?,schema: is_schema?, ga_code: is_ga_code? }
  end

  def locals_result
    return { title: is_title?, description: is_description?, keywords: is_keywords?,href_langs:  is_locals_hreflangs?, x_default: is_x_default?, canonical: is_canonical?, h1_tag: is_locals_h1_tag?, calendar: is_calendar?,content: is_locals_content?,schema: is_schema?, ga_code: is_ga_code? }
  end

  def trains_result
    return { title: is_title?, description: is_description?, keywords: is_keywords?,href_langs:  is_hreflangs?, x_default: is_x_default?, canonical: is_canonical?, h1_tag: is_trains_h1_tag?, calendar: is_calendar?,content: is_trains_content?,schema: is_schema?,ga_code: is_ga_code? }
  end


end