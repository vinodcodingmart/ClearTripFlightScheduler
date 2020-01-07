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
    var dep_date_id;
    var rtn_date_id ;

    if(is_mobile){
        // ul = $('#m-search-widget ul.nav.nav-tabs')
        // ul.children().each(function(i,li){ul.prepend(li)})
        if(page_sub_type!="undefined" && (page_sub_type == "from" || page_sub_type == "to")){
           dep_date_id = '#dpt_date';
           rtn_date_id = "#rtn_date";

        }else if ( page_sub_type!="undefined" && page_sub_type == "index"){
          dep_date_id = "#dpt_date_mob";
          rtn_date_id = "#rtn_date_mob";
        }else{
          dep_date_id = "#dep_date_mob";
          rtn_date_id = "#rtn_date_mob";
        }
        var no_months = isMobile.any() ? 1 : 2;
        var step_months = isMobile.any()? 1 :2;
        $(dep_date_id).datepicker({
            showButtonPanel:true,
            closeText:'X',
            minDate: 0,
            dateFormat: "dd/mm/yy",
            numberOfMonths: no_months,
            stepMonths:step_months,
            dayNamesMin: ["S", "M", "T", "W", "T", "F", "S"],
            beforeShow: addCustomInformation,
            onChangeMonthYear: addCustomInformation,
            onSelect: (function (date) {
                var minDate = $(dep_date_id).datepicker("getDate");
                var highlight = $(dep_date_id).datepicker("getDate");
                 $(rtn_date_id).datepicker('setDate', highlight);
                 $(rtn_date_id).datepicker('option', 'minDate', highlight);
                minDate.setDate(minDate.getDate() + 1);
                 setTimeout(function () {
                if($('#m-search-widget').find("li.active a").hasClass("rnd_trip")){
                        $(rtn_date_id).val(new Date(minDate).format("dd/mm/yyyy")).datepicker('show');
                }else{
                     $(rtn_date_id).val(new Date(minDate).format("dd/mm/yyyy"))
                }
            },300)
            })
        });

        $(rtn_date_id).datepicker({
            showButtonPanel:true,
            closeText:'X',
            numberOfMonths: no_months,
            dateFormat: "dd/mm/yy",
            stepMonths:step_months,
            beforeShow: addCustomInformation,
            onChangeMonthYear: addCustomInformation,
            dayNamesMin: ["S", "M", "T", "W", "T", "F", "S"],
            onSelect: function(){
                if($('#destination_autocomplete').val() !="" && $('#origin_autocomplete').val() !=""){
            // $('#button_flight_search').trigger('click')
        }
    },
    onClose: (function () {
        var dt1 = $(dep_date_id).datepicker('getDate');
        var dt2 = $(rtn_date_id).datepicker('getDate');
        if (dt2 <= dt1) {
            var minDate = $(rtn_date_id).datepicker('option', 'minDate');
            $(rtn_date_id).datepicker('setDate', minDate);
        }
    // $(this).val($(this).datepicker('getDate').toLocaleDateString());
})
});

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
                        $(dep_date_id).datepicker("setDate",new Date(Date.now() + (24 * 2 * 60 * 60 * 1000)).format("dd/mm/yyyy")).datepicker('show')
                    }
                },200)
            }else{
                setTimeout(function(){
                    $(dep_date_id).datepicker("setDate",new Date(Date.now() + (24 * 2 * 60 * 60 * 1000)).format("dd/mm/yyyy")).datepicker('show')
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


    $("#origin_autocomplete_mob,#destination_autocomplete_mob").autocomplete({
        source: function(req, resp) {
            $.getJSON(search_url + req.term+redirection_params, function(res) {
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
                            to_country = extractCountry(arr_data[index].v);
                            $("#destination_autocomplete_mob").val(arr_data[index].v)
                        }
                    })
                }
            })
        }
        // if($('#AirSearchMob li.m-travellers').length > 0 && language_type == "en"){
        //  $('#AirSearchMob li.m-travellers').replaceWith("<li class='m-travellers'><a href='#' class='m-travellers-count' data-toggle='modal' data-target='#travellerModal'><label>Travellers</label><span class='adults'>1 Adult,</span><span class='child'>0 <span>Children,</span></span><span class='infants'>0 <span>Infants</span></span><input type='hidden' name='adults' value='1'><input type='hidden' name='infants' value='0'><input type='hidden' name='childs' value='0'></a></li>")
        // }
    }
    var arDomains = ["www.cleartrip.sa", "www.cleartrip.ae"];
    if (typeof window.languageType != "undefined") {
        var languageType = window.languageType
    }
    if (typeof window.language_type != "undefined") {
        var languageType = window.language_type
    }
    var two_days = Date.now() + (24 * 2 * 60 * 60 * 1000);
    var diff_days = Date.now() + (24 * 4 * 60 * 60 * 1000);
    $(dep_date_id).val(new Date(two_days).format("dd/mm/yyyy"));
    $(rtn_date_id).val(new Date(diff_days).format("dd/mm/yyyy"));

    $("#button_flight_search_mob").on('click',function(e) {
        if(is_mobile && $('#m-search-widget').find("li.active a").hasClass("one_way")){
            e.preventDefault()
            var inp_val = "O";
            if (inp_val == "O") {
                ret_val = $("#rtn_date_mob").val();
                $("#rtn_date_mob").val("")
            }
        }
        var frm_val =$('#origin_autocomplete_mob').val()
        var err_msg =''
        if(!frm_val){
            err_msg = "Please enter departure city name"
            errorNotification(err_msg)
            return false
        }
        var to_val = $('#destination_autocomplete_mob').val()

        if(!to_val){
            err_msg = "Please enter arrival city name"
            errorNotification(err_msg)
            return false
        }

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
        var adultCount = parseInt($(this).closest('ul').find('.adult-count').text());
        // $( ".m-travellers-count span.adults").text(adultCount);
        $('.adultsNumber').text(adultCount)
        // window.location.href.includes("/ar/") ? $(".m-travellers-count span.adults").append('<span class="person-count" style="padding-left:5px;">ÃƒËœÃ‚Â§Ãƒâ„¢Ã¢â‚¬Å¾Ãƒâ„¢Ã†â€™ÃƒËœÃ‚Â¨ÃƒËœÃ‚Â§ÃƒËœÃ‚Â±,</span>') : $(".m-travellers-count span.adults").append('<span class="person-count" style="padding-left:5px;">Adults,</span>');
        var childrenCount = parseInt($(this).closest('ul').find('.child-count').text());
        // $( ".m-travellers-count  span.child").text(childrenCount);
        $('.childNumber').text(childrenCount)
        // window.location.href.includes("/ar/") ? $( ".m-travellers-count span.child").append('<span class="person-count" style="padding-left:5px;">ÃƒËœÃ‚Â§Ãƒâ„¢Ã¢â‚¬Å¾ÃƒËœÃ‚Â£ÃƒËœÃ‚Â·Ãƒâ„¢Ã‚ÂÃƒËœÃ‚Â§Ãƒâ„¢Ã¢â‚¬Å¾,</span>') : $( ".m-travellers-count span.child").append('<span class="person-count" style="padding-left:5px;">Children,</span>')
        var infantCount  = parseInt($(this).closest('ul').find('.infant-count').text());
        // $( ".m-travellers-count span.infants").text(infantCount);
        $('.infantsNumber').text(infantCount)
        // window.location.href.includes("/ar/") ? $( ".m-travellers-count span.infants").append('<span class="person-count" style="padding-left:5px;">ÃƒËœÃ‚Â§Ãƒâ„¢Ã¢â‚¬Å¾ÃƒËœÃ‚Â±ÃƒËœÃ‚Â¶ÃƒËœÃ‚Â¹</span>') : $( ".m-travellers-count span.infants").append('<span class="person-count" style="padding-left:5px;">Infants</span>')
    });


    $('a.toggle_trip').on('click',function(){
        if(this.className.includes("rnd_trip")){
            $('a.one_way').parent('li').removeClass('active')
            $('.rdate').show()
            $('a.rnd_trip').parent('li').addClass('active')
            var minDate = $(dep_date_id).datepicker("getDate");
            var highlight = $(dep_date_id).datepicker("getDate");
            $('#one_way_mob').val("R")
            if(minDate){
                minDate.setDate(minDate.getDate() + 1);
                $('#rtn_date_mob').datepicker('setDate', highlight);
                $('#rtn_date_mob').datepicker('option', 'minDate', highlight);
                $('#rtn_date_mob').val(new Date(minDate).format("dd/mm/yyyy"))
            }
        }else{
            $('#one_way_mob').val("O")
            $('.rdate').hide()
            $('a.one_way').parent('li').addClass('active')
            $('a.rnd_trip').parent('li').removeClass('active')
        }
    })
    if(is_mobile){
        $('#m-search-widget li a.one_way').trigger('click')
        // $('.m-travellers-count span:first').text("1 Adult,")
        $('#AirSearchMob').find('input[name="adults"]').val("1")
        $('#travellerModal span.adult-count').text("1")
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