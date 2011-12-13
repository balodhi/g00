# coding: utf-8
module CitiesHelper
  def get_city_array(code)    
 
    if code.match(/\d\d0000000000$/) # is a province id  
      @selected_city_name= $province_region[code]
      @province_code=code
      @region=$citytree[@province_code]
      
    elsif code.match(/\d\d\d\d00000000$/)  and (not code.match(/\d\d0000000000$/))
      @selected_city_name= $province_region[code.slice(0,2)+"0000000000"]+$province_region[code]
      @province_code=code.slice(0,2)+"0000000000"
      @region_code=code  
      @region=$citytree[@province_code]
    else
      @province_code=code.slice(0,2)+"0000000000"
      @region_code=code.slice(0,4)+"00000000"
      @city_code=code
      @region=$citytree[@province_code]
      @selected_city_name= $province_region[@province_code]+$province_region[@region_code]+$citytree[@province_code][@region_code][code]
    end    
    
  end

  def get_city_full_name(code)
    if code.match(/\d\d0000000000$/) # is a province id
      city_name= $province_region[code]
      return city_name

    elsif code.match(/\d\d\d\d00000000$/)  and (not code.match(/\d\d0000000000$/))
      city_name= $province_region[code.slice(0,2)+"0000000000"]+$province_region[code]
      return city_name
    else
      province_code=code.slice(0,2)+"0000000000"
      region_code=code.slice(0,4)+"00000000"
      city_name= $province_region[province_code]+$province_region[region_code]+$citytree[province_code][region_code][code]
      return city_name
    end
  end
  
  def get_max_min_code(code)
    max_code,min_code=0
    if code.match(/\d\d0000000000$/) # is a province id 
      max_code=(code.to_i+10000000000).to_s     
      min_code=code
      iscity=false
    elsif code.match(/\d\d\d\d00000000$/)  and (not code.match(/\d\d0000000000$/))  # is a region
      iscity=false
      max_code=(code.to_i+100000000).to_s
      min_code=code
    else
      iscity=true
      max_code=code
      min_code=code
    end
    # puts "code=#{code},min_code=#{min_code},max_code=#{max_code},iscity=#{iscity}"
    [min_code,max_code,iscity]   
  end
  
  def is_province?(city)
    return true if city.match(/\d\d0000000000$/)
    return false
  end
  
  def is_region?(city)
    return true if city.match(/\d\d\d\d00000000$/)  and (not city.match(/\d\d0000000000$/))
    return false
  end

     
   
  def city_level(city)
    return if city.blank?
    is_city=Array.new
    city_array=Array.new
    if city.match(/\d\d0000000000$/) # is a province id 
      is_city=[true,false,false]
      city_array=[city]
      @province=city
      @province_name=$city_code_name[@province]#convert to name
    elsif city.match(/\d\d\d\d00000000$/) and (not city.match(/\d\d0000000000$/))
      is_city=[false,true,false]
      @province=city.slice(0,2)+"0000000000"
      @region=city.slice(0,4)+"00000000"    
      city_array=[@province,city]      
      @province_name=$city_code_name[@province]#convert to name
      @region_name=$city_code_name[@region]#convert to name
    else
      is_city=[false,false,true]
      @province=city.slice(0,2)+"0000000000"
      @region=city.slice(0,4)+"00000000"    
      @city=city
      city_array=[@province,@region,@city]
      @province_name=$city_code_name[@province]#convert to name
      @region_name=$city_code_name[@region]#convert to name
      @city_name=$city_code_name[@city]#convert to name
    end
    return [is_city,city_array]
  end
  
  def get_all_line_array(line)
    line_array=Array.new
    a=line.split("#")
    from_city=a[0]
    to_city=a[1]
    if  is_region?(from_city) and  is_region?(to_city)
     $region_code[from_city].each do |fcity|
        $region_code[to_city].each do |tcity|
            line_array<<fcity+"#"+tcity
             line_array<<tcity+"#"+fcity
        end
     end
      line_array<<line
       line_array<<to_city+"#"+from_city
    elsif not is_region?(from_city) and  is_region?(to_city)
      $region_code[to_city].each do |tcity|
        line_array<<from_city+"#"+tcity
          line_array<<tcity+"#"+from_city
      end
       line_array<<line
        line_array<<to_city+"#"+from_city
    elsif is_region?(from_city) and  not is_region?(to_city)
      $region_code[from_city].each do |fcity|
        line_array<<fcity+"#"+to_city
        line_array<<to_city+"#"+fcity
      end
       line_array<<line
        line_array<<to_city+"#"+from_city
    else
      line_array<<line
       line_array<<to_city+"#"+from_city
    end
    return line_array
  end
end
