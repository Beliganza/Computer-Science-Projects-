# Author: Ganza Belise Aloysie Isingizwe
# Date: 03/02/2023
# Purpose: Lab 1 checkpoint

from cs1lib import *
class City:
    #Creating instance variables
    def __init__(self, country_code, name, city_region, population, latitude, longitude ):
        self.country_code=country_code
        self.name= str(name)
        self.city_region= city_region
        self.population= int(population)
        self.latitude = float(latitude)
        self.longitude = float(longitude)
    #returning the name, population, latitude and longitude
    def __str__(self):
        return str(self.name) + ',' + str(self.population) + ',' + str(self.latitude) + ',' + str(self.longitude)
    #drawing the cities
    def draw (self, cx, cy):
         #drawing circles that show the cities locations
         #setting the color to purple/pink
        r=1
        g=0
        b=1
        set_fill_color(r,g,b)

        #scaled values
        px = cx + ((float(self.longitude) * 2))
        py= cy - ((float(self.latitude) * 2))

        RAD= 5   #radius
        draw_circle(px, py, RAD)    #showing the city's real life location on the map

