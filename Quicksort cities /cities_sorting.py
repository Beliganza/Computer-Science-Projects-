# Author: Ganza Belise Aloysie Isingizwe
# Date: 03/02/2023
#Purpose: Sorting cities

from Quicksort import*
from city_reading import city_list

# Comparing cities populations
def comparing_population(city1, city2):
    return city1.population >= city2.population


# Comparing the cities names
def comparing_city_name(city1, city2):
    return city1.name.lower() <= city2.name.lower()


# Comparing cities latitudes
def comparing_latitude(city1, city2):
    return city1.latitude <= city2.latitude


 # sorting city_list increasing order of latitude values
def sorting_latitudes():
    sort(city_list, comparing_latitude)
    file = open('cities_latitude.txt', 'w')
    for city in city_list:
        cities = str(city), "\n"
        file.writelines(cities)
    file.close()

#sorting city_list in order of population's increasing values
def sorting_populations():
    sort(city_list, comparing_population)
    file = open('cities_population.txt', 'w')
    for city in city_list:
        cities = str(city), "\n"
        file.writelines(cities)

    file.close()

# sorting city_list in alphabetic order
def sorting_names():
    sort(city_list, comparing_city_name)
    file = open('cities_alpha.txt.txt', 'w')
    for city in city_list:
        cities = str(city), "\n"
        file.writelines(cities)
    file.close()


#calling the functions
sorting_populations()
sorting_names()
sorting_latitudes()
