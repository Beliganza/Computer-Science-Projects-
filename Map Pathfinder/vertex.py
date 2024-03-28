# Author: Ganza Belise Aloysie Isingizwe
# Date: 03/08/2023
# Purpose: Creating vertex objects

VERTEX_RADIUS = 5
EDGE_WIDTH = 2
from cs1lib import *

class Vertex:
     #creating the instance varaibles
    def __init__(self, name, x_location, y_location, list_of_obj):
        self.name = name
        self.x_location= x_location
        self.y_location = y_location
        self.list_of_obj = list_of_obj

    #creating a list of names
    def name_creation(self):
        names_list = []
        for element in self.list_of_obj:
            names_list.append(element.name)

        return names_list

   # drawing the vertex on the map
    def draw_vertex(self, r, g, b):
        set_fill_color(r, g, b)
        set_stroke_color(r, g, b)
        draw_circle(self.x_location, self.y_location, VERTEX_RADIUS)

    # drawing an edge between two vertices
    def draw_edge(self, vertex, r, g, b):
        set_stroke_color(r, g, b)
        set_stroke_width(EDGE_WIDTH)
        draw_line(self.x_location, self.y_location, vertex.x_location, vertex.y_location)

    # drawing the edges between the vertex and its adjacent vertices
    def draw_edges(self, r, g, b):
        for vertex in self.list_of_obj:
            self.draw_edge(vertex, r, g, b)

    # checking whether a point (x, y) lies on a vertex
    def on_vertex(self, x, y):
        # global VERTEX_RADIUS
        return self.x_location - VERTEX_RADIUS < x < self.x_location + VERTEX_RADIUS \
               and self.y_location - VERTEX_RADIUS < y < self.y_location + VERTEX_RADIUS

        # x_range = range()
        # y_range = range()









