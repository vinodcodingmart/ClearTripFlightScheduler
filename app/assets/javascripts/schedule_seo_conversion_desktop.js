$(document).ready(function() {
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
  var ignore_internationals = ["www.cleartrip.sa"];
  var mobile_link = (isMobile.any()) ? "/m" : "";
  var from_country;
  var to_country;
  var autocomplte_language = (location.href.includes("/ar/")) ? "ARABIC" : "ENGLISH";
  var lang_str = "";
  var redirection_params =""
  var arr_city_name ;
  var dep_city_name;
  var dep_code;
  var arr_code
  var is_mobile = isMobile.any() ? true : false
  var two_days = Date.now() + (24 * 2 * 60 * 60 * 1000);
  var diff_days = Date.now() + (24 * 4 * 60 * 60 * 1000);
  var dep_city_code;
  var arr_city_code;
  var  search_paramms =  window.location.search ? QueryStringToJSON() : {}

//search params append
if(window.location.search && !location.href.includes("/ar/")){
  search_paramms = QueryStringToJSON()
  if(search_paramms["adult_count"] && search_paramms["child_count"] && search_paramms["infants_count"]){
    let travellers_txt = parseInt(search_paramms["adult_count"])+parseInt(search_paramms["child_count"])+parseInt(search_paramms["infants_count"])
    $('form').find('input[name="adults"]').val(search_paramms["adult_count"])
    $('form').find('input[name="childs"]').val(search_paramms["child_count"])
    $('form').find('input[name="infants"]').val(search_paramms["infants_count"])
    $('.travellers_data').val(travellers_txt+ " Travellers")
    $('ul.desktop_travellers li .adult-count').text(search_paramms["adult_count"])
    $('ul.desktop_travellers li .child-count').text(search_paramms["child_count"])
    $('ul.desktop_travellers li .infant-count').text(search_paramms["infants_count"])
  }
  if(search_paramms["dep_date"]){
    let dep_date = moment(search_paramms["dep_date"],'DD/MM/YYYY').toDate()
    $('#dpt_date').datepicker('setDate',dep_date)
    $('#dpt_date').val(new Date(dep_date).format("dd/mm/yyyy"))
  }
  if(search_paramms["trip"] == "R" && search_paramms["arr_date"]){
    let arr_date = moment(search_paramms["arr_date"],'DD/MM/YYYY').toDate()
    $('#rtn_date').datepicker('setDate',arr_date)
    $('#rtn_date').val(new Date(arr_date).format("dd/mm/yyyy"))
  }
}
//setting date if query params are not present
if($('#dpt_date').val() == ""){
  // $('#dpt_date').val(new Date().format("dd/mm/yyyy"))
  $("#dpt_date").val(new Date(two_days).format("dd/mm/yyyy"));
  $("#rtn_date").val(new Date(diff_days).format("dd/mm/yyyy"));
  // $('#dpt_date').datepicker("setDate",new Date(Date.now() + (24 * 2 * 60 * 60 * 1000)).format("dd/mm/yyyy"))

}
//setting D+2 date for datepicker
//for domestic default is one way! changing based on query params
if(Object.keys(search_paramms).indexOf("arr_date") > 0 && search_paramms["arr_date"]!="" && search_paramms["trip"] == "R"){
  $(".rnd_trip").attr('checked', true)
}else{
  if(section_type && section_type === 'international'){
    $(".rnd_trip").attr('checked', true)
    $('li.D-Rdate').removeClass('hide')
  }else{
    $('li.D-Rdate').addClass('hide')
    $("#oneway").attr('checked', true)
  }
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

if (["www.cleartrip.sa","www.cleartrip.ae"].includes(location.hostname)==true && location.href.includes('/ar/')) {
  lang_str = "/ar";
}

if(["www.cleartrip.sa","www.cleartrip.ae"].includes(location.hostname)==true && !location.href.includes('/ar/')){
  redirection_params = "&skip-lp-redirect=true"
}
var search_url = (location.href.includes('/ar/'))? "https://"+location.hostname+"/suggest/airports?expectedNumberOfRecords=10&outputLanguages=ARABIC&inputText=" : "https://"+location.hostname+"/places/airports/search?string="
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
  $('.full-calendar').hide()
  $("#horCalendar").show()
  $("#calendar").hide()
}
var dep_code = $("#departure_city_code").text();
var arr_code = $("#arrival_city_code").text();
var dep_city_code =$("#departure_city_code").text();
var arr_city_code =$("#arrival_city_code").text();
var carrier_code = $("#carrier_code").text();
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
if(!is_mobile){
 // header-popup
 $(document).mouseleave(function (event) {
   if(event.clientY <= 0 || event.clientX <= 0 || event.clientX >= window.innerWidth){
     $('div.top-offer-popup').animate( { "opacity": "show", top:"0"} , "slow" )
   }
 })

 
 $('.offerHideBtn').click(function(){
   $('div.top-offer-popup').animate( { "opacity": "hide", top:"0"} , "slow" )
 })
  // end of header-popup
  // Read more
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

  //image swaping code
  $('.trip-swap').click(function(){
    swap_val =''
    dep=$('#origin_autocomplete').val()
    arr =$('#destination_autocomplete').val()
    if(dep !="" && arr != "" && typeof(from_country) !="undefined" && from_country != "" && typeof(to_country) !="undefined" && from_country !="" && dep_city_name && dep_city_name !="" && arr_city_name && arr_city_name !="" && typeof(dep_code) !="undefined" && dep_code !="" && typeof(arr_code) !="undefined"  && arr_code !=""){
      res = swapString(dep,arr)
      $('#origin_autocomplete').val(res[0])
      $('#destination_autocomplete').val(res[1])
      res = swapString(dep_city_code,arr_city_code)
      dep_city_code = res[0]
      arr_city_code = res[1]
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
  var fare_calendar = []
  var no_months = isMobile.any() ? 1 : 2;
  if(section && (section == 'SA' || section == "IN") && typeof(section_type) != "undefined"  && section_type == "domestic" && typeof(dep_city_code) != "undefined" && typeof(arr_city_code) != "undefined"){
    url ="https://www.cleartrip.com/seoapi/flight_api/fare_calendar?from="+dep_city_code+"&to="+arr_city_code+"&section="+section
    $.ajax({
      url:url,
      type: "GET",
      dataType: "json",
      success:function(res){
        var current_date = new Date()
        month = current_date.getMonth()+1
        year = current_date.getFullYear()
        lastdate = lastday(year,month)
        $.each(res,function(e,v){
          if(parseInt(v["date"]) <= parseInt(lastdate.format("yyyymmdd"))){
            fare_calendar.push(v)
          }
        })
      },
      complete:function(){
        // $("#dpt_date").datepicker("setDate",new Date(Date.now() + (24 * 2 * 60 * 60 * 1000)).format("dd/mm/yyyy")).datepicker('hide')
      }
    },20)
  }else{
    setTimeout(function(){
      // $("#dpt_date").datepicker("setDate",new Date(Date.now() + (24 * 2 * 60 * 60 * 1000)).format("dd/mm/yyyy")).datepicker('hide')
    },700)
  }
}

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
                let from = $('.from').val() != "" ? $('.from').val() : "DEL"
                let to = $('.to').val() != "" ? $('.to').val() : "BLR"
                let link = window.location.pathname
                let trip = $("input[name='rnd_one']:checked").val()
                let ret_date = ""
                if(trip == "R"){
                  ret_date = "&arr_date=" + cal_day.format("dd/mm/yyyy")
                }

                link += "?from=" + from +"&to=" + to + "&trip=" + trip +"&dep_date=" + cal_day.format("dd/mm/yyyy") + ret_date  + "&adult_count=1&child_count=0&infants_count=0&travell_class=Economy&utm_source=schedule_route&utm_medium=search_widget&utm_campaign=srp_one_load"; 
                  
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
           $('#horCalendar').hide()
        }
      } else {
        $(".calendar-new").hide()
        $("#horCalendar").hide()
      }
    }
    if($.isEmptyObject(data)){
      $(".calendar-new").hide()
      $('#horCalendar').hide()
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
$("#show_all_flights").click(function() {
  $("#airline-lists li.showMore").toggleClass("hide")
});
$(".mview-list li.showMore").addClass("hide");
$("#show_all_flights_mobile").click(function() {
  $(".mview-list li.showMore").toggleClass("hide")
});

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
if ($("#back-to-top").length) {
  var scrollTrigger = 100,
  backToTop = function() {
    var scrollTop = $(window).scrollTop();
    if (scrollTop > scrollTrigger) {
      $("#back-to-top").addClass("show")
    } else {
      $("#back-to-top").removeClass("show")
    }
  };
  backToTop();
  $(window).on("scroll", function() {
    backToTop()
  });
  $("#back-to-top").on("click", function(e) {
    e.preventDefault();
    $("html,body").animate({
      scrollTop: 0
    }, 700)
  })
}

if(!is_mobile){
  $('.travellerClass,.popup-travellers').click(function(e) {
    e.stopPropagation();
  });
  $('#dpt_date').datepicker({
    showButtonPanel:true,
    closeText:'X',
    minDate: 0,
    dateFormat: "dd/mm/yy",
    numberOfMonths: no_months,
    stepMonths:2,
    dayNamesMin: ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"],
    beforeShow: addCustomInformation,
    onChangeMonthYear: addCustomInformation,
    firstDay:1,
    onSelect: (function (date) {
      var minDate = $("#dpt_date").datepicker("getDate");
      var highlight = $("#dpt_date").datepicker("getDate");
      minDate.setDate(minDate.getDate() + 1);
      // $('#rtn_date').datepicker('setDate', highlight);
      $('#rtn_date').datepicker('option', 'minDate', highlight);
      setTimeout(function () {
            // $("#rtn_date").val(new Date(minDate).format("dd/mm/yyyy"))
            if($("input[name='rnd_one']:checked").val() == 'R'){
              $("#rtn_date").val(new Date(minDate).format("dd/mm/yyyy")).datepicker('show');
            }else{
              $("#rtn_date").val(new Date(minDate).format("dd/mm/yyyy"))
            }
          }, 300)
    })
  });
  $('#rtn_date').datepicker({
    showButtonPanel:true,
    closeText:'X',
    numberOfMonths: no_months,
    dateFormat: "dd/mm/yy",
    stepMonths:2,
    minDate:0,
    beforeShow: addCustomInformation,
    onChangeMonthYear: addCustomInformation,
    firstDay:1,
    dayNamesMin: ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"],
    onSelect: function(){
      if($('#destination_autocomplete').val() !="" && $('#origin_autocomplete').val() !=""){
            // $('#button_flight_search').trigger('click')
          }
        },
        onClose: (function () {
          var dt1 = $('#dpt_date').datepicker('getDate');
          var dt2 = $('#rtn_date').datepicker('getDate');
          if (dt2 <= dt1) {
            var minDate = $('#rtn_date').datepicker('option', 'minDate');
            $('#rtn_date').datepicker('setDate', minDate);
          }
    // $(this).val($(this).datepicker('getDate').toLocaleDateString());
  })
      });


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
            $.each(fare_calendar,function(e,v){
              if(v["date"]== date){
                price = parseInt(v["min_price"])
                price = price.toString()
                min_price = country_code == 'in' ? price.replace(/(\d)(?=(\d\d)+\d$)/g, "$1,") : price
              }
            })
            if(min_price){
              $(this).append("<span class='calendarPrice low'>" + min_price + "</small>")}
            }
          })
      },300)
    }
  }  
}

