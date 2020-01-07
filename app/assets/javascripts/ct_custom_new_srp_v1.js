$(function(){
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
	var is_mobile = isMobile.any() ? true : false
	var context = window.masterJson && window.masterJson.routes && window.masterJson.routes.length > 0 ? window.masterJson.routes : {}
	var afterFilterObj = window.masterJson && window.masterJson.routes && window.masterJson.routes.length > 0 ? window.masterJson.routes : []
	var available_airlines = window.masterJson &&  window.masterJson.available_airlines ?  window.masterJson.available_airlines : {}
	var start_scroll = 0
	var end_scroll = 10
	var applied_filters = {hop_filter:[],depart_time_filter:[],arrival_time_filter:[],more_filters:[],carrier_filter:[],price_filter:[]}
	var infiScroll =[]
	var onword_routes = []
	var return_routes = []
	var onwardAfterFilterObj =[]
	var returnAfterFilterObj =[]
	let params = new URLSearchParams(window.location.search)
	var is_rndtrip = params && params.get("trip") == "R" ? true : false
	if(is_rndtrip && context && context.length >0){
		onword_routes=context[0] && context[0]["onward"] ? context[0]["onward"] : []
		return_routes = context[0] && context[0]["return"] ? context[0]["return"] : []
		onwardAfterFilterObj = onword_routes
		returnAfterFilterObj = return_routes
	}
	var stops = {non_stop:0,one_stop:1,two_stops:2}
	var more_init = {dRefundable:'refundable',dMeals:'meals',dHbag:'hbag'}
	var time_init = ["00:00-06:00","06:00-12:00","12:00-18:00","18:00-00:00"]
	$('.book_button').removeClass('disabled')
	$('.overlap-container').hide()
	Handlebars.registerHelper('iff', function (v1, operator, v2, options) {
		switch (operator) {
			case '==':
			return (v1 == v2) ? options.fn(this) : options.inverse(this);
			case '===':
			return (v1 === v2) ? options.fn(this) : options.inverse(this);
			case '!=':
			return (v1 != v2) ? options.fn(this) : options.inverse(this);
			case '!==':
			return (v1 !== v2) ? options.fn(this) : options.inverse(this);
			case '<':
			return (v1 < v2) ? options.fn(this) : options.inverse(this);
			case '<=':
			return (v1 <= v2) ? options.fn(this) : options.inverse(this);
			case '>':
			return (v1 > v2) ? options.fn(this) : options.inverse(this);
			case '>=':
			return (v1 >= v2) ? options.fn(this) : options.inverse(this);
			case '&&':
			return (v1 && v2) ? options.fn(this) : options.inverse(this);
			case '||':
			return (v1 || v2) ? options.fn(this) : options.inverse(this);
			default:
			return options.inverse(this);
		}
	})
	Handlebars.registerHelper('eachData', function(context, options) {
		var fn = options.fn, inverse = options.inverse, ctx;
		var ret = "";

		if(context && context.length > 0) {
			for(var i=0, j=context.length; i<j; i++) {
				ctx = Object.create(context[i]);
				ctx.index = i;
				ret = ret + fn(ctx);
			}
		} else {
			ret = inverse(this);
		}
		return ret;
	})

	function rndMobilePriceChange(){
		$('.rwd-flights-list').click(function(){
			let curr_cls = $(this).parent('div').attr('class')
			if(is_rndtrip && is_mobile){
				if(curr_cls == "rwd-lhs"){
					if(!$(this).hasClass(".lhs-selected")){
						$('div.rwd-lhs .rwd-flights-list').removeClass('lhs-selected')
						$(this).addClass('lhs-selected')
					}
				}else if(curr_cls == "rwd-rhs"){
					if(!$(this).hasClass(".rhs-selected")){
						$('div.rwd-rhs .rwd-flights-list').removeClass('rhs-selected')
						$(this).addClass('rhs-selected')
					}
				}
				let lhs_info = $('.rwd-lhs .lhs-selected').data("info")
				let rhs_info = $('.rwd-rhs .rhs-selected').data("info")
				let lhs_price = 0
				let rhs_price = 0
				if(lhs_info){
					lhs_price = lhs_info.split("_").reverse()[0]
				}
				if(rhs_info){
					rhs_price = rhs_info.split("_").reverse()[0]
				}
				let counter_price = (parseInt(lhs_price)+parseInt(rhs_price))
				$({counter: 0}).animate({counter: parseInt(counter_price)}, {
					duration: 300,
					easing:'swing',
					step: function(now) {  
						let amt = inrConverter(Math.ceil(now))
						$('#best-price-mob').html("")
						$('#best-price-mob').append("₹ "+ amt +"<span class='m-book-fi'>Cheapest Fare </span>")
					}
				})
			}
		})
	}

	function rndDesktopPriceChange(){
		$('.rwd-desk-flights-list').click(function(){
			let curr_cls = $(this).parent('div').attr('class')
			$(this).find('input').prop('checked','checked')
			let dep_row = {}
			let arr_row = {}
			if(curr_cls == "rwd-desk-lhs"){
				$('div.rwd-desk-lhs .rwd-desk-flights-list').removeClass('lhs-desk-selected')
				$(this).addClass('lhs-desk-selected')
				let lhs_info = $(this).data('info')
				if(onword_routes.length > 0){
					let row = _.find(onword_routes,function(o,i){
						if(o["unique_flight_key"] == lhs_info){
							return o
						}
					})
					if(Object.keys(row).length > 0){
						dep_row = row
						row["tripType"] = "onward"
						var template = Handlebars.compile($('#rndDeskSelectedCrd').html())
						var tpl = template(row)
						$('#owd-flight-api .depart-details').html(tpl)
					}
				}
				
			}else if(curr_cls == "rwd-desk-rhs"){
				$('div.rwd-desk-rhs .rwd-desk-flights-list').removeClass('rhs-desk-selected')
				$(this).addClass('rhs-desk-selected')
				let rhs_info = $(this).data('info')
				
				if(return_routes.length > 0){

					let row = _.find(return_routes,function(o,i){
						if(o["unique_flight_key"] == rhs_info){
							return o
						}
					})
					if(Object.keys(row).length > 0){
						arr_row = row
						row["tripType"] = "return"
						var template = Handlebars.compile($('#rndDeskSelectedCrd').html())
						var tpl = template(row)
						$('#owd-flight-api .arrival-details').html(tpl)
					}
				}
			}
			let lhs_info = $('div.rwd-desk-lhs .rwd-desk-flights-list.lhs-desk-selected').data("info")
			let rhs_info = $('div.rwd-desk-rhs .rwd-desk-flights-list.rhs-desk-selected').data("info")
			let lhs_price = 0
			let rhs_price = 0
			let lhs_book_url = $('div.rwd-desk-lhs .rwd-desk-flights-list.lhs-desk-selected').data("depbookurl")
			let rhs_book_url = $("div.rwd-desk-rhs .rwd-desk-flights-list.rhs-desk-selected").data("retbookurl")
			if(lhs_info){
				lhs_price = lhs_info.split("_").reverse()[0]
			}else{
				lhs_price = $('div.cta-sticky .depart-details ul').data("price")
			}
			if(rhs_info){
				rhs_price = rhs_info.split("_").reverse()[0]
			}else{
				rhs_price = $('div.cta-sticky .arrival-details ul').data("price")
			}
			let counter_price = (parseInt(lhs_price)+parseInt(rhs_price))
			$({counter: 0}).animate({counter: parseInt(counter_price)}, {
				duration: 300,
				easing:'swing',
				step: function(now) {
					let amt = inrConverter(Math.ceil(now))
					$('#rndTripRouteTotalFareDesk').text("₹ "+amt)
				}
			})
			if(!is_mobile){
				setTimeout(function(){
					console.log("entered")
					let onword_arr = $('.bestprice-card-onward ul').data("arrdate")
					let return_dep = $('.bestprice-card-return ul').data("depdate")
					if(onword_arr && return_dep){
						let onarr_date = onword_arr.split('-')[0]
						let onarr_time = onword_arr.split('-')[1]
						let retdep_date = return_dep.split('-')[0]
						let retdep_time = return_dep.split('-')[1]
						if(onarr_date == retdep_date){
							var beginningTime = moment(onarr_time, 'HH:mm');
							var endTime = moment(retdep_time, 'HH:mm');
							if(beginningTime.isBefore(endTime)){
								console.log("overlapped")
								$('.book_button').addClass('disabled')
								$('.overlap-container').show()
							}
						}else{
							$('.book_button').removeClass('disabled')
							$('.overlap-container').hide()
						}
					}
				},1000)
			}
		})
	}
	function stopsFilter(stop_name){
		let obj = is_rndtrip ? onword_routes : context
		let no_of_stops = _.filter(obj,function(v,i){
			return v["no_of_stops"] == stops[stop_name]
		})
		if(no_of_stops.length==0){
			$('li.'+stop_name).addClass('disabled')
		}
	}
	function timeIntialize(){
		let obj = is_rndtrip ? onword_routes : context
		_.each(time_init,function(v,k){
			start = moment(v.split("-")[0],"HH:mm")
			end = moment(v.split("-")[1],"HH:mm")
			let dep_count =  _.filter(obj,function(st,k){
				let route_dep_time =  moment(st["dep_time"],"HH:mm")
				if(route_dep_time.isBetween(start, end)){
					return st
				}
			})
			if(dep_count.length == 0){
				$("div.depart_time_filter ul").find("[data-time='" + v + "']").addClass('disabled')
			}
			let arr_count =  _.filter(obj,function(st,k){
				let route_arr_time =  moment(st["arr_time"],"HH:mm")
				if(route_arr_time.isBetween(start, end)){
					return st
				}
			})
			if(arr_count.length == 0){
				$("div.arrival_time_filter ul").find("[data-time='" + v + "']").addClass('disabled')
			}
		})
	}
	function availAirlines(){
		$.each(available_airlines, function (i, row) {
			if(i == 0){
				$('.carrier_filter ul li').remove()
			}
			var template = Handlebars.compile($('#available-airlines').html())
			var tpl = template(row)
			$('.carrier_filter ul').append(tpl)
		})
	}


	function hop_flter(applied_filters,routes,fil_val){
		let temp =[]
		_.each(applied_filters[fil_val],function(st,i){
			let obj = _.filter(routes,function(v,k){
				if(v["no_of_stops"] == stops[st]){
					return v
				}
			})
			temp = temp.concat(obj)
		})
		return temp
	}

	function timeFilterRnd(applied_filters,routes,fil_val){
		let temp =[]
		_.each(applied_filters[fil_val],function(st,i){
			let obj = _.filter(routes,function(v,k){
				let start = moment(st.split("-")[0],"HH:mm")
				let end = moment(st.split("-")[1],"HH:mm")
				if(is_rndtrip && fil_val =="arrival_time_filter"){
					var check_time = moment(v["dep_time"],"HH:mm") 
				}else{
					var check_time = fil_val == "depart_time_filter" ?  moment(v["dep_time"],"HH:mm") :  moment(v["arr_time"],"HH:mm")
				}
				if(check_time.isBetween(start, end)){
					return v
				}
			})
			temp = temp.concat(obj)
		})
		return temp
	}

	function moreFilterRnd(applied_filters,routes,fil_val){
		let temp =[]
		let obj_val ={dRefundable:'refundable',dMeals:'meals',dHbag:'hbag'}
		_.each(applied_filters[fil_val],function(st,i){
			let obj =  _.filter(routes,function(v,k){
				if(v[obj_val[st]]){
					return v
				}
			})
			temp = temp.concat(obj)
		})
		return temp
	}

	function priceFilterRnd(applied_filters,routes,fil_val){
		let temp =[]
		let obj =_.filter(routes,function(v,k){
			if(v['route_total_fare'] <= slideFromPrice){
				return v
			}
		})
		return obj
	}

	function carrierFilterRnd(applied_filters,routes,fil_val){
		let temp =[]
		_.each(applied_filters[fil_val],function(st,i){
			let obj =  _.filter(routes,function(v,k){
				if(v["dep_flight_key_format"].split("-")[0] == st){
					return v
				}
			})
			temp = temp.concat(obj)
		})
		return temp
	}


	function rndApplyFilters(){
		var onwardFilterObj = onword_routes
		var returnFilterObj = return_routes
		let reset_filter = true
		_.each(Object.keys(applied_filters),function(k,i){
			if(applied_filters[k].length >0){
				reset_filter = false
				if(k == "hop_filter"){
					onwardFilterObj = hop_flter(applied_filters,onwardFilterObj,k)
					returnFilterObj = hop_flter(applied_filters,returnFilterObj,k)
				}
				if(k == "depart_time_filter"){
					onwardFilterObj = timeFilterRnd(applied_filters,onwardFilterObj,k)
				}
				if(k == "arrival_time_filter"){
					returnFilterObj = timeFilterRnd(applied_filters,returnFilterObj,k)
				}
				if(k == 'more_filters'){
					onwardFilterObj = moreFilterRnd(applied_filters,onwardFilterObj,k)
					returnFilterObj = moreFilterRnd(applied_filters,returnFilterObj,k)
				}
				if(k == 'price_filter'){
					onwardFilterObj = priceFilterRnd(applied_filters,onwardFilterObj,k)
					returnFilterObj = priceFilterRnd(applied_filters,returnFilterObj,k)
				}
				if(k == 'carrier_filter'){
					onwardFilterObj = carrierFilterRnd(applied_filters,onwardFilterObj,k)
					returnFilterObj = carrierFilterRnd(applied_filters,returnFilterObj,k)
				}
			}
			if(reset_filter){
				$('div.lhs a.reset_filter').css('display','none')
			}else{
				$('div.lhs a.reset_filter').css('display','block')
			}
		})
		if(onwardFilterObj.length > 0){
			onwardAfterFilterObj = onwardFilterObj
			if(is_mobile){
				$('.emptyCardRndTripMobile').hide()
				onwardFilterObj = _.sortBy(_.sortBy(onwardFilterObj,function(o){return moment(o.dep_time,"HH:mm")}),'route_total_fare')
				_.each(onwardFilterObj,function(row,i){
					row["selectedcls"]= ""
					if(i==0){
						$('#rwd-mobile-flights .rwd-lhs .rwd-flights-list').remove()
						row["selectedcls"] = "lhs-selected"
					}
					let template =Handlebars.compile($('#mobileRndTripCardTpl').html())
					let tpl = template(row)
					$('#rwd-mobile-flights .rwd-lhs').append(tpl)
				})
				rndMobilePriceChange()
				$('div.rwd-lhs .rwd-flights-list.lhs-selected').trigger('click')
			}else{
				$('div.emptyCardRndtriplhs').hide()
				onwardFilterObj = _.sortBy(_.sortBy(onwardFilterObj,function(o){return moment(o.dep_time,"HH:mm")}),'route_total_fare')
				_.each(onwardFilterObj,function(row,i){
					row["selectedcls"] =""
					row['is_last'] = ""
					if(i==0){
						$('div.rwd-desk-lhs .rwd-desk-flights-list').remove()
						row["selectedcls"] = "lhs-desk-selected"
					}
					row["index"] = i
					row['is_last'] = i == onwardFilterObj.length -1 ? 'last' : ''
					let template = Handlebars.compile($('#fsRndTripRouteCardTpl').html())
					row["trip"] = "onwrd_trip"
					let tpl = template(row)
					$('div.rwd-desk-lhs').append(tpl)
				})
				rndDesktopPriceChange()
				$('div.rwd-desk-lhs .rwd-desk-flights-list.lhs-desk-selected').trigger('click')
			}
		}else{
			if(is_mobile){
				$('#rwd-mobile-flights .rwd-lhs .rwd-flights-list').remove()
				$('.emptyCardRndTripMobile').show()
			}else{
				$('div.emptyCardRndtriplhs').show()
				$('div.rwd-desk-lhs .rwd-desk-flights-list').remove()
			}
			onwardAfterFilterObj = []
		}

		if(returnFilterObj.length > 0){
			returnAfterFilterObj = returnFilterObj
			if(is_mobile){
				$('.emptyCardRndTripMobile').hide()
				returnFilterObj = _.sortBy(_.sortBy(returnFilterObj,function(o){return moment(o.dep_time,"HH:mm")}),'route_total_fare')
				_.each(returnFilterObj,function(row,i){
					row["selectedcls"]= ""
					if(i==0){
						$('#rwd-mobile-flights .rwd-rhs .rwd-flights-list').remove()
						row["selectedcls"] = "rhs-selected"
					}
					let template =Handlebars.compile($('#mobileRndTripCardTpl').html())
					let tpl = template(row)
					$('#rwd-mobile-flights .rwd-rhs').append(tpl)
				})
				rndMobilePriceChange()
				$('div.rwd-rhs .rwd-flights-list.rhs-selected').trigger('click')
			}else{
				$('div.emptyCardRndtriplhs').hide()
				returnFilterObj = _.sortBy(_.sortBy(returnFilterObj,function(o){return moment(o.dep_time,"HH:mm")}),'route_total_fare')
				_.each(returnFilterObj,function(row,i){
					row["selectedcls"] = ""
					row['is_last'] = ''
					if(i==0){
						$('div.rwd-desk-rhs .rwd-desk-flights-list').remove()
						row["selectedcls"] = "rhs-desk-selected"
					}
					let template = Handlebars.compile($('#fsRndTripRouteCardTpl').html())
					row["index"] = i
					row['is_last'] = i == returnFilterObj.length -1 ? 'last' : ''
					row["trip"] = "return_trip"
					let tpl = template(row)
					$('div.rwd-desk-rhs').append(tpl)
				})
				rndDesktopPriceChange()
				$('div.rwd-desk-rhs .rwd-desk-flights-list.rhs-desk-selected').trigger('click')
			}
		}else{
			if(is_mobile){
				$('#rwd-mobile-flights .rwd-rhs .rwd-flights-list').remove()
				$('.emptyCardRndTripMobile').show()
			}else{
				$('div.rwd-desk-rhs .rwd-desk-flights-list').remove()
				$('div.emptyCardRndtriplhs').show()
			}
			returnAfterFilterObj=[]
		}
	}


	function appliedFilterData(){
		$('.lhs-cards ul li,.mfilter-wrapper ul li').click(function(){
			start_scroll = 0
			end_scroll = 10
			$('.reset_filter').show()
			$(this).find('a').toggleClass('filter-checked')
			$(this).closest('li').toggleClass('f-active')
			let filter_name = $(this).parent().closest('div').attr('class').split(' ')[1]
			let filter_val = ""
			if(filter_name == "depart_time_filter" || filter_name == "arrival_time_filter"){
				filter_val = $(this).data('time')
			}
			else if(filter_name == "more_filters"){
				filter_val = $(this).attr('class')
				if(filter_val == "dRefundable f-active"){
					filter_val = "dRefundable"
				}
			}else if(filter_name == "carrier_filter"){
				filter_val = $(this).find('input').attr('id')
			}else{
				filter_val = $(this).attr('class').split(' ')[1]
			}
			if(is_mobile){
				if($(this).find('input').is(':checked')){
					if(applied_filters[filter_name].indexOf(filter_val) ==-1){
						applied_filters[filter_name].push(filter_val)
					}
				}else{
					applied_filters[filter_name] = _.without(applied_filters[filter_name],filter_val)
				}

			}else{
				if(($(this).find('a').length > 0 && $(this).find('a').attr("class") !="") || ($(this).find('input').length > 0 && $(this).find('input').is(':checked'))){
					if(applied_filters[filter_name].indexOf(filter_val) ==-1){
						applied_filters[filter_name].push(filter_val)
					}
				}else{
					applied_filters[filter_name] = _.without(applied_filters[filter_name],filter_val)
				}
				if(is_rndtrip){
					rndApplyFilters()
				}else{
					applyFilters()
				}
			}
		})
	}
	if(!$.isEmptyObject(context)){
		var slideFromPrice = 0
		var slideToPrice = 0
		let obj = is_rndtrip ? onword_routes : context
		var min_fare = _.min(obj, function(o){return o.route_total_fare})["route_total_fare"];
		var max_fare = _.max(obj, function(o){return o.route_total_fare;})["route_total_fare"]
		$('span.price-left').text("₹"+min_fare)
		$('span.price-right').text("₹"+max_fare)
		_.each(Object.keys(stops),function(s,i){
			stopsFilter(s)
		})
		let my_range = $(".js-range-slider").data("ionRangeSlider");
		my_range.update({
			min: min_fare,
			max: max_fare,
			from: max_fare,
			prefix: "upto ₹ ",
			hide_min_max:true,
			skin:'big',
			onFinish:function(data){
				slideFromPrice = data.from
				slideToPrice = data.to
				applied_filters['price'] = applied_filters['price_filter'].length == 0 ? applied_filters['price_filter'].push("price") : []
				if(is_rndtrip){
					if(!is_mobile){
						rndApplyFilters()
					}
				}else{
					applyFilters()
				}
			}
		});
	}
	function sortFilter(){
		$('.sort_filter .time input:radio,.sort_filter .duration input:radio,.sort_filter .price input:radio').click(function(){
			let filter_value = $(this).val()
			if (!is_rndtrip){
				let filter_obj = afterFilterObj
				filter_obj = objSort(filter_obj,filter_value)
				infiScroll = filter_obj
				start_scroll = 0
				end_scroll = 10
				if(is_mobile) {
					mobileTpl(filter_obj) 
							// $('#nd-mobilesort').modal('toggle');
							// oneWayRedirectItenory()
						}
				}
			else{
				let one_way_obj = onwardAfterFilterObj
				let two_way_obj = returnAfterFilterObj
				one_way_obj = objSort(one_way_obj,filter_value)
				two_way_obj = objSort(two_way_obj,filter_value)
				rndMobSortTpl(one_way_obj,"onword")
				rndMobSortTpl(two_way_obj,"return")

			}
					function objSort(object_to_sort,filter_value){
						if(object_to_sort.length > 0){
							if(filter_value == "time_asc"){
								return object_to_sort = _.sortBy(object_to_sort,function(o){return moment(o.dep_time,"HH:mm")})
							}
							else if(filter_value == "time_des"){
								return object_to_sort = _.sortBy(object_to_sort,function(o){return moment(o.dep_time,"HH:mm")}).reverse()
							}
							else if(filter_value == "duration_asc"){
								return object_to_sort = _.sortBy(object_to_sort,function(o){return o.formated_duration})
							}
							else if(filter_value == "duration_des"){
								return object_to_sort = _.sortBy(object_to_sort,function(o){return o.formated_duration}).reverse()
							}
							else if(filter_value == "price_asc"){
								return object_to_sort = _.sortBy(object_to_sort,function(o){return o.route_total_fare})
							}
							else if(filter_value == "price_des"){
								return object_to_sort = _.sortBy(object_to_sort,function(o){return o.route_total_fare}).reverse()
							} 
							// else if (filter_value == undefined)
							else
							{
								return object_to_sort = afterFilterObj

							}
						}
					}
				})
		$(".clear-sort-filter-mob").click(function(){
			$(".sort-filter input").removeAttr('checked')
			// $('.sort-btn').trigger('click')
			mobileTpl(afterFilterObj)
			$('#nd-mobilesort').modal('toggle');
		})

		$(".sort-btn").click(function(){
			$('#nd-mobilesort').modal('toggle');
		})
	}
	sortFilter()
	function applyFilters(){
		start_scroll = 0
		end_scroll = 10
		infiScroll = []
		var filteredObj = context
		let reset_filter = true
		_.each(Object.keys(applied_filters),function(val,key){
			if(applied_filters[val].length >0){
				reset_filter = false
				if(val == "hop_filter"){
					let temp =[]
					_.each(applied_filters[val],function(st,i){
						let obj = _.filter(filteredObj,function(v,k){
							if(v["no_of_stops"] == stops[st]){
								return v
							}
						})
						temp = temp.concat(obj)
					})
					filteredObj = temp
				}
				if(val == "depart_time_filter" || val == "arrival_time_filter"){
					let temp =[]
					_.each(applied_filters[val],function(st,i){
						let obj = _.filter(filteredObj,function(v,k){
							let start = moment(st.split("-")[0],"HH:mm")
							let end = moment(st.split("-")[1],"HH:mm")
							let check_time = val == "depart_time_filter" ?  moment(v["dep_time"],"HH:mm") :  moment(v["arr_time"],"HH:mm")
							if(check_time.isBetween(start, end)){
								return v
							}
						})
						temp = temp.concat(obj)
					})
					filteredObj = temp
				}
				if(val == "more_filters"){
					let temp =[]
					let obj_val ={dRefundable:'refundable',dMeals:'meals',dHbag:'hbag'}
					_.each(applied_filters[val],function(st,i){
						let obj =  _.filter(filteredObj,function(v,k){
							if(v[obj_val[st]]){
								return v
							}
						})
						temp = temp.concat(obj)
					})
					filteredObj = temp
				}
				if(val == 'price_filter'){
					let temp =[]
					let obj =_.filter(filteredObj,function(v,k){
						// if(v['route_total_fare'] >= slideFromPrice && v['route_total_fare'] <= slideToPrice){
							if(v['route_total_fare'] <= slideFromPrice){
								return v
							}
						})
					filteredObj =  obj
				}
				if(val == "carrier_filter"){
					let temp =[]
					_.each(applied_filters[val],function(st,i){
						let obj =  _.filter(filteredObj,function(v,k){
							if(v["dep_flight_key_format"].split("-")[0] == st){
								return v
							}
						})
						temp = temp.concat(obj)
					})
					filteredObj = temp
					if($('#one_price_card').length > 0){
						let template = Handlebars.compile($('#one_price_card').html())
						let tpl = template(temp[0])
						$(".one-way-price").html(tpl)
					}
				}
			}
		})
		if(reset_filter){
			$('div.lhs a.reset_filter').css('display','none')
		}else{
			$('div.lhs a.reset_filter').css('display','block')
		}
		if(is_mobile){
			if(filteredObj.length>0){
				afterFilterObj = filteredObj
				filteredObj = _.sortBy(_.sortBy(filteredObj,function(o){return moment(o.dep_time,"HH:mm")}),'route_total_fare')
				infiScroll = filteredObj
				mobileTpl(filteredObj)
				// oneWayRedirectItenory()
			}else{
				afterFilterObj = []
				infiScroll = []
				$('.owd-mflights-list').remove()
				$('div.emptyCardMobile').show()
			}
		}else{
			if(filteredObj.length > 0){
				afterFilterObj = filteredObj
				filteredObj = _.sortBy(_.sortBy(filteredObj,function(o){return moment(o.dep_time,"HH:mm")}),'route_total_fare')
				infiScroll = filteredObj
				desktopTpl(filteredObj,start_scroll,end_scroll,sort=false)
			}else{
				afterFilterObj = []
				infiScroll = []
				$('.owd-flights-list').remove()
				$('div.emptyCard').show()
			}
		}
	}
	// sorting for round_trip
	$('#rwd-flights .rwd-desk-lhs .desk-sorting li,.rwd-desk-rhs .desk-sorting li,div.mobile-sorting.ow-sorting ul li').click(function(){
		let tripName = $(this).closest('div').parent('div')[0].className
		let filVal = ""
		var obj =[]
		if(is_mobile){
			if(tripName == "rwd-lhs"){
				filVal = "onword"
				obj = onwardAfterFilterObj
			}else{
				filVal = "return"
				obj = returnAfterFilterObj
			}
		}else{
			if(tripName == "rwd-desk-lhs"){
				filVal = "onword"
				obj = onwardAfterFilterObj
			}else{
				filVal = "return"
				obj = returnAfterFilterObj
			}
		}
		let sort_val = $(this).data("row")
		let curr_cls = ""
		if(obj.length > 0 && sort_val &&  sort_val !=""){
			if(sort_val  == "dep_time"){
				obj = _.sortBy(obj,function(o){return moment(o.dep_time,"HH:mm")})
			}
			if(sort_val  == "duration"){
				obj = _.sortBy(obj,function(o){return o.formated_duration})
			}
			if(sort_val  == "route_total_fare"){
				obj = _.sortBy(obj,function(o){return o.route_total_fare})
			}
			if(is_mobile){
				if(filVal == "return"){
					curr_cls = $('div.rwd-rhs .mobile-sorting ul li').eq($(this).index()).find('a').attr("class")
					$('div.rwd-rhs .mobile-sorting ul li').find('a').removeClass("sortAsc")
					$('div.rwd-rhs .mobile-sorting ul li').find('a').removeClass("sortDes")
				}else if(filVal == "onword"){
					curr_cls = $('div.rwd-lhs .mobile-sorting ul li').eq($(this).index()).find('a').attr("class")
					$('div.rwd-lhs .mobile-sorting ul li').find('a').removeClass("sortAsc")
					$('div.rwd-lhs .mobile-sorting ul li').find('a').removeClass("sortDes")
				}
			}else{
				if(filVal == "onword"){
					curr_cls = $('#rwd-flights .rwd-desk-lhs .desk-sorting li').eq($(this).index()).find('a').attr("class")
					$('#rwd-flights .rwd-desk-lhs .desk-sorting li').find('a').removeClass("sortAsc")
					$('#rwd-flights .rwd-desk-lhs .desk-sorting li').find('a').removeClass("sortDes")
				}else if(filVal == "return"){
					curr_cls = $('#rwd-flights .rwd-desk-rhs .desk-sorting li').eq($(this).index()).find('a').attr("class")
					$('#rwd-flights .rwd-desk-rhs .desk-sorting li').find('a').removeClass("sortAsc")
					$('#rwd-flights .rwd-desk-rhs .desk-sorting li').find('a').removeClass("sortDes")
				}
			}
			if(curr_cls == ""){
				curr_cls = "sortAsc"
			}else if(curr_cls == "sortAsc"){
				curr_cls = "sortDes"
				obj = obj.reverse()
			}else if(curr_cls == "sortDes"){
				curr_cls = "sortAsc"
			}else if(typeof(curr_cls) == "undefined"){
				curr_cls = "sortDes"
				obj = obj.reverse()
			}
			if(filVal == "onword"){
				onwardAfterFilterObj = obj
			}else if(filVal == "return"){
				returnAfterFilterObj = obj
			}
			$(this).find('a').addClass(curr_cls)
			is_mobile ? rndMobSortTpl(obj,filVal) : rndDeskSortTpl(obj,filVal)
		}
	})
	function rndDeskSortTpl(obj,ele){
		_.each(obj,function(row,i){
			row["selectedcls"]= ""
			if(i==0){
				ele == "onword" ? $('div.rwd-desk-lhs .rwd-desk-flights-list').remove() : $('div.rwd-desk-rhs .rwd-desk-flights-list').remove()
				row["selectedcls"] = ele == "onword" ? "lhs-desk-selected" : "rhs-desk-selected" 
			}
			let template = Handlebars.compile($('#fsRndTripRouteCardTpl').html())
			row["index"] = i
			row["trip"] = ele == "onword" ? "onwrd_trip" : "return_trip"
			let tpl = template(row)
			ele ==  "onword" ?  $('div.rwd-desk-lhs').append(tpl) : $('div.rwd-desk-rhs').append(tpl)
		})
		rndDesktopPriceChange()
		if(ele ==  "onword"){
			$('div.rwd-desk-lhs .rwd-desk-flights-list.lhs-desk-selected').trigger('click')
		}else{
			$('div.rwd-desk-rhs .rwd-desk-flights-list.rhs-desk-selected').trigger('click')
		}
	}
	function rndMobSortTpl(obj,ele){
		_.each(obj,function(row,i){
			row["selectedcls"]= ""
			if(i==0){
				ele == "onword" ? $('#rwd-mobile-flights .rwd-lhs .rwd-flights-list').remove() : $('#rwd-mobile-flights .rwd-rhs .rwd-flights-list').remove()
				row["selectedcls"]= ele  == "onword" ? "lhs-selected" : "rhs-selected"
			}
			let template =Handlebars.compile($('#mobileRndTripCardTpl').html())
			row["trip"] = ele == "onword" ? "onwrd_trip" : "return_trip"
			let tpl = template(row)
			ele ==  "onword" ? $('#rwd-mobile-flights .rwd-lhs').append(tpl) : $('#rwd-mobile-flights .rwd-rhs').append(tpl)
		})
		rndMobilePriceChange()
		if(ele == "onword"){
			$('div.rwd-lhs .rwd-flights-list.lhs-selected').trigger('click')
		}else{
			$('div.rwd-rhs .rwd-flights-list.rhs-selected').trigger('click')
		}
	}

	$('.resetFilter,.reset_filter,.resetFilterMob,.clear-filter-mob').click(function(){
		$('.book_button').removeClass('disabled')
		$('.overlap-container').hide()
		applied_filters = {hop_filter:[],depart_time_filter:[],arrival_time_filter:[],more_filters:[],carrier_filter:[],price_filter:[]}
		$('.lhs-cards a.filter-checked').removeClass('filter-checked')
		$('#nd-mobilefilter input').removeAttr('checked')
		$('.airlines-filter input').removeAttr('checked')
		$(".more_filters input").removeAttr('checked')
		$(".hop_filter input").removeAttr('checked')
		$(".arrival_time_filter input").removeAttr('checked')
		$('.depart_time_filter input').removeAttr("checked")
		// $('#nd-mobilefilter').modal('toggle');
		let my_range = $(".js-range-slider").data("ionRangeSlider")
		my_range.reset()
		if(is_rndtrip){
			rndApplyFilters()
		}else{
			applyFilters()
		}
		$('a.reset_filter').hide()
	})

	if(!$.isEmptyObject(context) && !is_rndtrip){
		var slideFromPrice = 0
		var slideToPrice = 0
		if(!is_mobile){
			let refund_count = _.filter(context,function(st,k){
				if(st["refundable"]){
					return st
				}
			})
			let hbag_count = _.filter(context,function(st,k){
				if(st["hbag"]){
					return st
				}
			})
			if(hbag_count.length == 0){
				$('div.more_filters li.dHbag').addClass('disabled')
			}
			let meals_count = _.filter(onword_routes,function(st,k){
				if(st["meals"]){
					return st
				}
			})
			if(meals_count.length == 0){
				$('div.more_filters li.dMeals').addClass('disabled')
			}
			if(refund_count.length == 0){
				$('div.more_filters li.dRefundable').addClass('disabled')
			}
			availAirlines()
			timeIntialize()
			appliedFilterData()
		}else{
			$('#nd-mobilefilter').on('show.bs.modal',function(){
				if(available_airlines.length > 0){
					_.each(Object.keys(stops),function(s,i){
						stopsFilter(s)
					})
					timeIntialize()
					if($('.carrier_filter ul li.new').length ==0){
						$.each(available_airlines, function (i, row) {
							if(i == 0){
								$('.carrier_filter ul li').remove()
							}
							var template = Handlebars.compile($('#airlineCards').html())
							var tpl = template(row)
							$('.carrier_filter ul').append(tpl)
						})
					}
				}
				appliedFilterData()
			})
		}
		function mobileTpl(obj){
			$.each(obj, function (i, row) {
				if(i == 0){
					$('.owd-mflights-list').remove()
				}
				$('div.emptyCardMobile').hide()
				var template = Handlebars.compile($('#routeCardMobile').html())
				var tpl = template(row)
				$('#new-responses .owd-flights-list').hide()
				$('#after-remove').append(tpl)
			})
			//adding flexypay div
			flexyPay()
		}
		function desktopTpl(obj,start,end,sort){
			console.log(obj.length)
			if(sort){
				obj = obj.slice(start,end)
			}else{
				obj = obj.slice(0,10)
				start_scroll = 0
				end_scroll =10
			}
			$.each(obj, function (i, row) {
				if(i == 0){
					$('.owd-flights-list').remove()
				}
				$('div.emptyCard').hide()
				var template = Handlebars.compile($('#RouteCard-template').html())
				var tpl = template(row)
				$('#new-responses').append(tpl)
			})
			$('#new-responses .owd-flights-list.last').removeClass("last")
			$('.owd-flights-list.last').removeClass('last')
			$('#new-responses .owd-flights-list').last().addClass('last')
			//adding flexypay div
			flexyPay()
		}


		function desktopScrollTpl(obj){
			$.each(obj,function(i,row){
				let temp = Handlebars.compile($('#RouteCard-template').html())
				let tpl = temp(row)
				$('#new-responses').append(tpl)
			})
			$('#new-responses .owd-flights-list.last').removeClass("last")
			$('.owd-flights-list.last').removeClass('last')
			$('#new-responses .owd-flights-list').last().addClass('last')
		}

		
		if(is_mobile){
			$('.filter-btn a').click(function(e){
				e.preventDefault()
				applyFilters()
				$('#nd-mobilefilter').modal('toggle');
			})
		}

		// $(document).on("click",".sort-btn",function(){
		// 	let dep_filter = $('.depart_time_filter').find('input').is(':checked')
		// 	let arr_filter = $('.arrival_time_filter').find('input').is(':checked')
		// 	let price_filter = $('.price_filter').find('input').is(':checked')
		// 	if (dep_filter){
		// 		$('div.mobile-sorting.ow-sorting ul li.fd-timing').trigger('click')
		// 	}
		// 	if(arr_filter){
		// 		$('div.mobile-sorting.ow-sorting ul li.f-duration').trigger('click')
		// 	}
		// 	if(price_filter){
		// 		$('div.mobile-sorting.ow-sorting ul li.f-price').trigger('click')
		// 	}
		// 	$('#nd-mobilesort').modal('toggle');

		// })
		// oneway desktop sorting
		$('div.desk-sorting.ow-sorting ul li,div.mobile-sorting.ow-sorting ul li').click(function(){
			var sort_val = $(this).data("row")
			if(afterFilterObj.length > 0 && sort_val !=""){
				if(sort_val  == "dep_time"){
					afterFilterObj = _.sortBy(afterFilterObj,function(o){return moment(o.dep_time,"HH:mm")})
				}
				if(sort_val  == "arr_time"){
					afterFilterObj = _.sortBy(afterFilterObj,function(o){return moment(o.arr_time,"HH:mm")})
				}
				if(sort_val  == "route_total_fare"){
					afterFilterObj = _.sortBy(afterFilterObj,function(o){return o.route_total_fare})
				}
				if(sort_val  == "duration"){
					afterFilterObj = _.sortBy(afterFilterObj,function(o){return o.formated_duration})
				}
				if(sort_val == "formated_airline_name"){
					afterFilterObj = _.sortBy(afterFilterObj,function(o){return o.formated_airline_name})
				}
				let curr_cls = ""
				if(is_mobile){
					curr_cls = $('div.mobile-sorting.ow-sorting ul li').eq($(this).index()).find('a').attr("class")				
					$('div.mobile-sorting.ow-sorting ul li').find('a').removeClass("sortAsc")
					$('div.mobile-sorting.ow-sorting ul li').find('a').removeClass("sortDes")
				}else{
					curr_cls = $('div.desk-sorting.ow-sorting ul li').eq($(this).index()).find('a').attr("class")				
					$('div.desk-sorting.ow-sorting ul li').find('a').removeClass("sortAsc")
					$('div.desk-sorting.ow-sorting ul li').find('a').removeClass("sortDes")
				}
				if(curr_cls == ""){
					curr_cls = "sortAsc"
				}else if(curr_cls == "sortAsc"){
					curr_cls = "sortDes"
					afterFilterObj = afterFilterObj.reverse()
				}else if(curr_cls == "sortDes"){
					curr_cls = "sortAsc"
				}else if(typeof(curr_cls) == "undefined"){
					curr_cls = "sortDes"
					afterFilterObj = afterFilterObj.reverse()
				}
				$(this).find('a').addClass(curr_cls)
				infiScroll = afterFilterObj
				start_scroll = 0
				end_scroll = 10
				if(is_mobile) {
					mobileTpl(afterFilterObj) 
					// oneWayRedirectItenory()
				}else{
					desktopTpl(afterFilterObj,start_scroll,end_scroll,sort=true)
				}
			}
		})
		// filter-sort for mobilef
		
		// end of mobile sort filter


		$(window).scroll(function(){
			if(!is_mobile && !is_rndtrip){
				let elePos = 0
				if(start_scroll == 0 && end_scroll < afterFilterObj.length && $('.owd-flights-list.last').length > 0){
					elePos = $('.owd-flights-list.last').offset().top + $('.owd-flights-list.last').outerHeight() - window.innerHeight
				}else{
					if($('#new-responses .owd-flights-list.last').length > 0){
						elePos = $('#new-responses .owd-flights-list.last').offset().top + $('.owd-flights-list.last').outerHeight() - window.innerHeight
					}
				}
				if($(window).scrollTop() >= elePos+180){
					if(afterFilterObj.length > 0){
						if(end_scroll < afterFilterObj.length){
							start_scroll = end_scroll
							end_scroll +=10  
							infiScroll = afterFilterObj.slice(start_scroll,end_scroll)
						}else{
							start_scroll = 0
							infiScroll = []
						}
						if(infiScroll.length > 0){
							let templt = ""
							desktopScrollTpl(infiScroll)
						}
					}
				}
			}
		})
	}else if(!$.isEmptyObject(context)){
		if(onword_routes.length >0){
			if(!is_mobile){
				_.each(Object.keys(stops),function(s,i){
					stopsFilter(s)
				})

				let refund_count = _.filter(onword_routes,function(st,k){
					if(st["refundable"]){
						return st
					}
				})
				let hbag_count = _.filter(onword_routes,function(st,k){
					if(st["hbag"]){
						return st
					}
				})
				let meals_count = _.filter(onword_routes,function(st,k){
					if(st["meals"]){
						return st
					}
				})
				if(meals_count.length == 0){
					$('div.more_filters li.dMeals').addClass('disabled')
				}
				if(hbag_count.length == 0){
					$('div.more_filters li.dHbag').addClass('disabled')
				}
				if(refund_count.length == 0){
					$('div.more_filters li.dRefundable').addClass('disabled')
				}
				availAirlines()
				timeIntialize()
				appliedFilterData()
			}else{
				$('#nd-mobilefilter').on('show.bs.modal',function(){
					if(available_airlines.length > 0){
						_.each(Object.keys(stops),function(s,i){
							stopsFilter(s)
						})
						timeIntialize()
						if($('.carrier_filter ul li.new').length ==0){
							$.each(available_airlines, function (i, row) {
								if(i == 0){
									$('.carrier_filter ul li').remove()
								}
								var template = Handlebars.compile($('#airlineCards').html())
								var tpl = template(row)
								$('.carrier_filter ul').append(tpl)
							})
						}
					}
					appliedFilterData()
				})
				$('.filter-btn a').click(function(e){
					e.preventDefault()
					rndApplyFilters()
					$('#nd-mobilefilter').modal('toggle');
				})
			}
		}
	}
	rndMobilePriceChange()
	rndDesktopPriceChange()
	if(!is_rndtrip){
		flexyPay()
	}
	// if(is_mobile){
	// 	oneWayRedirectItenory()	
	// }
	// function oneWayRedirectItenory(){
	// 	$('.owd-mflights-list').click(function(){
	// 		if($(this).data("bookurl") && $(this).data("bookurl") !=""){
	// 			window.location = $(this).data("bookurl")
	// 		}
	// 	})
	// }
	function flexyPay(){
		$('div.flexy-pay').remove()
		if(is_mobile){
			$("<div class='flexy-pay'><img class='flex-img' src='https://waytogo-assets.s3-ap-southeast-1.amazonaws.com/waytogo-staging/new_images/SEO-FlexiFly-mobile.png'/></div>").insertAfter($('#after-remove .owd-mflights-list').eq(8))
		}else{
			$("<div class='flexy-pay'><img class='flex-img'  src='https://waytogo-assets.s3-ap-southeast-1.amazonaws.com/waytogo-staging/new_images/SEO-FlexiFly-desktop.png'/></div>").insertAfter($('#new-responses .owd-flights-list').eq(8))
		}
	}
	function inrConverter(amt){
		amt=amt.toString();
		let lastThree = amt.substring(amt.length-3);
		let otherNumbers = amt.substring(0,amt.length-3);
		if(otherNumbers != ''){
			lastThree = ',' + lastThree;
		}
		let res = otherNumbers.replace(/\B(?=(\d{2})+(?!\d))/g, ",") + lastThree;
		return res
	}
	if (!is_rndtrip){
		$(".footer_button").data("key",masterJson.routes[0].unique_flight_key)
	}
	// $(".sub-title .result_date").text(`hi date of schedule_route`)

})




