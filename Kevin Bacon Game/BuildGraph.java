import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.*;
/**
 * Building the Graph
 *
 * @author Pacifique Mucyo, Dartmouth College, Fall 2023
 * @author Ganza Belyse Aloyse, Dartmouth College, Fall 2023
 */
public class BuildGraph<V, E>{

    private static Graph<String, Set<String>> theActorsGraph = new AdjacencyMapGraph<>();
        public BuildGraph(){
        }

    /**
     * Method that reads actors
     * @return map of actors ID and Name  from actorsTest
     * @throws IOException
     */
    public static Map<Integer, String> readActors(String fileName) throws IOException {
            BufferedReader reader = new BufferedReader(new FileReader(fileName));
            String line;
            //reading the data from a file and moving them into a map
            Map<Integer, String> actorsToID = new HashMap<Integer, String>();
            while((line = reader.readLine()) != null){
                actorsToID.put(Integer.parseInt(line.split("\\|")[0]), line.split("\\|")[1]);
            }
            reader.close();
            return actorsToID;
        }

    /**
     * Method that reads the movies
     * @param fileName that has the file to read
     * @return a Map of movies ID
     * @throws IOException
     */

        public static Map<Integer, String> readMovies(String fileName) throws IOException{
            BufferedReader reader = new BufferedReader(new FileReader(fileName));
            Map<Integer, String> movies = new HashMap<>();
            String line;
            //reading the data from a file and moving them into a map
            while((line = reader.readLine()) != null){
                movies.put(Integer.parseInt(line.split("\\|")[0]), line.split("\\|")[1]);
            }
            reader.close();
            return movies;
        }

    /**
     * Methode that maps movieID and actorID
     * @param moviesFile
     * @param actorsFile
     * @param moviesActorFile
     * @return a Map of actorsToMovies
     * @throws IOException
     */
        public static Map<String, ArrayList<String>> actorsToMovies(String moviesFile, String actorsFile, String moviesActorFile) throws IOException {
            BufferedReader reader = new BufferedReader(new FileReader(moviesActorFile));
            Map<String, ArrayList<String>> moviesToActors = new HashMap<>(); //Map the movieID and actorID
            String line;

            while((line = reader.readLine()) != null){
                String movie =  readMovies(moviesFile).get(Integer.parseInt(line.split("\\|")[0]));
                String actor = readActors(actorsFile).get(Integer.parseInt(line.split("\\|")[1]));
                //if the movie exists in the map then add actor to the set of values associated with the movie
                // else add the movie to the map and its associated value
                if(moviesToActors.containsKey(movie)){
                    moviesToActors.get(movie).add(actor);
                } else{
                    ArrayList<String> value = new ArrayList<>();
                    value.add(actor);
                    moviesToActors.put(movie, value);
                }
            }

            reader.close();
            return moviesToActors;
        }

    /**
     * methode that makes the graph
     * @param actorsFile
     * @param moviesFile
     * @param moviesActorFile
     * @return a graph
     * @throws IOException
     */
        public static Graph<String, Set<String>> makeGraph(String actorsFile, String moviesFile, String moviesActorFile) throws IOException {
            // looping  through actors from the actors file and inserting  each actor into the graph as a vertex


            for(Map.Entry<Integer, String> actor: readActors(actorsFile).entrySet()){
                theActorsGraph.insertVertex(actor.getValue());
            }


            // looping through movies from the movies file and labeling edges
            for (Map.Entry<String, ArrayList<String>> entry : actorsToMovies(moviesFile, actorsFile, moviesActorFile).entrySet()) {
                String movie = entry.getKey();
                ArrayList<String> actors = entry.getValue();
                for (int i = 0; i < actors.size(); i++) {
                    for (int j = i + 1; j < actors.size(); j++) {
                        String actorI = actors.get(i);
                        String actorJ = actors.get(j);
                        // adding edges that didn't exist before
                        if (!theActorsGraph.hasEdge(actorI, actorJ)) {
                            Set<String> values = new HashSet<>();
                            values.add(movie);
                            theActorsGraph.insertUndirected(actorI, actorJ, values);
                        } else {   //updating edges that were already there
                            Set<String> set = theActorsGraph.getLabel(actorI, actorJ);
                            set.add(movie);
                            theActorsGraph.insertUndirected(actorI, actorJ, set);
                        }
                    }
                }
            }

            return theActorsGraph;


        }
    }



