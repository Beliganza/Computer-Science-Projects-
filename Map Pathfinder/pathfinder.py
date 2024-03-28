# Author: Ganza Belise Aloysie Isingizwe
# Date: 03/08/2023
# Purpose: Pathfinder


from cs1lib import *
from load_graph import load_graph
from vertex import Vertex
from bfs import bfs

# loading the image and dictionary of Vertex objects from their files
img = load_image("dartmouth_map.png")
vertices = load_graph("dartmouth_graph.txt")

# initializing the starting and final vertices as None
starting_vertex = None
final_vertex = None
clicked = False

# press and release functions implement mouse control
# x_press = m_x
# y_press = m_y

def mouse_press1(m_x, m_y):
    global clicked, x_press, y_press, starting_vertex
    clicked = True

    for vertex in vertices:
        # checking if the mouse is hovering above a vertex
        if vertices[vertex].on_vertex(m_x, m_y):
            starting_vertex = vertices[vertex]

# x_move = mx
# y_move = my

def mouse_move1(mx, my):
    global x_move, y_move, final_vertex

    #what happens if when we click on the vertex
    if clicked:
        for vertex in vertices:
            if vertices[vertex].on_vertex(mx, my):
                final_vertex = vertices[vertex]


#drawing vertices
def main_draw():
    global starting_vertex, final_vertex
    # print(starting_vertex,final_vertex)
    clear()
    draw_image(img, 0, 0)
    for vertex in vertices:
        # draws the rest the vertices in blue
        vertices[vertex].draw_vertex(0, 0, 1)
        vertices[vertex].draw_edges(0, 0, 1)


    # calling the bfs algorithm to compute the path between the two points and joins them in red
    # if starting_vertex != None:
    path = bfs(starting_vertex, final_vertex)
    for i in range(len(path) - 1):
        path[i].draw_vertex(1,0,0)
        path[i].draw_edge(path[i + 1], 1, 0, 0)


start_graphics(main_draw, width=1012, height=811, mouse_press=mouse_press1, mouse_move=mouse_move1)
