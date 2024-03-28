# Author: Ganza Belise Aloysie Isingizwe
# Date: 03/02/2023
# Purpose: visualizing the cities

from cs1lib import*
from city_reading import city_list

i=0
new_list = []
WINDOW_X = 720     #window width
WINDOW_Y = 360     #window height
FRAMERATE = 15

#the map where the citiea are supposed to show
img = load_image("world map .png")

def draw():
    global i
    clear()
    draw_image(img, 0, 0)
    CITY_NUMBER = 50     #the number of cities given

    for element in new_list:    #goes through of cities and draws them
        element.draw(WINDOW_X/2, WINDOW_Y/2)

    if i < CITY_NUMBER:   #adding more cities to the list
        new_list.append(city_list[i])
        i += 1

    print(city_list)


start_graphics(draw, width=WINDOW_X, height=WINDOW_Y, framerate=FRAMERATE)