$(document).on('click','.book_button',function(){
	let params = new URLSearchParams(window.location.search)
	var is_rndtrip = params && params.get("trip") == "R" ? true : false
	var utm_params = $(this).attr("class").includes("book_now") ? "&utm_source=schedule_route&utm_medium=book_now_button&utm_campaign=srp_one_load" : "&utm_source=schedule_route&utm_medium=book_button&utm_campaign=srp_one_load"
	if (is_rndtrip){
		var lhs_info = $('div.rwd-desk-lhs .rwd-desk-flights-list.lhs-desk-selected').data("info")
		var rhs_info = $('div.rwd-desk-rhs .rwd-desk-flights-list.rhs-desk-selected').data("info")
		var dep_date = $("#dpt_date").val();
		var arr_date = $("#rtn_date").val();
		var adult_count = $('form').find('input[name="adults"]').val()
		var child_count = $('form').find('input[name="childs"]').val()
		var infants_count = $('form').find('input[name="infants"]').val()
		var lhs_price = 0
		var rhs_price = 0
		if(lhs_info){
			lhs_price = lhs_info.split("_").reverse()[0]
		}
		if(rhs_info){
			rhs_price = rhs_info.split("_").reverse()[0]
		}
		var ret_price = (parseInt(lhs_price)+parseInt(rhs_price))
		var session_id = masterJson.routes[0].session_id
		var uid = masterJson.routes[0].uid
		var out_fare_key = masterJson.routes[0].onward.filter(data => data.unique_flight_key == lhs_info)[0].out_fare_key
		var ret_fare_key = masterJson.routes[0].return.filter(data => data.unique_flight_key == rhs_info)[0].out_fare_key
		var search_query = `https://www.cleartrip.com/flights/initiate-booking?from=${dep_city_code}&to=${arr_city_code}&depart_date=${dep_date}&return_date=${arr_date}&adults=${adult_count}&childs=${child_count}&infants=${infants_count}&class=Economy&psid=${session_id}&out_price=${lhs_price}&out_fare_key=${out_fare_key}&ret_price=${rhs_price}&ret_fare_key=${ret_fare_key}&uid=${uid}${utm_params}`
		window.location.replace(search_query)
	}
	else{
		var flight_info = $(this).data("key")
		var dep_date = $("#dpt_date").val();
		var adult_count = $('form').find('input[name="adults"]').val()
		var child_count = $('form').find('input[name="childs"]').val()
		var infants_count = $('form').find('input[name="infants"]').val()
		var price = 0
		if (flight_info)
		{
			price = flight_info.split("_").reverse()[0]
		}
		var session_id = masterJson.routes[0].session_id
		var uid = masterJson.routes[0].uid
		var filtered_flight = masterJson.routes.filter(data => data.unique_flight_key == flight_info)[0]
		var out_fare_key = filtered_flight.out_fare_key
		var uid = filtered_flight.uid
		var search_query = `https://www.cleartrip.com/flights/initiate-booking?from=${dep_city_code}&to=${arr_city_code}&depart_date=${dep_date}&adults=${adult_count}&childs=${child_count}&infants=${infants_count}&class=Economy&psid=${session_id}&out_price=${price}&out_fare_key=${out_fare_key}&uid=${uid}${utm_params}`
		window.location.replace(search_query)
	}
})

