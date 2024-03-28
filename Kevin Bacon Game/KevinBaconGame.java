
import java.util.*;
/**
 * The Kevin Bacon Game
 *
 * @author Pacifique Mucyo, Dartmouth College, Fall 2023
 * @author Ganza Belyse Aloyse, Dartmouth College, Fall 2023
 */
public class KevinBaconGame {
    public static void main(String[] args) throws Exception {

        // file we read
        String actorsFile = "/Users/pacifique/Documents/IdeaProjects/cs10/PS4/actors.txt";
        String moviesFile = "/Users/pacifique/Documents/IdeaProjects/cs10/PS4/movies.txt";
        String moviesActorFile = "/Users/pacifique/Documents/IdeaProjects/cs10/PS4/movie-actors.txt";

        boolean gameStart = true; // boolean that allows to start and end the game
        Graph<String, Set<String>> theActorsGraph= BuildGraph.makeGraph(actorsFile, moviesFile, moviesActorFile); // making the graph

        String uniCenter = "Kevin Bacon"; // setting Kevin Bacon as the initial Center

        Graph<String, Set<String>> bfsGraph = graphLibrary.bfs(theActorsGraph, uniCenter); // graph for BFS

        // commands to print before the game begins
        System.out.println("Welcome to the Bacon game. Here are some rules to follow: \n"+
                "c <#>: list top (positive number) or bottom (negative) <#> centers of the universe, sorted by average separation\n" +
                "d <low> <high>: list actors sorted by degree, with degree between low and high\n" +
                "i: list actors with infinite separation from the current center\n" +
                "p <name>: find path from <name> to current center of the universe\n" +
                "s <low> <high>: list actors sorted by non-infinite separation from the current center, with separation between low and high\n" +
                "u <name>: make <name> the center of the universe\n" +
                "q: quit game");


        while (gameStart){
            // Reading from the Keyboard
            Scanner scanner = new Scanner(System.in);
            System.out.println("Enter your command: ");
            String line = scanner.nextLine();

            // p <name>: find path from <name> to current center of the universe
            for(int i = 0; i<line.length(); i++){
                try {
                    //CONDITION FOR U "u <name>: make <name> the center of the universe\n"
                if (line.charAt(i) == 'u') {
                    Scanner scanner2 = new Scanner(System.in);
                    System.out.println("Enter your new center: ");
                    String line2 = scanner2.nextLine();
                    bfsGraph = graphLibrary.bfs(theActorsGraph, line2);

                    if (bfsGraph !=null){
                        System.out.println(line2 + " is now the center of the acting universe, connected to " +
                                bfsGraph.numVertices() + "/" + theActorsGraph.numVertices() +
                                " actors with average separation " + graphLibrary.averageSeparation(bfsGraph,line2));}
                }


                else if(line.charAt(i) == 'p'){
                    String name =  line.substring(2);

                    //Check if the graph's vertex corresponds to the extracted name or not
                    if(!theActorsGraph.hasVertex(name)){
                        System.out.println("Person not among the movie stars");
                    }
                    else { //if vertex found print the statement indicated
                        assert bfsGraph != null;
                        System.out.println("The path from " + name + " to the center of the universe:  " + graphLibrary.getPath(bfsGraph, name));
                        }
                    }

                //CONDITION FOR D "d <low> <high>: list actors sorted by degree, with degree between low and high\n"
                else if(line.charAt(i) == 'd') {
                    ArrayList<String> actorsByDegree = new ArrayList<>();
                    int low = Integer.parseInt(line.split(" ")[1]);
                    int high= Integer.parseInt(line.split(" ")[2]);

                    if (low > high) {
                        System.out.println("The input not well ordered, try again.");
                    }
                    for (String actorNode : theActorsGraph.vertices()) {
                        int degree = theActorsGraph.outDegree(actorNode);
                        if ( degree >= low && degree <= high) {
                            actorsByDegree.add(actorNode);
                        }
                    }
                    actorsByDegree.sort(Comparator.comparingInt(theActorsGraph::outDegree));
                    System.out.println(actorsByDegree); // come up with a better printing format
                }

                // list actors with infinite separation from the current center
                else if(line.charAt(i) == 'i'){
                    Set<String> missingVertices = graphLibrary.missingVertices(theActorsGraph, bfsGraph);
                    System.out.println("Missing vertices: " + missingVertices);
                }

                //list actors sorted by non-infinite separation from the current center, with separation between low and high
                else if(line.charAt(i) =='s') {
                    int low2 = Integer.parseInt(line.split(" ")[1]);
                    int high2 = Integer.parseInt(line.split(" ")[2]);
                    List<Map.Entry<String, Integer>> sortedFinite = new ArrayList<>();

                    if (low2 > high2) {
                        System.out.println("The input not well ordered, try again.");
                    }

                    Map<String, Integer> separationMap = new HashMap<>();
                    for(String vertex: theActorsGraph.vertices()){
                        assert bfsGraph != null;
                        List<String> shortPath = graphLibrary.getPath(bfsGraph, vertex);
                        if(shortPath != null) {
                            int pathSize  = shortPath.size();
                            if(low2 <= pathSize && high2 >= pathSize){
                                separationMap.put(vertex, pathSize);
                        }

                    }
                    }
                    sortedFinite.addAll(separationMap.entrySet());
                    sortedFinite.sort(( s1, s2) -> (int) (separationMap.get(s1) - separationMap.get(s2)));
                    System.out.println(sortedFinite);

                }

                //c <#>: list top (positive number) or bottom (negative) <#> centers of the universe, sorted by average separation
                else if (line.charAt(i) == 'c' && line.length() > 2){

                    List<Map.Entry<String, Integer>> sortedList = new ArrayList<>();
                    Map<String, Integer> theSeparation = new HashMap<>();
                    int intValue = Integer.parseInt(line.substring(2));

                    boolean printFromBack = intValue < 0; // this allows us to print from the back if the intValue is greater than 0
                    intValue = Math.abs(intValue);

                    for(String vertex : theActorsGraph.vertices()){
                        int separation = (int) graphLibrary.averageSeparation(graphLibrary.bfs(theActorsGraph, vertex), vertex);
                        theSeparation.put(vertex, separation);
                    }
                    // sort the list in place
                    sortedList.addAll(theSeparation.entrySet());
                    sortedList.sort((s1, s2) -> theSeparation.get(s1) - theSeparation.get(s2));


                    for (int k = 0; k < intValue; k++) {
                        int index = (printFromBack) ? sortedList.size() - (k + 1) : k;
                        String currentActor = sortedList.get(index).getKey();
                        double separation = theSeparation.get(currentActor);
                        System.out.println(currentActor + " with avg separation " + separation);
                    }

                }

                // quit game if q pressed
                else if(line.charAt(i) == 'q') {
                    gameStart = false;
                }
            }
                catch (Exception e){
                    System.out.println("Invalid Input format");
                }
            }
        }
    }
}
