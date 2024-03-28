# Author: Ganza Belise Aloysie Isingizwe
# Date: 03/02/2023
# Purpose: Lab 2 checkpoint

from city import City

 #reading the elements in from world_cities
fp = open("cities_population.txt", "r")
#fp_w = open("cities_out.txt ", "w")  #writing the elements from world_cities into cities_out
city_list = []    #creating the list that will include a list of striped and splitted cities

for line in fp:
    city = line.strip().split(",")   #striping and spliting
    object = City(country_code="", name=city[0], city_region="", population=city[1], latitude=city[2], longitude=city[3])    #objects
    city_list.append(object)     #adding objects to the list


#stop reading and writing
fp.close()
#fp_w.close()