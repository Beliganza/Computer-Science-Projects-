# Author: Ganza Belise Aloysie Isingizwe
# Date: 03/08/2023
# Purpose: Creating the load graph function

from vertex import *

#a function that splits and returns the vertex_name, adjacent, x_coordinate and y_coordinate
def function_1(line):
    section_split = line.split(";")
    vertex_name = section_split[0].strip()

    adjacent_vertices = section_split[1].strip().split(",")

    # creating ban empty list where we  add all except empty strings
    adjacent = []
    for a in adjacent_vertices:
        if a:
            adjacent.append(a.strip())    #adding elements in the list

    cord = section_split[2].strip().split(",")
    x = cord[0].strip()      #the x_coordinate
    y = cord[1].strip()      # the y_coordinate
    return vertex_name, adjacent, x, y

#creating the load graph function
def load_graph(filename):
    vertex_dict = {}

    # Reading the lines in the file into a list of lines:
    file = open(filename, "r")

    for l in file:

        # splitting lines using a semicolon  and checking whether the line is in the right format
        if len(l.split(";")) == 3:
            vertex_name, adjacent, x, y = function_1(l)

        # create a graph vertex here and add it to the dictionary
        vertex = Vertex(vertex_name, int(x), int(y), [])
        vertex_dict[vertex_name ] = vertex
    file.close()

    file = open(filename, "r")

    for l in file:
        #spliting using a semi colon
        section_split = l.split(";")
        vertex_name = section_split[0].strip()

        adjacent_vertices = section_split[1].strip().split(",")

         # adding elements in the list created in function_1
        adjacent = []
        for a in adjacent_vertices:
            adjacent.append(a.strip())
        # updating the list_of_obj for every vertex
        vertex_object = vertex_dict[vertex_name]
        for ele in adjacent_vertices:
            vertex_object.list_of_obj.append(vertex_dict[ele.strip()])

    file.close()
    #returning the vertex dictionary
    return vertex_dict



