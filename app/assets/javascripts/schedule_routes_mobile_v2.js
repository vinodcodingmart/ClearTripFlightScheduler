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
	if(is_mobile){
		// toggle functionality of routes
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
		 var no_months = isMobile.any() ? 1 : 2;
		 var step_months = isMobile.any()? 1 :2;
		 $('#dpt_date_mob').datepicker({
		 	minDate: 0,
		 	dateFormat: "dd M",
		 	numberOfMonths: no_months,
		 	showButtonPanel:true,
		 	closeText:'X',
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
		var dep_daytxt = moment().add(2,'days').format('ddd')
		var ret_daytxt = moment().add(4,'days').format('ddd')
		$('#dpt_date_mob').datepicker("setDate",moment().add(2,'days').format("DD MMM"))
		$('#rtn_date_mob').datepicker("setDate",moment().add(4,'days').format("DD MMM"))
		$('#form_dep_date').val(moment().add(2,'days').format("DD/MM/YYYY"))
		$('#form_rtn_date').val(moment().add(4,'days').format("DD/MM/YYYY"))
		$('span.dep_text').text(dep_daytxt)
		$('span.ret_text').text(ret_daytxt)

		$("#button_flight_search_mob").on('click',function(e) {
			e.preventDefault()
			if(is_mobile && $(".moile_radioBtn input[name='rnd_one']:checked").val() == 'one' || $(".moile_radioBtn input[name='rnd_one']:checked").val() =="O" ){
				$(".moile_radioBtn input[name='rnd_one']:checked").val('O')
				$('#form_rtn_date').val("")
			}else{
				$(".moile_radioBtn input[name='rnd_one']:checked").val('R')
			}
			var frm_val =$('.origin_autocomplete_mob').val()
			var err_msg =''
			if(!frm_val){
				err_msg = "Please enter departure city name"
				errorNotification(err_msg)
				return false
			}
			var to_val = $('.destination_autocomplete_mob').val()
			if(!to_val){
				err_msg = "Please enter arrival city name"
				errorNotification(err_msg)
				return false
			}
			if($('.from').val() == $('.to').val()){
				err_msg = "Your origin destination cities are same"
				errorNotification(err_msg)
				$('.from').val("")
				$('.to').val("")
				return false
			}
			$('.from').val($('.from').val().trim())
			$('.to').val($('.to').val().trim())
			this.form.target = "_self";
			var international_link = (from_country.toLowerCase() != country_code || to_country.toLowerCase() != country_code) ? "international/" : "";
			if (isMobile.any()) {
				domains = ["www.cleartrip.com"];
				if (location.hostname != (domains.indexOf(location.hostname) >= 0)) {
					if (from_country.toLowerCase() == "in" && to_country.toLowerCase() == "in") {
						var international_link = ""
					} else {
						var international_link = "international/"
					}
				} else {
					var international_link = "international/"
				}
				if (typeof international_link == "undefined") {
					var international_link = "international/"
				}
				$(this).closest("form").append("<input type='hidden' name='mobile' value='true'>");

				if (languageType == "ar" && $.inArray(location.hostname, arDomains) >= 0) {
					this.form.action = "/ar/m/flights/" + international_link + "results"
				} else {
					this.form.action = "/m/flights/" + international_link + "results"
				}
			} else {
				if (languageType == "ar" && $.inArray(location.hostname, arDomains) >= 0) {
					this.form.action = "/ar/flights/" + international_link + "results"
				} else {
					this.form.action = "/flights/" + international_link + "results"
				}
			}
			$(this).closest("form").append("<input type='hidden' name='page' value='loaded' />");
			$(this).closest("form").append('<input type="hidden" name="from_header" id="from_header" value="'+dep_city_name+'"/>');
			$(this).closest("form").append('<input type="hidden" name="to_header" id="to_header" value="'+arr_city_name+'"/>');
			if(typeof country_code != 'undefined' && (country_code == 'IN'  || country_code == 'in' || country_code == 'SA' || country_code == 'sa')){
				$(this).closest("form").append("<input type='hidden' name='utm_campaign' id='utm_campaign' value="+'seo_'+page_type+'_page_search_button'+"/>");
				$(this).closest("form").append("<input type='hidden' name='utm_source' id='utm_source' value='google'/>");
				$(this).closest("form").append("<input type='hidden' name='utm_medium' id='utm_medium' value='organic'/>");
			}
			this.form.submit();
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
				if(travel_text <=1){
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
			var travel_textt = $('.totTravellers').val();
			$(".f-class-details").text(selectedClass+" | "+ travel_textt +" Travellers")
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
			$('#travellerModal span.adult-count').text("1")
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
			if(section_type && section_type === 'international'){
				$("#mob_rnd_trip").attr('checked', true)
				$('div.ar-date').removeClass('hide')
			}else{
				$('div.ar-date').addClass('hide')
				$("#mob_one_way").attr('checked', true)
			}
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
	})