$(document).ready(function(){
	var fare_calendar = (typeof(fare_calendar) == "undefined") ? [] : fare_calendar
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
	var mobile_link = (isMobile.any()) ? "/m" : "";
	var from_country;
	var to_country;
	var arr_city_name ;
	var dep_city_name;
	var is_mobile = isMobile.any() ? true : false
	var search_url = (location.href.includes('/ar/'))? "https://"+location.hostname+"/suggest/airports?expectedNumberOfRecords=10&outputLanguages=ARABIC&inputText=" : "https://"+location.hostname+"/places/airports/search?string="
	var dep_code = $("#departure_city_code").text();
	var arr_code = $("#arrival_city_code").text();
	var carrier_code = $("#carrier_code").text();
	var redirection_params =""
	var dep_city_code = $("#departure_city_code").text();
	var arr_city_code = $("#arrival_city_code").text();
	var selectedClass = "Economy";
	if(["www.cleartrip.sa","www.cleartrip.ae"].includes(location.hostname)==true && !location.href.includes('/ar/')){
		redirection_params = "&skip-lp-redirect=true"
	}
	jQuery.fn.animateAuto = function(prop, speed, callback){
		var elem, height, width;
		return this.each(function(i, el){
			el = jQuery(el), elem = el.clone().css({"height":"auto","width":"auto"}).appendTo("body");
			height = elem.css("height"),
			width = elem.css("width"),
			elem.remove();

			if(prop === "height")
				el.animate({"height":height}, speed, callback);
			else if(prop === "width")
				el.animate({"width":width}, speed, callback);  
			else if(prop === "both")
				el.animate({"width":width,"height":height}, speed, callback);
		});  
	}
//calendar code
if (typeof(lang) == "undefined") {
	lang = {
		calender: {
			airfare: "Airfare Calendar",
			today: "Today",
			cheapest: "Cheapest",
			calendar_note: "Note: Cleartrip Lowest Air Fares Calendar provides an indication of prices (per person) for a range of dates, so that you can see the cheapest air fares easily. The air fares you see here may not be available at the time you try and book."
		},
		flight_schedule: {
			mo: "Mo",
			tu: "Tu",
			we: "We",
			th: "Th",
			fr: "Fr",
			sa: "Sa",
			su: "Su"
		},
		currency: "Rs.",
		month: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
	}
}
if(location.hostname == "www.cleartrip.sa"){
	lang.currency = "SAR"
}else{
	lang.currency = location.hostname == "www.cleartrip.com" ? "Rs." : "AED";
}
if (typeof(lang.month) == "undefined") {
	lang.month = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
}
if($("#calendar").length>0){
	$("#horCalendar").show()
	$('#calendar').hide()
} 
switch (typeof(country_code)) {
	case "undefined":
	section = "IN";
	break;
	case "object":
	section = $(country_code).text();
	break;
	case "string":
	section = (country_code.toLowerCase() == "in") ? "IN" : "AE";
	break
}
if(location.hostname == "www.cleartrip.sa"){
	section = "SA"
}

//calendar api call
if ($("#calendar").length > 0) {
	var url = "https://www.cleartrip.com/seoapi/flight_api/calendar?from=" + dep_code + "&to=" + arr_code + "&section=" + section;
	$.ajax({
		type: "GET",
		dataType: "json",
		url: url
	}).done(function(data) {
		if($.isEmptyObject(data)){
			var flight_calendar =""
			var currency = ""
		}else{
			var flight_calendar = data.calendar_json;
			var currency = data.sell_currency_json["symbol"];
		}
		if (flight_calendar && flight_calendar != null && flight_calendar !="") {
			var prices = [];
			var calendar_values = [];
			var cheapest_ticket = 0;
			var costlist_ticket = 0;
			var cheap_flight = null;
			var cheap_ticket = null;
			var cheap_airline = null;
			var avaiable_values = [];
			var val = [];
			$.each(flight_calendar, function(key, val) {
				for (var i = 0; i < val.length; i++) {
					if (val[i]["pr"] != null) {
						prices.push(parseFloat(val[0]["pr"]));
						a = key.replace(/(\d{4})\-?(\d{2})\-?(\d{2})/, "$1-$2-$3");
						key_date = new Date(a);
						current_date = new Date();
						month = current_date.getMonth() + 1;
						month = month >= 10 ? month : "0" + month;
						current_day = current_date.getDate() <= 9 ? "0" + current_date.getDate() : current_date.getDate();
						b = current_date.getFullYear() + "-" + month + "-" + current_day;
						if (a >= b) {
							avaiable_values.push(parseFloat(val[0]["pr"]))
						}
					}
				}
				if (val.length > 0) {
					calendar_values.push(val)
				}
			});
			prices.sort(function(a, b) {
				return a - b
			});
			if (prices != null) {
				cheapest_ticket = prices[0];
				costlist_ticket = prices[prices.length - 1]
			}
			var calendar_routes = calendar_values.length;
			if (avaiable_values.length > 3) {
				if (calendar_routes >= 3) {
					$("#link-to-calendar").append('<a href="#calendref">' + lang.calender.airfare + "</a>");
					if ($("a[href=#calendref]").length > 1) {
						$("a[href=#calendref]").first().remove()
					}
					var day_count = 1;
					var now = new Date();
					var today = new Date();
					var calendar_start = new Date(today.setDate(today.getDate() - today.getDay()));
					var calendar_container = $('<table class="calendar table-bordered" id="calendar_table" width="100%" > <colgroup class="weekday"> <col class="Mon" /> <col class="Tue" /> <col class="Wed" /> <col class="Thu" /> <col class="Fri" /> </colgroup> <colgroup class="weekend"> <col class="Sat" /> <col class="Sun" /> </colgroup> <thead> <tr> <th>' + lang.flight_schedule.mo + "</th><th>" + lang.flight_schedule.tu + "</th> <th>" + lang.flight_schedule.we + " </th> <th>" + lang.flight_schedule.th + " </th> <th>" + lang.flight_schedule.fr + "</th> <th>" + lang.flight_schedule.sa + " </th> <th>" + lang.flight_schedule.su + "</th> </tr> </thead><tbody>");
					$("#calender_display").append(calendar_container);
					$("#calender_display table tbody").append('<tr class="day">');
					if ($("#calender_display .calendar").length > 1) {
						$($(".calendar")[0]).next().remove();
						$($(".calendar")[0]).remove()
					}
					$("#slider").empty();
					for (var i = 1; i <= 35; i++) {
						var cal_day = addDays(calendar_start, day_count);
						if ((cal_day > now) && (cal_day != now)) {
							var cheap_flight = get_cheap_flight(flight_calendar, cal_day)
						}
						if (cheap_flight != null) {
							cheap_ticket = cheap_flight.pr;
							cheap_airline = cheap_flight.aln;
							cheap_airline_code = cheap_flight.al
						}
						if (!(cal_day.isSameDateAs(now)) && (cheapest_ticket != cheap_ticket)) {
							$("#calender_display table tbody tr:last").append('<td id="day_' + i + '">')
						} else {
							if (cal_day.isSameDateAs(now)) {
								$("#calender_display table tbody tr:last").append('<td id="day_' + i + '" class="today">')
							}
							if (cheapest_ticket == cheap_ticket) {
								$("#calender_display table tbody tr:last").append('<td id="day_' + i + '" class=best>')
							}
						}
						if (cal_day.isSameDateAs(now)) {
							$("#calender_display table tbody tr:last td:last").append("<p><span> " + lang.calender.today + "  </span>" + addZero(cal_day.getDate()) + " " + lang.month[cal_day.getMonth()] + "</p>")
						} else {
							if (cheapest_ticket == cheap_ticket) {
								$("#calender_display table tbody tr:last td:last").append('<p>'  + addZero(cal_day.getDate()) + " " + lang.month[cal_day.getMonth()] + "</p>")
							} else {
								$("#calender_display table tbody tr:last td:last").append("<p>" + addZero(cal_day.getDate()) + " " + lang.month[cal_day.getMonth()] + "</p>")
							}
						}
						if ((cal_day > now) && !(cal_day.isSameDateAs(now))) {
							if (cheap_ticket != null) {
								$("#calender_display table tbody tr:last td:last").append('<div class="vevent"> <abbr class="dtstart" title="' + cal_day.toJSON().substring(8, 10) + "/" + cal_day.toJSON().substring(5, 7) + "/" + cal_day.toJSON().substring(0, 4) + '"></abbr>')
							} else {
								$("#calender_display table tbody tr:last td:last")
							}
							if (cheap_ticket != null) {
								var cheap_ticket_val = Math.round(parseFloat(cheap_ticket));
								cheap_ticket_val = cheap_ticket_val.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, "$1,").split(".")[0];
								$("#calender_display  table tbody tr:last td:last div").append('<p class="summary"><a id="anchorDate_' + day_count + '" href="/flights/results?from=' + dep_code + "&to=" + arr_code + "&adults=1&childs=0&infants=0&depart_date=" + cal_day.toJSON().substring(8, 10) + "/" + cal_day.toJSON().substring(5, 7) + "/" + cal_day.toJSON().substring(0, 4) + "&dep_time=0&class=Economy&airline=" + cheap_airline_code + '&carrier=&x=57&y=16&flexi_search=no" title="Click for flight details and booking"  rel="nofollow">' + lang.currency + " " + cheap_ticket_val + '</a></p><dl class="description"><dt><span title="Going there" class="to"></span></dt><dd>' + cheap_airline + "</dd></dl>");
								// link = "/flights/results?from=" + dep_code + "&to=" + arr_code + "&adults=1&childs=0&infants=0&depart_date=" + cal_day.toJSON().substring(8, 10) + "/" + cal_day.toJSON().substring(5, 7) + "/" + cal_day.toJSON().substring(0, 4) + "&dep_time=0&class=Economy&airline=" + cheap_airline_code + "&carrier=&x=57&y=16&flexi_search=no";
								// debugger
								let from = $('.from').val() != "" ? $('.from').val() : "DEL"
  							let to = $('.to').val() != "" ? $('.to').val() : "BLR"
  							let link = window.location.pathname
  							let trip = $("input[name='rnd_one']:checked").val() == "rnd" ? "R" : "O"
                let ret_date = ""
                if(trip == "R"){
                	trip = "R"
                  ret_date = "&arr_date=" + cal_day.format("dd/mm/yyyy")
                }
                link += "?from=" + from +"&to=" + to + "&trip=" + trip +"&dep_date=" + cal_day.format("dd/mm/yyyy") + ret_date  + "&adult_count=1&child_count=0&infants_count=0&travell_class=Economy&utm_source=schedule_route&utm_medium=search_widget&utm_campaign=srp_one_load"; 
								// link += "?from=" + from +"&to=" + to + "&trip=O&dep_date=" + cal_day.format("dd/mm/yyyy")+ "&adult_count=1&child_count=0&infants_count=0&travell_class=Economy&utm_source=schedule_route&utm_medium=search_widget&utm_campaign=srp_one_load"; 
								$("#calender_display").append("</div>");
								cal_html = '<div class="slide"><a href="' + link + '"><span class="date-info">' + cal_day.format("ddd, dd mmm") + '</span><span class="price-info"><span class="currency-symboal"></span><span class="currency-symboal">' + lang.currency + "</span>" + cheap_ticket_val + "</span></a></div>"
							} else {
								cal_html = "";
								$("#calender_display table tbody tr:last td:last div").append("<p></p>")
							}
							$("#slider").append(cal_html)
						}
						$("#calender_display table tbody tr").append("</td>");
						if (i % 7 == 0) {
							if (i == 35) {
								$("#calender_display table tbody").append("</tr>")
							} else {
								$("#calender_display table tbody").append("</tr><tr>")
							}
						}
					}
					slider.reloadSlider();
				} else {
					$("#calendar").hide()
					$("#horCalendar").hide()
				}
			} else {
				$(".calendar-new").hide()
				$("#horCalendar").hide()
			}
		}
		if($.isEmptyObject(data)){
			$(".calendar-new").hide()
			$("#horCalendar").hide()
		}
	}).fail(function(xhr, textStatus, errorThrown) {})
}
function addDays(dateObj, numDays) {
	dateObj.setDate(dateObj.getDate() + numDays);
	return dateObj
}

function subDays(dateObj, numDays) {
	dateObj.setDate(dateObj.getDate() - numDays);
	return dateObj
}

function addZero(i) {
	if (i < 10) {
		i = "0" + i
	}
	return i
}

function get_cheap_flight(flight_calendar, cal_day) {
	var cheap_flight;
	var cheap_day_price = [];
	var day = addZero(cal_day.getDate());
	var month = addZero(cal_day.getMonth() + 1);
	var year = cal_day.getFullYear();
	var cheapest_ticket;
	full_date = year.toString() + month.toString() + day.toString();
	intDate = parseInt(full_date);
	day_data = flight_calendar[intDate];
	if (day_data != null) {
		$.each(day_data, function(key, val) {
			if (carrier_code != "") {
				if (val.al == carrier_code) {
					$.each(val, function(ckey, cval) {
						if (cval != null && ckey == "pr") {
							cheap_day_price.push(parseFloat(cval))
						}
					})
				}
			} else {
				$.each(val, function(ckey, cval) {
					if (cval != null && ckey == "pr") {
						cheap_day_price.push(parseFloat(cval))
					}
				})
			}
		});
		cheapest_ticket = cheap_day_price.sort(function(a, b) {
			return a - b
		})[0];
		$.each(day_data, function(key, val) {
			if (carrier_code != "") {
				if (val.al == carrier_code) {
					$.each(val, function(ckey, cval) {
						if (ckey == "pr") {
							if (cval != null && cval == cheapest_ticket) {
								cheap_flight = val
							}
						}
					})
				}
			} else {
				$.each(val, function(ckey, cval) {
					if (ckey == "pr") {
						if (cval != null && cval == cheapest_ticket) {
							cheap_flight = val
						}
					}
				})
			}
		})
	}
	return cheap_flight
}
Date.prototype.isSameDateAs = function(pDate) {
	return (this.getFullYear() === pDate.getFullYear() && this.getMonth() === pDate.getMonth() && this.getDate() === pDate.getDate())
};

$("#fullCalendarShow").click(function() {
	$("#calendar").slideToggle();
});
var slider = $("#slider").bxSlider({
	slideWidth: 120,
	minSlides: 2,
	maxSlides: 7,
	slideMargin: 8,
	infiniteLoop: false,
	hideControlOnEnd: true
});

if(is_mobile){
		// toggle functionality of routes
		$(".m-sw-slide").hide();
		$('.mview-toggle-header').click(function(){
			if($(this).hasClass("arrFlights")){
				if($('.arrFlightsToggle').css("height") == "0px"){
					$('.arrFlightsToggle').animateAuto("height",1500,function(){
						$('.arrFlightsToggle').css('height','auto')
					})
				}else{
					$('.arrFlightsToggle').animate({'height':'0px'},800,function(){
						$('.arrFlightsToggle').css('height','0px')
					})
				}
			}else{

				if($('.depFlightsToggle').css("height") == "0px"){
					$('.depFlightsToggle').animateAuto("height",1500,function(){
						$('.depFlightsToggle').css('height','auto')
					})
				}else{
					$('.depFlightsToggle').animate({'height':'0px'},800,function(){
						$('.depFlightsToggle').css('height','0px')
					})
				}
			}
		})
		$('.mview-faq-header').click(function(){
			if($('.mview-mf-faqtoggle').css('height') == '0px'){
				$('.mview-mf-faqtoggle').animateAuto("height",1500,function(){
					$('.mview-mf-faqtoggle').css({'height':'auto'})
				})
			}else{
				$('.mview-mf-faqtoggle').animate({'height': '0px'},800,function(){
					$('.mview-mf-faqtoggle').css({'height':'0px'})
				})
			}
		})
		$('.mview-review-header').click(function(){
			if($('.mreview-toggle-cnt').css('height') == '0px'){
				$('.mreview-toggle-cnt').animateAuto("height",1500,function(){
					$('.mreview-toggle-cnt').css({'height':'auto'})
				})
			}else{
				$('.mreview-toggle-cnt').animate({'height': '0px'},800,function(){
					$('.mreview-toggle-cnt').css({'height':'0px'})
				})
			}
		})
		//content toggle
		$('.readmore-btn').click(function(){
			let cssProperty = $('.unique-content').css('height')
			if(cssProperty != 'auto'){
				let prop = cssProperty.replace(/px$/,'')
				if(parseInt(prop) <= 270){
					$('.unique-content').css('height','auto')
				}else{
					$('.unique-content').css('height','270px')
					$('html, body').animate({
						scrollTop: $(".unique-content").offset().top
					}, 700);
				}
			}else{
				$('.unique-content').css('height','270px')
				$('html, body').animate({
					scrollTop: $(".unique-content").offset().top
				}, 700);
			}
			let txt = $(this).text() == "Read More" ? "Read Less" : "Read More"
			if(txt == "Read More"){
				$('.unique-content').removeClass('fadingCls')
			}else{
				$('.unique-content').addClass('fadingCls')
			}
			$(this).text(txt)
		})

		 //image swap functionality
		 $('.sort-icons').click(function(){
		 	swap_val =''
		 	dep=$('.origin_autocomplete_mob').val()
		 	arr =$('.destination_autocomplete_mob').val()
		 	if(dep !="" && arr != "" && typeof(from_country) !="undefined" && from_country != "" && typeof(to_country) !="undefined" && from_country !="" && dep_city_name && dep_city_name !="" && arr_city_name && arr_city_name !="" && typeof(dep_code) !="undefined" && dep_code !="" && typeof(arr_code) !="undefined"  && arr_code !=""){
		 		res = swapString(dep,arr)
		 		$('.origin_autocomplete_mob').val(res[0])
		 		$('.fromCityName').text(res[0])
		 		$('.destination_autocomplete_mob').val(res[1])
		 		$('.toCityName').text(res[1])
		 		res = swapString(dep_city_code,arr_city_code)
		 		dep_city_code = res[0]
		 		$('.depart-city .city_code').text(res[0])
		 		arr_city_code = res[1]
		 		$('.arrival-city .city_code').text(res[1])
		 		$('.from').val(dep_city_code)
		 		$('.to').val(arr_city_code)
		 		res = swapString(from_country,to_country)
		 		from_country =  res[0]
		 		to_country =  res[1]
		 		res = swapString(dep_city_name,arr_city_name)
		 		dep_city_name = res[0]
		 		arr_city_name = res[1]
		 		if ($(this).find('img').css('transform') == 'none') {
		 			$(this).find('img').css({'transform': 'rotate(180deg)'});
		 		} else {
		 			$(this).find('img').css({'transform': ''});
		 		};
		 	}
		 })

		 // search-icon toggle
		 $('.m-search-icon').click(function(){
		 	$(".m-sw-slide").is(':visible') ? $(".m-sw-slide").hide() : $(".m-sw-slide").show()
		 });
		 $('#mobDate').datepicker({
		 	numberOfMonths: 3,
		 	stepMonths:1,
		 	firstDay:1,
		 	minDate:0,
		 	dateFormat:'dd/mm/yy',
		 	showButtonPanel:true,
		 	closeText:'X',
		 	beforeShow:addCustomInformation,
		 	onChangeMonthYear: addCustomInformation,
		 	onSelect:function(date){
		 		let	cal_selDate= moment(date,'DD/MM/YYYY').toDate()
		 		$('#dpt_date_mob').datepicker("setDate",moment(cal_selDate).format("DD MMM"))
		 		let dep_val = $('#dpt_date_mob').val()
		 		$('.mobile-top-headers .m-date-txt').text(dep_val.split(" ")[0])
		 		$('.mobile-top-headers span.m-month').text(dep_val.split(" ")[1])
		 		let dep_daytxt = moment(cal_selDate).format('ddd')
		 		$('.mobile-top-headers span.m-day').text(dep_daytxt)
		 		$('span.dep_text').text(dep_daytxt)
		 		$('#form_dep_date').val(moment(cal_selDate).format("DD/MM/YYYY"))
		 		$('#button_flight_search_mob').trigger('click')
		 	}
		 });
		 $('.mCalendarIcon,.m-date').click(function(){
		 	var search_params = window.location.search ? QueryStringToJSON() : {}
		 	if(search_params["trip"] == "R"){
		 		$(".m-sw-slide").is(':visible') ? $(".m-sw-slide").hide() : $(".m-sw-slide").show()
		 	} else{
		 		$(".m-sw-slide").hide()
		 		$('#mobDate').datepicker("show")
		 		$('#ui-datepicker-div').removeClass("swmDatePicker")
		 		$('#ui-datepicker-div').addClass("mDatePicker")
		 	}
		 	
		 })		 
		 var no_months = isMobile.any() ? 1 : 2;
		 var step_months = isMobile.any()? 1 :2;
		 $('#dpt_date_mob').datepicker({
		 	minDate: 0,
		 	dateFormat: "dd M",
		 	numberOfMonths: no_months,
		 	showButtonPanel:true,
		 	closeText:'X',
		 	firstDay:1,
		 	stepMonths:step_months,
		 	dayNamesMin: ["S", "M", "T", "W", "T", "F", "S"],
		 	monthNamesShort: $.datepicker.regional["en"].monthNamesShort,
		 	beforeShow: addCustomInformation,
		 	onChangeMonthYear: addCustomInformation,
		 	onSelect: (function (date) {
		 		var rtn_date_mob = $('#rtn_date_mob');
		 		var startDate = $(this).datepicker('getDate');
		 		var minDate = $(this).datepicker('getDate');
		 		$(this).datepicker("option", "dateFormat", "dd M")
		 		$('#form_dep_date').val(moment(minDate).format("DD/MM/YYYY"))
		 		dep_daytxt = moment(minDate).format('ddd')
		 		minDate.setDate(minDate.getDate() + 1);
		 		rtn_date_mob.datepicker('setDate', minDate);
		 		rtn_date_mob.datepicker('option', 'minDate', startDate);
		 		ret_daytxt = moment(minDate).format('ddd')
		 		$('span.dep_text').text(dep_daytxt)
		 		$('span.ret_text').text(ret_daytxt)
		 		if($(".moile_radioBtn input[name='rnd_one']:checked").val() == 'rnd' ||$(".moile_radioBtn input[name='rnd_one']:checked").val() == "R" ){
		 			setTimeout(function(){
		 				$('#form_rtn_date').val(moment(minDate).format("DD/MM/YYYY"))
		 				$('#rtn_date_mob').datepicker('show')
		 			},300)
		 		}
		 	})
		 });

		 $('#rtn_date_mob').datepicker({
		 	numberOfMonths: no_months,
		 	dateFormat: "dd M",
		 	stepMonths:step_months,
		 	showButtonPanel:true,
		 	closeText:'X',
		 	minDate:0,
		 	firstDay:1,
		 	beforeShow: addCustomInformation,
		 	onChangeMonthYear: addCustomInformation,
		 	dayNamesMin: ["S", "M", "T", "W", "T", "F", "S"],
		 	monthNamesShort: $.datepicker.regional["en"].monthNamesShort,
		 	onSelect: (function(){
		 		rt_date = $(this).datepicker('getDate')
		 		$('#form_rtn_date').val(moment(rt_date).format("DD/MM/YYYY"))
		 		var ret_daytxt = moment(rt_date).format("ddd")
		 		$('span.ret_text').text(ret_daytxt)
		 	}),
		 	onClose:(function () {
		 	})
		 });
		 function swapString(a,b){
		 	c=''
		 	c = a
		 	a = b
		 	b = c
		 	return [a,b]
		 }
		 function pad(n) {return (n<10 ? '0'+n : n);}
		 function lastday(y,m){return new Date(y,m+1,0)}
		 if(is_mobile){
		 	if(section && (section == 'SA' || section == "IN") && typeof(section_type) != "undefined"  && section_type == "domestic" && typeof(dep_city_code) != "undefined" && typeof(arr_city_code) != "undefined"){
		 		url ="https://www.cleartrip.com/seoapi/flight_api/fare_calendar?from="+dep_city_code+"&to="+arr_city_code+"&section="+section
		 		// url ="https://api.myjson.com/bins/upnew"
		 		$.ajax({
		 			url:url,
		 			method: 'GET',
		 			dataType: "json",
		 			success: function(res){
		 				var current_date = new Date()
		 				month = current_date.getMonth()+1
		 				year = current_date.getFullYear()
		 				lastdate = lastday(year,month)
		 				fare_calendar = []
		 				$.each(res,function(e,v){
		 					if(parseInt(v["date"]) <= parseInt(lastdate.format("yyyymmdd"))){
		 						fare_calendar.push(v)
		 					}
		 				})
		 			},
		 			complete:function(){
						// $("#dpt_date_mob").datepicker("setDate",new Date(Date.now() + (24 * 2 * 60 * 60 * 1000))).datepicker('show')
						// $("#dpt_date_mob").datepicker("setDate",moment().add(2,'days').format("DD MMM"))
					}
				},200)
		 	}else{
		 		setTimeout(function(){
		 			// $("#dpt_date_mob").datepicker("setDate",moment().add(2,'days').format("DD MMM"))
					// $("#dpt_date_mob").datepicker("setDate",new Date(Date.now() + (24 * 2 * 60 * 60 * 1000))).datepicker('show')
				},700)
		 	}
		 }
		 function addCustomInformation() {
		 	$('#ui-datepicker-div').removeClass("mDatePicker")
		 	$('#ui-datepicker-div').addClass("swmDatePicker")
		 	if(section && (section == 'SA' || section == "IN") && typeof(section_type) != "undefined"  && section_type == "domestic" && typeof(dep_city_code) != "undefined" && typeof(arr_city_code) != "undefined"){
		 		setTimeout(function(){
		 			$(".ui-datepicker-calendar td").filter(function() {
		 				if(!$(this).hasClass("ui-state-disabled")){
		 					var day = pad($(this).text())
		 					var month = $(this).attr("data-month")
		 					var month = pad((parseInt(month)+1).toString())
		 					var year = $(this).attr("data-year")
		 					date =  year+""+month+""+day
		 					min_price =""
		 					if(fare_calendar.length > 0){
		 						$.each(fare_calendar,function(e,v){
		 							if(v["date"]== date){
		 								price = parseInt(v["min_price"])
		 								price = price.toString()
		 								min_price = price.replace(/(\d)(?=(\d\d)+\d$)/g, "$1,");
		 							}
		 						})
		 					}
		 					if(min_price){
		 						$(this).append("<span class='calendarPrice low'>" + min_price + "</small>")}
		 					}
		 				})
		 		},50)
		 	}
		 }
		}
		$('.increment').on('click',function(e){
			$('.desktop_travellers').click(function(e){
				e.stopPropagation()
			})
			var self = $(this);
			var adultCount = parseInt($(this).closest('ul').find('.adult-count').text());
			var childrenCount = parseInt($(this).closest('ul').find('.child-count').text());
			var infantCount  = parseInt($(this).closest('ul').find('.infant-count').text());
			var totalTravellers = adultCount + childrenCount;
			var count = '';
			if(self.hasClass('infant-increment')){
				count =  '';
				count = parseInt(self.closest('li').find('.count').text());
				if(count < adultCount){
					count++;
					$('.infant-count').text(count);
				}
				$('.infant-decrement').css({
					'color': '#848484',
					'background': '#fff',
					'border': '2px solid #848484',
					'cursor':'pointer'
				});
			}
			else{
				if(totalTravellers >= 0 && totalTravellers <9){
					if(self.hasClass('adult-increment')){
						count =  '';
						count = parseInt(self.closest('li').find('.count').text());
						count++;
						$('.adult-count').text(count);

						$('.adult-decrement').css({
							'color': '#848484',
							'background': '#fff',
							'border': '2px solid #848484',
							'cursor':'pointer'
						});
						if(totalTravellers < 9){
							$('.infant-increment').css({
								'color': '#848484',
								'background': '#fff',
								'border': '2px solid #848484',
								'cursor':'pointer'
							});
						}
					}
					else if(self.hasClass('child-increment')){
						count =  '';
						count = parseInt(self.closest('li').find('.count').text());
						count++;
						$('.child-count').text(count);
						$('.child-decrement').css({
							'color': '#848484',
							'background': '#fff',
							'border': '2px solid #848484',
							'cursor':'pointer'
						});
					}
				}
			}
			adultCount = parseInt($(this).closest('ul').find('.adult-count').text());
			childrenCount = parseInt($(this).closest('ul').find('.child-count').text());
			infantCount  = parseInt($(this).closest('ul').find('.infant-count').text());

			$('form').find('input[name="adults"]').val(adultCount);
			$('form').find('input[name="childs"]').val(childrenCount);
			$('form').find('input[name="infants"]').val(infantCount);

			totalTravellers = adultCount+childrenCount;
			if(totalTravellers < 2){
				var travellerValue = adultCount+childrenCount+infantCount+' Traveller';
			} else {
				var travellerValue = adultCount+childrenCount+infantCount+' Travellers';
			}


			$('.traveller-menu').prev('input').val(travellerValue);

			if(adultCount == infantCount){
				$('.infant-increment').css({
					'color': '#d8d8d8',
					'background': '#fff',
					'border': '2px solid #d8d8d8',
					'cursor':'not-allowed'
				});
				$('.adult-decrement').css({
					'color': '#d8d8d8',
					'background': '#fff',
					'border': '2px solid #d8d8d8',
					'cursor':'not-allowed'
				});
			}

			if(adultCount > infantCount && adultCount!=1){
				$('.adult-decrement').css({
					'background':'#ec4023',
					'cursor':'pointer'
				})
			}

			if(totalTravellers >= 9){
				$('.adult-increment').css({
					'color': '#d8d8d8',
					'background': '#fff',
					'border': '2px solid #d8d8d8',
					'cursor':'not-allowed'
				});
				$('.child-increment').css({
					'color': '#d8d8d8',
					'background': '#fff',
					'border': '2px solid #d8d8d8',
					'cursor':'not-allowed'
				});
			}

		});


		$('.decrement').on('click',function(e){
			$('.desktop_travellers').click(function(e){
				e.stopPropagation()
			})
			var self = $(this);
			var adultCount = parseInt($(this).closest('ul').find('.adult-count').text());
			var childrenCount = parseInt($(this).closest('ul').find('.child-count').text());
			var infantCount  = parseInt($(this).closest('ul').find('.infant-count').text());
			var totalTravellers = adultCount + childrenCount;
			var count = '';
			if(self.hasClass('infant-decrement')){
				count = '';
				count = parseInt(self.closest('li').find('.count').text());
				count--;
				if(count >= 0){
					$('.infant-count').text(count);
				}
				if(count == 0){
					self.css({
						'color': '#d8d8d8',
						'background': '#fff',
						'border': '2px solid #d8d8d8',
						'cursor':'not-allowed'
					});
				}
				$('.infant-increment').css({
					'color': '#848484',
					'background': '#fff',
					'border': '2px solid #848484',
					'cursor':'pointer'
				});
			}
			else{
				if( totalTravellers > 0 && totalTravellers <= 9){
					if(self.hasClass('adult-decrement')){
						count =  '';
						count = parseInt(self.closest('li').find('.count').text());
						if(count > 1 && count > infantCount){
							count--;
							$('.adult-count').text(count);
						}
						if(count == 1){
							self.css({
								'color': '#d8d8d8',
								'background': '#fff',
								'border': '2px solid #d8d8d8',
								'cursor':'pointer'
							});
						}
						if(totalTravellers!=9){
							$('.adult-increment').css({
								'color': '#848484',
								'background': '#fff',
								'border': '2px solid #848484',
								'cursor':'pointer'
							});
						}

					}
					else if(self.hasClass('child-decrement')){
						count = '';
						count = parseInt(self.closest('li').find('.count').text());
						count--;
						if(count >= 0){
							$('.child-count').text(count);
						}
						if(count == 0){
							self.css({
								'color': '#d8d8d8',
								'background': '#fff',
								'border': '2px solid #d8d8d8',
								'cursor':'not-allowed'
							});
						}
						if(totalTravellers != 9){
							$('.child-increment').css({
								'color': '#848484',
								'background': '#fff',
								'border': '2px solid #848484',
								'cursor':'pointer'
							});
						}

					}

				}
			}
			adultCount = parseInt($(this).closest('ul').find('.adult-count').text());
			childrenCount = parseInt($(this).closest('ul').find('.child-count').text());
			infantCount  = parseInt($(this).closest('ul').find('.infant-count').text());

			$('input[name=adults]').val(adultCount);
			$('input[name=childs]').val(childrenCount);
			$('input[name=infants]').val(infantCount);


			totalTravellers = adultCount+childrenCount;
			if(totalTravellers < 2){
				var travellerValue = adultCount+childrenCount+infantCount+' Traveller';
			} else {
				var travellerValue = adultCount+childrenCount+infantCount+' Travellers';
			}
//                    var travellerValue = adultCount+childrenCount+infantCount+' Travellers';

$(this).closest('.traveller-menu').prev('input').val(travellerValue);

if(totalTravellers == 1){
	$('.adult-decrement').css({
		'color': '#d8d8d8',
		'background': '#fff',
		'border': '2px solid #d8d8d8',
		'cursor':'not-allowed'
	});
	$('.child-decrement').css({
		'color': '#d8d8d8',
		'background': '#fff',
		'border': '2px solid #d8d8d8',
		'cursor':'not-allowed'
	});
}
if(totalTravellers < 9){
	$('.increment').css({
		'color': '#848484',
		'background': '#fff',
		'border': '2px solid #848484',
		'cursor':'pointer'
	})
}

if(adultCount == infantCount){
	$('.adult-decrement').css({
		'color': '#d8d8d8',
		'background': '#fff',
		'border': '2px solid #d8d8d8',
		'cursor':'not-allowed'
	});
	$('.infant-increment').css({
		'color': '#d8d8d8',
		'background': '#fff',
		'border': '2px solid #d8d8d8',
		'cursor':'not-allowed'
	});
}

if(adultCount > infantCount && adultCount!= 1){
	$('.adult-decrement').css({
		'background':'#ec4023',
		'cursor':'pointer'
	})
}
});


		$("#origin_autocomplete_mob").autocomplete({
			source: function(req, resp) {
				$.getJSON(search_url + req.term+redirection_params, function(res) {
					$('ul.depAutoCompleteCities').html("")
					var result_data = [];
					res = parseAutoCmp(res);
					$.each(res, function(i, d) {
						result_data.push({
							label: d.v,
							value: d.v
						})
						$('ul.cityAutoCompleteData').hide()
						$('ul.depAutoCompleteCities').closest('div.depCity').find('h4').hide()
						$('ul.depAutoCompleteCities').append($('ul.depAutoCompleteCities').append('<li><span class="city_code">'+d.k+'</span><span class="city_name">'+d.v+'</span></li>'))
					});
					if(result_data.length == 0){
						$('ul.cityAutoCompleteData').show()
						$('ul.depAutoCompleteCities').html("")
						$('ul.depAutoCompleteCities').closest('div.depCity').find('h4').show()
					}
					resp(result_data)
				})
			},
			select: function(ui, selected) {
				var selected_city = extractCITY(selected.item.value);
				if (ui.target.id == "origin_autocomplete_mob") {
					from_country = extractCountry(selected.item.value);
					dep_city_name = extractCityName(selected.item.value)
					$(".from").val(selected_city)
				} else {
					to_country = extractCountry(selected.item.value);
					arr_city_name = extractCityName(selected.item.value)
					$(".to").val(selected_city)
				}
			},
			minLength: 3
		});

		$('#fromCityAutocompleteModel,#toCityAutocompleteModel').on('shown.bs.modal',function(){
			$('ul.cityAutoCompleteData').show()
			$('ul.arrAutoCompleteCities').closest('div.arrivalCity').find('h4').show()
			$('ul.arrAutoCompleteCities').html("")
			$('ul.depAutoCompleteCities').closest('div.depCity').find('h4').show()
			$('ul.depAutoCompleteCities').html("")
		// $('#origin_autocomplete_mob').val("")
		// $('#destination_autocomplete_mob').val("")
	})


		$("#destination_autocomplete_mob").autocomplete({
			source: function(req, resp) {
				$.getJSON(search_url + req.term+redirection_params, function(res) {
					$('ul.arrAutoCompleteCities').html("")
					var result_data = [];
					res = parseAutoCmp(res);
					$.each(res, function(i, d) {
						result_data.push({
							label: d.v,
							value: d.v
						})
						$('ul.cityAutoCompleteData').hide()
						$('ul.arrAutoCompleteCities').closest('div.arrivalCity').find('h4').hide()
						$('ul.arrAutoCompleteCities').append($('ul.arrAutoCompleteCities').append('<li><span class="city_code">'+d.k+'</span><span class="city_name">'+d.v+'</span></li>'))
					});
					if(result_data.length == 0){
						$('ul.cityAutoCompleteData').show()
						$('ul.arrAutoCompleteCities').html("")
						$('ul.arrAutoCompleteCities').closest('div.arrivalCity').find('h4').show()
					}
					resp(result_data)
				})
			},
			select: function(ui, selected) {
				var selected_city = extractCITY(selected.item.value);
				if (ui.target.id == "origin_autocomplete_mob") {
					from_country = extractCountry(selected.item.value);
					dep_city_name = extractCityName(selected.item.value)
					$(".from").val(selected_city)
				} else {
					to_country = extractCountry(selected.item.value);
					arr_city_name = extractCityName(selected.item.value)
					$(".to").val(selected_city)
				}
			},
			minLength: 3
		});


		if(is_mobile){
			$('#origin_autocomplete_mob,#destination_autocomplete_mob').on('click',function(){
				$(this).select()
			})
			if (dep_code != undefined && dep_code != null && dep_code != "") {
				$.ajax({
					type: "GET",
					dataType: "json",
					url: search_url + dep_code+redirection_params
				}).done(function(dep_data) {
					if (dep_data[0] != undefined) {
						dep_data = parseAutoCmp(dep_data);
						$(".from").val(dep_code);
						$.each(dep_data, function(index) {
							if (dep_code == dep_data[index].k) {
								dep_city_name = extractCityName(dep_data[index].v);
								$('p.fromCity').addClass('hide')
								$('div.fromCityName').text(dep_city_name)
								from_country = extractCountry(dep_data[index].v);
								$("#origin_autocomplete_mob").val(dep_data[index].v)
							}
						})
					}
				})
			}
			if (arr_code != undefined && arr_code != null && arr_code != "") {
				$.ajax({
					type: "GET",
					dataType: "json",
					url: search_url + arr_code+redirection_params
				}).done(function(arr_data) {
					if (arr_data[0] != undefined) {
						arr_data = parseAutoCmp(arr_data);
						$(".to").val(arr_code);
						$.each(arr_data, function(index) {
							if (arr_code == arr_data[index].k) {
								arr_city_name = extractCityName(arr_data[index].v);
								$('p.toCity').addClass('hide')
								$('div.toCityName').text(arr_city_name)
								to_country = extractCountry(arr_data[index].v);
								$("#destination_autocomplete_mob").val(arr_data[index].v)
							}
						})
					}
				})
			}
		}

		var arDomains = ["www.cleartrip.sa", "www.cleartrip.ae"];
		if (typeof window.languageType != "undefined") {
			var languageType = window.languageType
		}
		if (typeof window.language_type != "undefined") {
			var languageType = window.language_type
		}
		var search_params = window.location.search ? QueryStringToJSON() : {}
		if(window.location.search && search_params["dep_date"]  && !location.href.includes("/ar/") ){
			if(search_params["adult_count"] && search_params["infants_count"] && search_params["child_count"]){
				var travellers_txt = parseInt(search_params["adult_count"])+parseInt(search_params["child_count"])+parseInt(search_params["infants_count"])
				$('form').find('input[name="adults"]').val(search_params["adult_count"])
				$('form').find('input[name="childs"]').val(search_params["child_count"])
				$('form').find('input[name="infants"]').val(search_params["infants_count"])
				$('.traveller-menu li span.adult-count').text(search_params["adult_count"])
				$('.traveller-menu li span.child-count').text(search_params["child_count"])
				$('.traveller-menu li span.infant-count').text(search_params["infants_count"])
				selectedClass = search_params["travell_class"] && search_params["travell_class"] !="" ? search_params["travell_class"] : "Economy"
				$("select#travell-class").val(selectedClass).change()
				$(".f-class-details").text(selectedClass+" | "+travellers_txt+" Travellers")
				$('.totTravellers').text(travellers_txt+" Travellers")
			}
			if(search_params["dep_date"] !="" ){
				var calendar_depDate= moment(search_params["dep_date"],'DD/MM/YYYY').toDate()
				var headerDepDateVal = moment(calendar_depDate).format("DD MMM")
				var dep_daytxt = moment(calendar_depDate).format('ddd')
				$('#dpt_date_mob').datepicker("setDate",moment(calendar_depDate).format("DD MMM"))
				$('div.m-round-dep .m-date-txt').text(headerDepDateVal.split(" ")[0])
				$('div.m-round-dep .m-month').text(headerDepDateVal.split(" ")[1])
				$('#form_dep_date').val(moment(calendar_depDate).format("DD/MM/YYYY"))
				$('div.m-round-dep .m-day').text(dep_daytxt)
			}
			else{
				let new_date = new Date();
				let to_day = `${new_date.getDate()}/${new_date.getMonth()}/${new_date.getFullYear()}`
				$('#form_dep_date').val(to_day) 
			}
			if(search_params["trip"] == "R" && search_params["arr_date"] && search_params["arr_date"] !=""){
				var calendar_arrDate= moment(search_params["arr_date"],'DD/MM/YYYY').toDate()
				var headerarrDateVal = moment(calendar_arrDate).format("DD MMM")
				var arr_daytxt = moment(calendar_arrDate).format('ddd')
				$('#rtn_date_mob').datepicker("setDate",moment(calendar_arrDate).format("DD MMM"))
				$('div.m-round-arr .m-date-rtn-txt').text(headerarrDateVal.split(" ")[0])
				$('div.m-round-arr .m-rtn-month').text(headerarrDateVal.split(" ")[1])
				$('#form_rtn_date').val(moment(calendar_arrDate).format("DD/MM/YYYY"))
				$('div.m-round-dep .m-rtn-day').text(dep_daytxt)
				$('#mob_rnd_trip').prop('checked',true)
				$('div.ar-date').show();
				$('div.ar-date').removeClass('hide');
			}
		}else{
			var dep_daytxt = moment().add(2,'days').format('ddd')
			var ret_daytxt = moment().add(4,'days').format('ddd')
			$('#dpt_date_mob').datepicker("setDate",moment().add(2,'days').format("DD MMM"))
			$('#rtn_date_mob').datepicker("setDate",moment().add(4,'days').format("DD MMM"))
			$('#form_dep_date').val(moment().add(2,'days').format("DD/MM/YYYY"))
			$('#form_rtn_date').val(moment().add(4,'days').format("DD/MM/YYYY"))
			$('span.dep_text').text(dep_daytxt)
			$('span.ret_text').text(ret_daytxt)
		}
		
		$("#button_flight_search_mob").on("click",function(e) {
			e.preventDefault();
			if($("input[name='rnd_one']:checked").val() == "O") {
				ret_val = $("#rtn_date_mob").val();    
				$("#rtn_date").val("")
			}
				// uncomment validation
				// if($('#origin_autocomplete_mob').val() === "" || $('#destination_autocomplete_mob').val() ===""){
				// 	return false
				// }
				var dep_date = $('#form_dep_date').val();
				var arr_date = ""
				var trip = $("input[name='rnd_one']:checked").val();
				trip = trip == "rnd" ? "R" : "O"
				if(trip == "R"){
					arr_date = $('#form_rtn_date').val();
				}
				var adult_count = $('form').find('input[name="adults"]').val()
				var child_count = $('form').find('input[name="childs"]').val()
				var infants_count = $('form').find('input[name="infants"]').val()
				var travell_class = $("#travell-class").val()
				var from = $('.from').val() != "" ? $('.from').val() : "DEL"
				var to = $('.to').val() != "" ? $('.to').val() : "BLR"
				var query_string = "from=" + from +"&to=" + to + "&trip=" + trip  + "&dep_date=" + dep_date + "&arr_date=" + arr_date + "&adult_count=" + adult_count + "&child_count=" + child_count + "&infants_count=" + infants_count + "&travell_class=" + travell_class + "&utm_source=schedule_route&utm_medium=search_widget&utm_campaign=srp_one_load"; 
				$.ajax({

					url: "/flight-schedule/get_search_url.html?" + query_string,
					type: 'post',
					async: true,
					beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));$("#loaders").css("display","block"),$("#spinner").css("display","block")},
					data: {"from": from,"to": to,"country_code": country_code,"is_mobile": is_mobile,"section": section_type },
					error: function(data){
						return true;
					},
					success: function(data){ 
						window.location.replace(data.url_format+"?"+query_string)
					}})
			});


		$('.click-block').on('click',function(e){
			var selectedClass = $("select#travell-class").children("option:selected").val();
			let travel_text =""
			var adultCount = parseInt($(this).closest('ul').find('.adult-count').text());
			$('.adultsNumber').text(adultCount)
			var childrenCount = parseInt($(this).closest('ul').find('.child-count').text());
			$('.childNumber').text(childrenCount)
			var infantCount  = parseInt($(this).closest('ul').find('.infant-count').text());
			$('.infantsNumber').text(infantCount)
			travel_text = adultCount+childrenCount+infantCount
			let add_plural = false
			if(parseInt(travel_text) <10){
				if(travel_text <= 1){
					add_plural = true
				}
				travel_text ="0"+travel_text
			}
			if(location.href.includes("/ar/")){
				$('.totTravellers').text(travel_text+" مسافرين")
			}else{

				if(add_plural){
					$('.totTravellers').text(travel_text+" Traveller")
					$(".f-class-details").text(selectedClass+" | " + travel_text+" Traveller")
				}else{
					$('.totTravellers').text(travel_text+" Travellers");
					$(".f-class-details").text(selectedClass+" | "+travel_text+" Travellers")
				}
			}
		});

		$("select#travell-class").change(function(){
			var selectedClass = $(this).children("option:selected").val();
			var travell_count = $('.totTravellers').text();
			$(".f-class-details").text(selectedClass+" | "+ travell_count)
		})

		function radioBtnHandle(){
			if($(".moile_radioBtn input[name='rnd_one']:checked").val() == 'rnd' || $(".moile_radioBtn input[name='rnd_one']:checked").val() == 'R'){
				var minDate = $("#dpt_date_mob").datepicker("getDate");
				var highlight = $("#dpt_date_mob").datepicker("getDate");
				$("#dpt_date_mob").val(moment(minDate).format("DD MMM"));
				$('#form_dep_date').val(moment(minDate).format("DD/MM/YYYY"))
				var dep_daytxt = moment(minDate).format("ddd")
				$('span.dep_text').text(dep_daytxt)
				if(minDate){
					minDate.setDate(minDate.getDate() + 1);
					$("#rtn_date_mob").val(moment(minDate).format("DD MMM"));
					$('#rtn_date_mob').datepicker('setDate', highlight);
					$('#rtn_date_mob').datepicker('option', 'minDate', highlight);
					$('div.ar-date').removeClass('hide')
					$("#rtn_date_mob").val(moment(minDate).format("DD MMM"))
					$('#form_rtn_date').val(moment(minDate).format("DD/MM/YYYY"))
				}
				var ret_text = moment(minDate).format("ddd")
				$('span.ret_text').text(ret_text)
			}else{
				$('div.ar-date').addClass('hide')
			}
		}

		$('.moile_radioBtn').click(function(){
			$(this).find('input').prop('checked',true)
			radioBtnHandle()
		})

		if(is_mobile){
			$('ul.depAutoCompleteCities,ul.arrAutoCompleteCities').on('click','li',function(ele,i){
				autocompleteType = $(this).closest("div").attr('class').split(" ")[1]
				if(autocompleteType == "depCity"){
					city_code = $(this).find('span.city_code').text()
					city_name = $(this).find('span.city_name').text().split(",")[0]
					from_country = extractCountry($(this).find('span.city_name').text())
					$('.from').val(city_code)
					$('div.depart-city span.city_code').text(city_code)
					dep_city_name =  extractCityName($(this).find('span.city_name').text())
					dep_city_code = city_code
					dep_code = city_code
					$('.fromCityName').text(dep_city_name)
					$('.origin_autocomplete_mob').val(dep_city_name)
					$('#fromCityAutocompleteModel .close.ao-sw-btn').trigger('click')
				}else{
					city_code = $(this).find('span.city_code').text()
					city_name = $(this).find('span.city_name').text().split(",")[0]
					to_country = extractCountry($(this).find('span.city_name').text())
					$('.to').val(city_code)
					$('div.arrival-city span.city_code').text(city_code)
					arr_city_name =  extractCityName($(this).find('span.city_name').text())
					arr_city_code = city_code
					arr_code = city_code
					$('.toCityName').text(arr_city_name)
					$('.destination_autocomplete_mob').val(arr_city_name)
					$('#toCityAutocompleteModel .close.ao-sw-btn').trigger('click')
				}
			})
			$('#m-search-widget li a.one_way').trigger('click')
			$('#AirSearchMob').find('input[name="adults"]').val("1")
			$('ul.cityAutoCompleteData li').click(function(ele,i){
				autocompleteType = $(this).closest("div").attr('class').split(" ")[1]
				if(autocompleteType == "depCity"){
					city_code = $(this).find('span.city_code').text()
					from_country = extractCountry($(this).find('span.city_name').text())
					city_name = $(this).find('span.city_name').text().split(",")[0]
					$('p.fromCity').hide()
					$('.from').val(city_code)
					dep_city_name =  extractCityName($(this).find('span.city_name').text())
					$('.fromCityName').text(dep_city_name)
					dep_city_code = city_code
					dep_code = city_code
					$('p.origin_autocomplete_dots').addClass("hide")
					$('.origin_autocomplete_mob').removeClass("hide")
					$('.origin_autocomplete_mob').val(dep_city_name)
					$('.depart-city span.city_code').text(city_code)
					$('#fromCityAutocompleteModel .close.ao-sw-btn').trigger('click')
				}else{
					city_code = $(this).find('span.city_code').text()
					city_name = $(this).find('span.city_name').text().split(",")[0]
					to_country = extractCountry($(this).find('span.city_name').text())
					arr_city_name =  extractCityName($(this).find('span.city_name').text())
					arr_city_code = city_code
					arr_code = city_code
					$('.toCityName').text(arr_city_name)
					$('p.toCity').hide()
					$('.to').val(city_code)
					$('p.destination_autocomplete_dots').addClass("hide")
					$('.destination_autocomplete_mob').removeClass("hide")
					$('.destination_autocomplete_mob').val(arr_city_name)
					$('.arrival-city span.city_code').text(city_code)
					$('#toCityAutocompleteModel .close.ao-sw-btn').trigger('click')
				}
			})
			// if(section_type && section_type === 'international'){
			// 	$("#mob_rnd_trip").attr('checked', true)
			// 	$('div.ar-date').removeClass('hide')
			// }else{
			// 	$('div.ar-date').addClass('hide')
			// 	$("#mob_one_way").attr('checked', true)
			// }
		}

		function errorNotification(errorMsg){
			$('.mob_errors_container .error-msg').text(errorMsg);
			$('.mob_errors_container').fadeIn();
			$("html, body").animate({ scrollTop: 0 }, "slow");
			setTimeout(function(){
				$('.mob_errors_container').fadeOut(500);
			},1500);
		}
		function close_error_msg(){
			$('.mob_errors_container').fadeOut(500);
		}

		function extractCITY(str) {
			var regex = /.*\(([A-Z]*)\)$/;
			if (str) {
				return str.match(regex)[1]
			}
		}

		function extractCountry(str) {
			var regex = /.+, ([A-Z]{2}) - .+/;
			if (str) {
				return str.match(regex)[1]
			}
		}

		function extractCityName(str) {
			if (str) {
				city_name = str.replace(/\s*\(.*?\)\s*/g, '');
				return city_name
			}
		}

		function parseAutoCmp(data) {
			if (location.href.includes("/ar/")) {
				data = data.map(function(item) {
					item = {
						k: item.code,
						v: item.arabic[0]
					};
					return item
				})
			} else {
				data = data.map(function(item) {
					item = {
						k: item.k,
						v: item.v
					};
					return item
				})
			}
			return data
		};
		//decodeing the url params
		function QueryStringToJSON() {    
			let params = location.search.slice(1).split('&');
			let result = {};
			params.forEach(function(pair) {
				pair = pair.split('=');
				result[pair[0]] = decodeURIComponent(pair[1].replace(/\+/g, '%20') || '');
			});
			return JSON.parse(JSON.stringify(result));
		}
	})