$("#origin_autocomplete,#destination_autocomplete").autocomplete({
  source: function(req, resp) {
    $.getJSON(search_url + req.term+redirection_params, function(res) {
    // $.getJSON("https://api.myjson.com/bins/fxhv8", function(res) {
      var result_data = [];
      res = parseAutoCmp(res);
      $.each(res, function(i, d) {
        result_data.push({
          label: d.v,
          value: d.v
        })
      });
      resp(result_data)
    })
  },
  select: function(ui, selected) {
    var selected_city = extractCITY(selected.item.value);
    if (ui.target.id == "origin_autocomplete") {
      from_country = extractCountry(selected.item.value);
      dep_city_name = extractCityName(selected.item.value)
      dep_code = selected_city
      dep_city_code = selected_city
      $(".from").val(selected_city)
    } else {
      to_country = extractCountry(selected.item.value);
      arr_city_name = extractCityName(selected.item.value)
      arr_code = selected_city
      arr_city_code = selected_city
      $(".to").val(selected_city)
    }
  },
  minLength: 3
})
if(!is_mobile){
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
            from_country = extractCountry(dep_data[index].v);
            $("#origin_autocomplete").val(dep_data[index].v)
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
            to_country = extractCountry(arr_data[index].v);
            $("#destination_autocomplete").val(arr_data[index].v)
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
function pad(n) {return (n<10 ? '0'+n : n);}
function lastday(y,m){return new Date(y,m+1,0)}
var is_mobile = isMobile.any() ? true : false


//new search widget
$("#search_flights").on("click",function() {
  if($("input[name='rnd_one']:checked").val() == "O") {
    ret_val = $("#rtn_date").val();    
    $("#rtn_date").val("")
  }
  // if($('#origin_autocomplete').val() === "" || $('#destination_autocomplete').val() ===""){
  //   return false
  // }
  var dep_date = $("#dpt_date").val();
  var arr_date = $("#rtn_date").val();
  var adult_count = $('form').find('input[name="adults"]').val()
  var child_count = $('form').find('input[name="childs"]').val()
  var infants_count = $('form').find('input[name="infants"]').val()
  
  var from = $('.from').val() != "" ? $('.from').val() : "DEL"
  var to = $('.to').val() != "" ? $('.to').val() : "BLR"
  var trip = $("input[name='rnd_one']:checked").val()
  var query_string = "from=" + from +"&to="  + to + "&trip=" + trip + "&dep_date=" + dep_date + "&arr_date=" + arr_date + "&adult_count=" + adult_count + "&child_count=" + child_count + "&infants_count=" + infants_count + "&utm_source=schedule_route&utm_medium=search_widget&utm_campaign=srp_one_load" ; 
  $.ajax({
    url: "/flight-schedule/get_search_url.html?" + query_string ,
    type: 'post',
    async: true,
    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));$("#loaders").css("display","block"),$("#spinner").css("display","block")},
    data: {query_string: query_string},
    error: function(data){
      return true;
    },
    success: function(data){ 
      window.location.replace(data.url_format + "?" + query_string)
      $('form').find('input[name="adults"]').text() = data.adult_count
      $('form').find('input[name="childs"]').text() = data.child_count
      $('form').find('input[name="infants"]').text() = data.infants_count
      $('form .travell-class').text() = data.travell_class
    }})
});

