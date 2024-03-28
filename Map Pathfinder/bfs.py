# Author: Ganza Belise Aloysie Isingizwe
# Date: 03/08/2023
# Purpose: BFS


from collections import deque


# initialize an empty queue and dictionary

def bfs(start_point, final_goal):
    global queue, pointer_dict
    queue = deque()
    pointer_dict = {}

    # enqueue the start vertex and add it to the dictionary(to mark them as visited)
    queue.append(start_point)
    pointer_dict[start_point] = None

    while (len(queue) != 0) and (final_goal not in pointer_dict):
        # removing the visited vertex
        vertex = queue.popleft()
        # looping through all unvisited vertices

        for neighbour in vertex.list_of_obj:
            if neighbour not in pointer_dict:
                # add the vertices to the queue and mark them as visited and stop when target is reached
                queue.append(neighbour)
                pointer_dict[neighbour] = vertex
            # if neighbour == final_goal:
            #     break

    # reconstructing the path in reverse
    reversed_vertex = final_goal
    the_path = []

    # until the start vertice is reached, add the vertices to the path
    while reversed_vertex != None:
        the_path.append(reversed_vertex)
        pd = pointer_dict[reversed_vertex]
        reversed_vertex = pd
    the_path.append(start_point)

    # returning the path
    return the_path
