var _gaq = _gaq || [];
$(document).ready(function(){
	var isMobile = {
		Android: function() {
			return navigator.userAgent.match(/Android/i)
		},
		BlackBerry: function() {
			return navigator.userAgent.match(/BlackBerry/i)
		},
		iOS: function() {
			return navigator.userAgent.match(/iPhone|iPad|iPod/i)
		},
		Opera: function() {
			return navigator.userAgent.match(/Opera Mini/i)
		},
		Windows: function() {
			return navigator.userAgent.match(/IEMobile/i)
		},
		any: function() {
			return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows())
		}
	};
	var url =""
	var href_url = ""
	var two_days = Date.now() + (24 * 2 * 60 * 60 * 1000);
	var two_days = (new Date(two_days).format("dd/mm/yyyy"))
	var diff_days = Date.now() + (24 * 4 * 60 * 60 * 1000);
	var diff_days = (new Date(diff_days).format("dd/mm/yyyy"))
	var device_type = isMobile.any() ? 'mobile' : 'desktop'
	if(page_type  =='flight-booking'){
		if(page_sub_type =="routes"){
			href_url = "https://"+location.host
			href_url = isMobile.any() ? href_url+"/m" : href_url+""
			href_url = section_type == "international" ? href_url+"/flights/international/results?" : href_url+"/flights/results?"
			href_url += "from="+dep_city_code+"&to="+arr_city_code+"&depart_date="+two_days+"&adults=1&childs=0&infants=0&page=loaded&class=Economy&airline="+carrier_code+""
			href_url += isMobile.any() ? "&mobile=true#firstTen" : ""
			let section_offer_txt = section_type == "international" ? "International_Flat_Offer" : "Domestic_Flat_Offer"
			href_url += "&utm_source=Booking_Routes&utm_medium=Center_Banner&utm_campaign="+section_offer_txt
			url  = "https://s3-ap-southeast-1.amazonaws.com/waytogo-banners/flights/"+country_code+"/"+page_type+"/"+language_type+"/"+device_type+"/routes/"+section_type+"/banner.json"
		}else if(sub_section == "overview" && country_code != "in" && language_type !="ar"){
			url  = "https://waytogo-banners.s3-ap-southeast-1.amazonaws.com/flights/"+country_code+"/"+page_type+"/"+language_type+"/"+device_type+"/"+sub_section+"/common/banner.json"
		}else{
			url  = "https://s3-ap-southeast-1.amazonaws.com/waytogo-banners/flights/"+country_code+"/"+page_type+"/"+language_type+"/"+device_type+"/index/"+section_type+"/banner.json"
		}
	}else if(page_type == 'flight-schedule'){
		if(page_sub_type == 'routes'){
			if(typeof main_page_type == 'undefined'){
				url_data = assign_url_dom_int(page_type,arr_city_code,dep_city_code,two_days,country_code,language_type,section_type,diff_days)
				url = url_data[0]
				href_url = url_data[1]
			}else{
				url  = "https://s3-ap-southeast-1.amazonaws.com/waytogo-banners/flights/"+country_code+"/"+page_type+"/"+language_type+"/"+device_type+"/"+section_type+"/banner.json"
				href_url = ""
			}
		}else{
			url = "https://s3-ap-southeast-1.amazonaws.com/waytogo-banners/flights/"+country_code+"/"+page_type+"/"+language_type+"/"+device_type+"/banner.json"
		}
	}else if(page_type == 'flight-tickets'){
		if(page_sub_type == 'routes'){
			url_data = assign_url_dom_int(page_type,arr_city_code,dep_city_code,two_days,country_code,language_type,section_type,diff_days)
			url = url_data[0]
			href_url = url_data[1]
		}else{
			url = "https://s3-ap-southeast-1.amazonaws.com/waytogo-banners/flights/"+country_code+"/flight-ticket/"+language_type+"/"+device_type+"/banner.json"
		}
	}
	if(url){
		console.log(url)
		$.ajax({
			type: "GET",
			dataType: 'jsonp',
			jsonp:false,
			jsonpCallback:'content',
			url: url
		}).done(function(data) {
			if(!$.isEmptyObject(data)  && data.banner_sections.length>0){
				$.each(data.banner_sections,function(a,item){
					item.section_image_src = "https://s3-ap-southeast-1.amazonaws.com/waytogo-banners/"+item.section_image_src})
				$.each(data.banner_sections,function(i,item){
					if(item.section_image_src != ''){
						domains = ['sa','ae']
						present = domains.indexOf(country_code)
						if(href_url){
							section_image_link = href_url
						}else{
							section_image_link = item.section_image_link
						}
						if(section_type == "domestic" && country_code == "in" && (page_type != 'flight-schedule' || page_type != 'flight-booking') && page_sub_type != 'routes'){
							section_image_link = item.section_image_link
						}
						section_click_ga_event_category = item.section_click_ga_event_category;
						section_click_ga_event_label = item.section_click_ga_event_label;
						section_click_ga_event_action = item.section_click_ga_event_action;
						var onclick_ga_code = "_gaq.push(['_trackEvent','" + section_click_ga_event_category + "' , '" + section_click_ga_event_action + "', '" + section_click_ga_event_label + "']);";
						var onload_ga_code = ""
						if ($(document).width() > 959) {
							section_load_ga_event_category = item.section_load_ga_event_category;
							section_load_ga_event_label = item.section_load_ga_event_label;
							section_load_ga_event_action = item.section_load_ga_event_action;
							onload_ga_code = "_gaq.push(['_trackEvent','" + section_load_ga_event_category + "' , '" + section_load_ga_event_action + "', '" + section_load_ga_event_label + "']);";
						}
						section_image_src = item.section_image_src
						if(item.banner_type =='RHS'){
							if((page_type == 'flight-schedule' || page_type == 'flight-tickets') && page_sub_type == 'routes'){
								if(section_type == "domestic" && country_code == "in"){
									section_image_link = 	href_url
								}else{
									section_image_link =  item.section_image_link
								}
							}
							$("#Rside-bar #banner a").remove()
							$("#Rside-bar #banner").append("<a href=''><img></a>")
							$("#Rside-bar #banner > a").attr('href', section_image_link);
							$("#Rside-bar #banner > a > img").attr('src', section_image_src);
							$("#Rside-bar #banner > a").attr('onClick', onclick_ga_code);
							if ($(document).width() > 959) {
								$("#banner > a > img").attr('onLoad', onload_ga_code);
							}
						}else if(item.banner_type == 'LHS'){
							$("div.list-box #banner").append("<a href=''><img></a>")
							$("div.list-box #banner > a ").attr('href', section_image_link);
							$("div.list-box #banner > a > img").attr('src', section_image_src);
							$("div.list-box #banner > a").attr('onClick', onclick_ga_code);
							$("div.list-box #banner > a > img").css("width",'100%')
							if ($(document).width() > 959) {
								$("div.list-box #banner > a > img").attr('onLoad',onload_ga_code)	
							}
						}
					}
				})  
			}
		})
	}
	function assign_url_dom_int(page_type,arr_city_code,dep_city_code,two_days,country_code,language_type,section_type,diff_days){
		rename_pagetype =  page_type == 'flight-tickets' ? 'flight-ticket' : page_type
		device_type = isMobile.any() ? 'mobile' : 'desktop'
		href_url = "https://"+location.host
		href_url = isMobile.any() ? href_url+"/m" : href_url+""
		href_url = section_type == "international" ? href_url+"/flights/international/results?" : href_url+"/flights/results?"
		href_url +="rnd_one=R&from="+dep_city_code+"&to="+arr_city_code+"&depart_date="+two_days+"&return_date="+diff_days+"&adults=1&childs=0&infants=0&class=Economy"
		href_url += isMobile.any() ? "&mobile=true#firstTen" : ""
		source_type = page_type == "flight-schedule" ? "Schedule_Routes" : "Ticket_Routes"
		let section_offer_txt = section_type == "international" ? "International_Flat_Offer" : "Domestic_Flat_Offer"
		href_url += "&utm_source="+ source_type  + "&utm_medium=Center_Banner&utm_campaign="+section_offer_txt
		url  = "https://s3-ap-southeast-1.amazonaws.com/waytogo-banners/flights/"+country_code+"/"+rename_pagetype+"/"+language_type+"/"+device_type+"/"+section_type+"/banner.json"
		return [url,href_url]
	}
})