//querystring data append



$(".cheapFlightBtn").each(function() {
  if(typeof(section_type) !="undefined"){
    current_section_type = section_type
    depart_date = $(this).data('date')
    if(current_section_type.includes("international")){
      if (languageType == "ar" && $.inArray(location.hostname, arDomains) >= 0) {
        var link = location.protocol + "//" + location.hostname + mobile_link + "/ar/flights/international/results?from=" + dep_city_code + "&to=" + arr_city_code + "&depart_date=" + depart_date + "&adults=1&childs=0&infants=0&page=loaded"
      } else {
        var link = location.protocol + "//" + location.hostname + mobile_link + "/flights/international/results?from=" + dep_city_code + "&to=" + arr_city_code + "&depart_date=" + depart_date + "&adults=1&childs=0&infants=0&page=loaded"
      }
    }
    if (current_section_type == "int") {
      if (languageType == "ar" && $.inArray(location.hostname, arDomains) >= 0) {
        var link = location.protocol + "//" + location.hostname + mobile_link + "/ar/flights/international/results?from=" + dep_city_code + "&to=" + arr_city_code + "&depart_date=" + depart_date + "&adults=1&childs=0&infants=0&page=loaded"
      } else {
        var link = location.protocol + "//" + location.hostname + mobile_link + "/flights/international/results?from=" + dep_city_code + "&to=" + arr_city_code + "&depart_date=" + depart_date + "&adults=1&childs=0&infants=0&page=loaded"
      }
    } else {
      if (languageType == "ar" && $.inArray(location.hostname, arDomains) >= 0) {
        var link = location.protocol + "//" + location.hostname + mobile_link + "/ar/flights/results?from=" + dep_city_code + "&to=" + arr_city_code + "&depart_date=" + depart_date + "&adults=1&childs=0&infants=0&page=loaded"
      } else {
        var link = location.protocol + "//" + location.hostname + mobile_link + "/flights/results?from=" + dep_city_code + "&to=" + arr_city_code + "&depart_date=" + depart_date + "&adults=1&childs=0&infants=0&page=loaded"
      }
    }
    if(typeof country_code != 'undefined' && (country_code == 'IN'  || country_code == 'in' || country_code == 'SA' || country_code == 'sa')){
      link += "&utm_source=google&utm_medium=organic&utm_campaign="+'seo_'+page_type+'_book_now_button'
    }
    $(this).attr("href", link)
  }
});