$(document).on('click','.book_button_mobile',function(){
	let params = new URLSearchParams(window.location.search)
	var utm_params = $(this).attr("class").includes("book_now") ? "&utm_source=schedule_route&utm_medium=book_now_button&utm_campaign=srp_one_load" : "&utm_source=schedule_route&utm_medium=book_button&utm_campaign=srp_one_load"
	var is_rndtrip = params && params.get("trip") == "R" ? true : false
	if (is_rndtrip){
		var adult_count = $('form').find('input[name="adults"]').val()
		var child_count = $('form').find('input[name="childs"]').val()
		var infants_count = $('form').find('input[name="infants"]').val()
		var travell_class = $("#travell-class").val()
		var dep_date = $('#form_dep_date').val()
		var arr_date = $('#form_rtn_date').val()
		var lhs_info = $('.rwd-lhs .lhs-selected').data("info")
		var rhs_info = $('.rwd-rhs .rhs-selected').data("info")
		var lhs_price = 0
		var rhs_price = 0
		if(lhs_info){
			lhs_price = lhs_info.split("_").reverse()[0]
		}
		if(rhs_info){
			rhs_price = rhs_info.split("_").reverse()[0]
		}
		var ret_price = (parseInt(lhs_price)+parseInt(rhs_price))
		var session_id = masterJson.routes[0].session_id
		var uid = masterJson.routes[0].uid
		var out_fare_key = masterJson.routes[0].onward.filter(data => data.unique_flight_key == lhs_info)[0].out_fare_key
		var ret_fare_key = masterJson.routes[0].return.filter(data => data.unique_flight_key == rhs_info)[0].out_fare_key
		var search_query = `https://www.cleartrip.com/m/flights/initiate-booking?from=${dep_city_code}&to=${arr_city_code}&depart_date=${dep_date}&return_date=${arr_date}&adults=${adult_count}&childs=${child_count}&infants=${infants_count}&class=${travell_class}&psid=${session_id}&out_price=${lhs_price}&out_fare_key=${out_fare_key}&ret_price=${rhs_price}&ret_fare_key=${ret_fare_key}&uid=${uid}${utm_params}&usrid=`
		console.log(search_query)
		window.location.replace(search_query)
	}
	else{
		var flight_info = $(this).data("key")
		var adult_count = $('form').find('input[name="adults"]').val()
		var child_count = $('form').find('input[name="childs"]').val()
		var infants_count = $('form').find('input[name="infants"]').val()
		var travell_class = $("#travell-class").val()
		var dep_date = $('#form_dep_date').val()
		var price = 0
		if (flight_info)
		{
			price = flight_info.split("_").reverse()[0]
		}
		var session_id = masterJson.routes[0].session_id
		var uid = masterJson.routes[0].uid
		var filtered_flight = masterJson.routes.filter(data => data.unique_flight_key == flight_info)[0]
		var out_fare_key = filtered_flight.out_fare_key
		var uid = filtered_flight.uid
		var search_query = `https://www.cleartrip.com/m/flights/initiate-booking?from=${dep_city_code}&to=${arr_city_code}&depart_date=${dep_date}&adults=${adult_count}&childs=${child_count}&infants=${infants_count}&class=${travell_class}&psid=${session_id}&out_price=${price}&out_fare_key=${out_fare_key}&uid=${uid}${utm_params}&usrid=`
		window.location.replace(search_query)

		// var redirect_to_book_flow_query = `&from=${dep_city_code}&to=${arr_city_code}&depart_date=${dep_date}&adults=${adult_count}&childs=${child_count}&infants=${infants_count}&class=${travell_class}&psid=${session_id}&out_price=${price}&out_fare_key=${out_fare_key}&uid=${uid}${utm_params}`
		// var param_hash = {
		// 	"from": dep_city_code,
		// 	"to": arr_city_code,
		// 	"depart_date": dep_date,
		// 	"adults":adult_count,
		// 	"childs": child_count,
		// 	"infants":infants_count,
		// 	"class":travell_class,
		// 	"psid":session_id,
		// 	"out_price":price,
		// 	"out_fare_key":out_fare_key,
		// 	"uid":`${uid}`
		// }
		// $.ajax({
  //                 url: "/redirect_to_book_flow",
  //                 type: 'post',
  //                 async: true,
  //                 data: {"search_query":param_hash},
  //                 error:function(data){
  //                 	debugger
  //                 },
  //                 success: function(data){
  //                 	return true
  //                 }

  //             })
}
})


