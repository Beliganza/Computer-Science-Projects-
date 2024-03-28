import java.util.*;
/**
 * The Graph library
 *
 * @author Pacifique Mucyo, Dartmouth College, Fall 2023
 * @author Ganza Belyse Aloyse, Dartmouth College, Fall 2023
 */
public class graphLibrary {

    /**
     * finding the shortest path
     * @param g
     * @param source
     * @return a graph
     * @param <V>
     * @param <E>
     */
    public static <V, E> Graph<V, E> bfs(Graph<V, E> g, V source) {
        Graph<V, E> pathTree = new AdjacencyMapGraph<>();
        Queue<V> queue = new LinkedList<V>();  // queue to implement BFS

        //if there's no vertex return null otherwise make it the start point
        if (!g.hasVertex(source)) {
            return null;
        }
        queue.add(source); //enqueue start vertex
        pathTree.insertVertex(source);

        //looping until there are  no more vertices
        while (!queue.isEmpty()) {
            V u = queue.remove(); //dequeue

            //looping over out neighbors
            for (V v : g.outNeighbors(u)) {
                if (!pathTree.hasVertex(v)) {
                    queue.add(v); //enqueue neighbor
                    pathTree.insertVertex(v);
                    pathTree.insertDirected(v, u, g.getLabel(u, v));
                }
            }
        }
        return pathTree;
    }

    /**
     * Methode that gets the path
     * @param tree
     * @param v
     * @return a list of path from vertex v to tree
     * @param <V>
     * @param <E>
     */
      public static <V, E> List<V> getPath(Graph<V, E> tree, V v) {
        //list to store the path
        ArrayList<V> listPath = new ArrayList<>();
        if (!tree.hasVertex(v))
            return null;

        listPath.add(v);

       //iterate over the outNeighbors of the current vertex and adding them to the list
          Iterator<V> iterator = tree.outNeighbors(v).iterator();
          while(iterator.hasNext()){
              V vertex = iterator.next();
              listPath.add(vertex);
              iterator = tree.outNeighbors(vertex).iterator();
        }
        return listPath;
    }

    /**
     * a method that finds the missing vertices
     * @param graph
     * @param subgraph
     * @return a set of the vertices
     * @param <V>
     * @param <E>
     */
    public static <V, E> Set<V> missingVertices(Graph<V, E> graph, Graph<V, E> subgraph) {
        Set<V> verticesMissed = new HashSet<>();
        //compare main graph and our subGraph  and
        // if the vertex is not common to both graphs, add it to the set
        for (V v : graph.vertices()) {
            if (!subgraph.hasVertex(v)) {
                verticesMissed.add(v);
            }
        }
        return verticesMissed;

    }

    /**
     * a method that finds the average separation using a helper method
     * @param tree
     * @param root
     * @return a double that represents the separation
     * @param <V>
     * @param <E>
     */
    public static <V, E> double averageSeparation(Graph<V, E> tree, V root) {
        //call the separationHelper method to calculate the total separation starting from the root
        //and calculating the total separation
        int totalSeparation = separationHelper(tree, root, 0);
        return (double) totalSeparation / (tree.numVertices());
    }

    /**
     * a helper method for finding the separation
     * @param tree
     * @param node
     * @param sep
     * @return an integer
     * @param <V>
     * @param <E>
     */
    public static <V, E> int separationHelper(Graph<V, E> tree, V node, int sep) {
        int total = sep;
        //Iterate over the inNeighbours of the current node
        // and recursively call separation Helper to update the separation value
        for (V v: tree.inNeighbors(node)) {
            total += separationHelper(tree, v, sep + 1);
        }
        //return the total separation
        return total;
    }

}