$('.Dtravellers').on('click',function(e){
  e.preventDefault()
  var travel_text = ""
  var adultCount = parseInt($(this).closest('ul').find('.adult-count').text());
  var childrenCount = parseInt($(this).closest('ul').find('.child-count').text());
  var infantCount  = parseInt($(this).closest('ul').find('.infant-count').text());
  // if(location.href.includes("/ar/")){
  //    travel_text+=infantCount+" Ã˜Â§Ã™â€žÃ˜Â±Ã˜Â¶Ã˜Â¹"+ childrenCount+" Ã˜Â§Ã™â€žÃ˜Â·Ã™ÂÃ™â€ž"+adultCount+ " Ã˜Â§Ã™â€žÃ™Æ’Ã˜Â¨Ã˜Â§Ã˜Â±"
  // }else{
  //   travel_text+=adultCount+" Adults,"+childrenCount+" Child,"+infantCount+" Infants"
  // }
  // $('.travellers_data').val(travel_text)
  travel_text+=infantCount+childrenCount+adultCount
  if(parseInt(travel_text) <10){
    travel_text ="0"+travel_text
  }
  if(location.href.includes("/ar/")){
    $('.travellers_data').val(travel_text+ " مسافرين")
  }else{
    $('.travellers_data').val(travel_text+ " Travellers")
    $("span.t_info").html(travel_text+ " Travellers, Economy")
  }
  $('li.pax-count').removeClass('open')
});