// $(".owd-flight-details ").click(function(){
// 	debugger
// })
// $(document).on("click",".airline-names",function(){
// 	debugger
// })
$(".owd-flight-details").hide();

$(document).on("click","#flight_details_fetch",function(){
	var rnd_key = $("div.arrival-details > ul").data("key")
	var one_key = $("div.depart-details > ul").data("key")
	var rnd_data = masterJson.routes[0]["return"].filter(data=> data.unique_flight_key == rnd_key)[0]
	var one_data = masterJson.routes[0]["onward"].filter(data=> data.unique_flight_key == one_key)[0]
	one_data["final_price"]= one_data.route_total_fare + rnd_data.route_total_fare
	rnd_data["final_price"]= one_data.route_total_fare + rnd_data.route_total_fare
	one_data["flight_count"] = one_data.flight_itinerary.length - 1 
	rnd_data["flight_count"] = rnd_data.flight_itinerary.length - 1
	// var result_data = {}
	// result_data["one_data"] = one_data
	// result_data["rnd_data"] = rnd_data
	let template = Handlebars.compile($('#best_price_model').html())
	let tpl = template(rnd_data)
	// $('#sample_tmeplate').html(tpl)
	let template_one = Handlebars.compile($('#best_price_model').html())
	let tpl_one = template(one_data)
	$('#flights_popup').html(tpl_one+tpl)
})
// $(document).on("click",".carrier_filter",function(){
// 	debugger
// })