if($('div.local-tile a').length > 0 && location.href.split('/').pop() !="flight-status.html"){
  $('div.local-tile a').each(function(index,ele){
    _href  = $(ele).attr('href')
    $(ele).attr('href',_href +'?utm_source=Google&utm_medium=Organic&utm_campaign=Flights')
  })
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



if(typeof country_code != 'undefined' && (country_code == 'IN'  || country_code == 'in' || country_code == 'SA' || country_code == 'sa')){
  if($('table.fare-table a.booking-btn').length>0){
    $.each($('table.fare-table a.booking-btn'),function(ele,ind){
      ele.href+="&utm_source=google&utm_medium=organic&utm_campaign="+'seo_'+page_type+'_book_now_button'
    })
  }
}
$(".flight-schedule-booking").each(function() {
  var cur_date = new Date().format("dd/mm/yyyy");
  var routes = $(this).data("route").split("-");
  two_date = new Date(two_days).format("dd/mm/yyyy");
  var data_section = $(this).data("section");
  if (typeof data_section == "undefined") {
    data_section = routes[3]
  }
  if (data_section == "int") {
    if (languageType == "ar" && $.inArray(location.hostname, arDomains) >= 0) {
      var link = location.protocol + "//" + location.hostname + mobile_link + "/ar/flights/international/results?from=" + routes[0] + "&to=" + routes[1] + "&depart_date=" + two_date + "&adults=1&childs=0&infants=0&page=loaded&class=Economy"
    } else {
      var link = location.protocol + "//" + location.hostname + mobile_link + "/flights/international/results?from=" + routes[0] + "&to=" + routes[1] + "&depart_date=" + two_date + "&adults=1&childs=0&infants=0&page=loaded&class=Economy"
    }
  } else {
    if (languageType == "ar" && $.inArray(location.hostname, arDomains) >= 0) {
      var link = location.protocol + "//" + location.hostname + mobile_link + "/ar/flights/results?from=" + routes[0] + "&to=" + routes[1] + "&depart_date=" + two_date + "&adults=1&childs=0&infants=0&page=loaded&class=Economy"
    } else {
      var link = location.protocol + "//" + location.hostname + mobile_link + "/flights/results?from=" + routes[0] + "&to=" + routes[1] + "&depart_date=" + two_date + "&adults=1&childs=0&infants=0&page=loaded&class=Economy"
    }
  }
  if (routes[2] != undefined && mobile_link == "") {
    link += "&airline=" + routes[2]
  }
  if(typeof country_code != 'undefined' && (country_code == 'IN'  || country_code == 'in' || country_code == 'SA' || country_code == 'sa')){
    link += "&utm_source=google&utm_medium=organic&utm_campaign="+'seo_'+page_type+'_book_now_button'
  }
  $(this).attr("href", link)
  // $(".offer_book_now").attr("href",link)
});



$("#adults").change(function() {
  selected = parseInt($(this).val());
  $("#children").empty();
  for (i = 0; i <= (9 - selected); i++) {
    $("#children").append($("<option>").val(i).html(i))
  }
  $("#children").change()
});
$("#children").change(function() {
  $("#infants").empty();
  child_selected = parseInt($("#children").val());
  for (i = 0; i <= (9 - child_selected); i++) {
    $("#infants").append($("<option>").val(i).html(i))
  }
});
if (typeof(section_type) != "undefined" && section_type == "international") {
  var action = $("#AirSearch").attr("action");
  if (action == "/flights/search") {
    if (isMobile.any()) {
      link = mobile_link + "/flights/international/results"
    } else {
      link = mobile_link + "/flights/international/search"
    }
    $("#AirSearch").attr("action", link)
  }
}
load_calendars = ["www.cleartrip.com", "www.cleartrip.ae","www.cleartrip.sa","localhost"];
curr_domain = location.hostname;
if (load_calendars.indexOf(curr_domain) < 0) {
  $(".calendar-new").show()
}
});

// $('.toggle_trip').on('click',function(){
//   if(this.className.includes("rnd_trip")){
//     $('.one_way').parent('li').removeClass('active')
//     $('.D-Rdate').find('input').prop("disabled", false)
//     $('.rnd_trip').parent('li').addClass('active')
//     var minDate = $("#dpt_date").datepicker("getDate");
//     var highlight = $("#dpt_date").datepicker("getDate");
//     $('#one_way').val("R")
//     if(minDate){
//       minDate.setDate(minDate.getDate() + 1);
//       $('#rtn_date').datepicker('setDate', highlight);
//       $('#rtn_date').datepicker('option', 'minDate', highlight);
//       $("#rtn_date").val(new Date(minDate).format("dd/mm/yyyy"))
//     }
//   }else{
//     $('#one_way').val("O")
//     $('li.D-Rdate').find('input').prop("disabled", true)
//     $('.one_way').parent('li').addClass('active')
//     $('.rnd_trip').parent('li').removeClass('active')
//   }
// })



$("input[name='rnd_one']").click(function(){
  $(this).find('input').prop('checked',true)
  if($("input[name='rnd_one']:checked").val() == 'R'){
    var minDate = $("#dpt_date").datepicker("getDate");
    var highlight = $("#dpt_date").datepicker("getDate");
    $("#dpt_date").val(moment(minDate).format("DD/MM/YYYY"));
    if(minDate){
      minDate.setDate(minDate.getDate() + 1);
      $("#rtn_date").val(moment(minDate).format("DD/MM/YYYY"));
      $('#rtn_date').datepicker('setDate', highlight);
      $('#rtn_date').datepicker('option', 'minDate', highlight);
      $("#rtn_date").val(new Date(minDate).format("dd/mm/yyyy"))
      $('li.D-Rdate').removeClass('hide')
    }
  }else{
    $('li.D-Rdate').addClass('hide')
  }

})


var travell_info = $(".travellers_data").val()
travell_info += ", Economy"
$("span.t_info").html(travell_info)

// $('.stops-filters-toggle').click(function(){
//   debugger
//       if($('.dview-stopstoggler').css('height') == '0px'){
//         $('.dview-stopstoggler').animateAuto("height",1500,function(){
//           $('.mreview-toggle-cnt').css({'height':'auto'})
//         })
//       }else{
//         $('.dview-stopstoggler').animate({'height': '0px'},800,function(){
//           $('.dview-stopstoggler').css({'height':'0px'})
//         })
//       }
//     })



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
function swapString(a,b){
  c=''
  c = a
  a = b
  b = c
  return [a,b]
}
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


$(document).on("click",".f-details",function(){
  let txt = $(this).text() == "Flight Details" ? "Hide Details" : "Flight Details"
  if(txt == "Flight Details"){
    $(this).closest("div.owd-flights-list").find(".owd-flight-details").hide()
  }else{
    $(this).closest("div.owd-flights-list").find(".owd-flight-details").show()
  }
  $(this).text(txt)
});


