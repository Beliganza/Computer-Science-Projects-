
import java.io.*;
import java.util.*;

/**
 * Compress and decompress files
 *
 * @author Pacifique Mucyo, Dartmouth College, Fall 2023
 * @author Ganza Belyse Aloyse, Dartmouth College, Fall 2023
 */

public class huffManCode implements Huffman {

    /**
     * A methode that reads a file and makes a map of characters and frequencies at which they appear
     * @param pathName - path to a file to read
     * @return a map that holds Characters as key and their frequencies as values
     * @throws IOException if the pathName doesn't exist or something else happens
     */
    public Map<Character, Long> countFrequencies(String pathName) throws IOException {
        // initializing the Map that holds
        Map<Character, Long> charCount = new HashMap<>();
        BufferedReader input = new BufferedReader(new FileReader(pathName));

        try {
            int intC = input.read();
        //While there are still characters to read in the file increase the frequency
            // of existing character or add the character to the map
            while(intC != -1) {
                char myChars = (char) intC;  //casting to get the integers back to characters
                if (charCount.containsKey(myChars)) {
                    charCount.put(myChars, charCount.get(myChars) + 1L); //increasing the frequency
                }
                else {
                    charCount.put(myChars, 1L);  //
                    }

                intC = input.read();
            }

            }  // closing the file and returning the map
        finally {
            input.close();
            }

            return charCount;
        }

    /**
     * Making a binary tree that has code tree element from a map of frequencies
     * @param frequencies a map of Characters with their frequency counts from countFrequencies
     * @return binary tree that holds code tree element
     */
    public BinaryTree<CodeTreeElement> makeCodeTree(Map<Character, Long> frequencies) {
        if (frequencies.isEmpty()){return null;}
        //creating a priority queue that holds the Binary tree with the code tree element and comparing the frequencies
        // using an anonymous comparator
        PriorityQueue<BinaryTree<CodeTreeElement>> pq = new PriorityQueue<>((el1, el2) -> Math.toIntExact(el1.getData().getFrequency() - el2.getData().getFrequency()));
        for (Character key : frequencies.keySet()){
            CodeTreeElement treeEl = new CodeTreeElement(frequencies.get(key), key);
            BinaryTree<CodeTreeElement> eachLeaf = new BinaryTree<>(treeEl);
            pq.add(eachLeaf);
        }
        // Making priority queue into a one element queue by combining the trees
        while (pq.size() > 1){
            BinaryTree<CodeTreeElement> T1 = pq.remove();
            BinaryTree<CodeTreeElement> T2 =  pq.remove();
            Long freq = T1.getData().getFrequency() + T2.getData().getFrequency();
            CodeTreeElement r = new CodeTreeElement(freq, null);
            BinaryTree<CodeTreeElement> T = new BinaryTree<>(r, T1, T2);
            pq.add(T);
        }


        BinaryTree<CodeTreeElement> lastEl = pq.remove();

        //Handling the case if we have one repeated character
        if(frequencies.size() == 1){
            return new BinaryTree<>(new CodeTreeElement(400L, null), lastEl, lastEl);
        }
        return lastEl;
    }

    /**
     * Making a map that holds each character with its unique code using a helper method
     * @param codeTree the tree for encoding characters produced by makeCodeTree
     * @return  a codemap
     */
    public Map<Character, String> computeCodes(BinaryTree<CodeTreeElement> codeTree) {
        // initialize the map and the empty string to hold the unique code
        Map<Character, String> codeMap = new HashMap<>();
        String codeSoFar = "";

        computeCodesHelper(codeTree, codeMap, codeSoFar);
        return codeMap;
    }

    /**
     * Helper for computing code since it is a recursive method
     * @param codeTree tree for encoding characters produced by makeCodeTree
     * @param codeMap map that holds characters with unique code
     * @param codeSoFar string of unique code
     */
    public void computeCodesHelper(BinaryTree<CodeTreeElement> codeTree, Map<Character, String> codeMap, String codeSoFar){
        // all characters will be at the leaf, so adding the character and it's code once you hit leaf
        if(codeTree.isLeaf()){
            codeMap.put(codeTree.data.getChar(), codeSoFar);
        }

        // Traversing left or right and incrementing the code with 0 or 1 accordingly
        else {
            if(codeTree.hasLeft()){
                computeCodesHelper(codeTree.getLeft(), codeMap, codeSoFar + "0");
            }
            if(codeTree.hasRight()){
                computeCodesHelper(codeTree.getRight(), codeMap, codeSoFar + "1");
            }
        }
    }

    /**
     * Compressing a bigger file into a smaller file
     * @param codeMap - Map of characters to codes produced by computeCodes
     * @param pathName - File to compress
     * @param compressedPathName - Store the compressed data in this file
     * @throws IOException if the file is not found or a null pointer exception or any other exception
     */
    public void compressFile(Map<Character, String> codeMap, String pathName, String compressedPathName) throws IOException {
        // reading the file to compress and opening the file to write in the compressed version(in bits)
        BufferedReader input = new BufferedReader(new FileReader(pathName));
        BufferedBitWriter bitOutput = new BufferedBitWriter(compressedPathName);


        int intChar = input.read();
        try {
            // while we have more things to read keep reading
            while(intChar != -1){
                char char1= (char) intChar;

                String codeChar1 = codeMap.get(char1);

                // looping over the characters of the unique code and writing bits(false if 0 and true if 1)
                for(int i =  0; i < codeChar1.length(); i++){
                    char c = codeChar1.charAt(i);
                    bitOutput.writeBit(c != '0');
                }
                intChar = input.read(); // keep reading
            }
        }

        // closing the files
        finally {
            input.close();
            bitOutput.close();
        }
    }

    /**
     * Decompressing a compressed version into the normal version
     * @param compressedPathName - file created by compressFile
     * @param decompressedPathName - store the decompressed text in this file, contents should match the original file before compressFile
     * @param codeTree - Tree mapping compressed data to characters
     * @throws IOException if the file is not found or a null pointer exception or any other exception
     */
    public void decompressFile(String compressedPathName, String decompressedPathName, BinaryTree<CodeTreeElement> codeTree) throws IOException {

        //Opening the compressed file and writing in the new decompressed
        BufferedBitReader bitInput = new BufferedBitReader(compressedPathName);
        BufferedWriter output = new BufferedWriter(new FileWriter(decompressedPathName));

        //Storing the tree in a temporary variable
        BinaryTree<CodeTreeElement> tempTree = codeTree;
        try {

            // looping if there are more bits to read
            while (bitInput.hasNext()) {
                boolean bit = bitInput.readBit();

                // moving right if bit is true which means 1
                if(bit){
                    tempTree = tempTree.getRight();

                }

                // moving left if bit is left which means 0
                else {
                    tempTree = tempTree.getLeft();
                }

                // if you hit the leaf then write into the decompressed file
                if(tempTree.isLeaf()){
                    output.write(tempTree.getData().getChar());
                    tempTree = codeTree;
                }

            }
        }
        finally {
            bitInput.close();
            output.close();
        }

    }

    public static void main(String[] args) throws IOException {

        // Making a test case that holds an object and testing it on USConstitution text
        huffManCode test = new huffManCode();
        String originalPathName = "/Users/pacifique/Documents/IdeaProjects/cs10/problemSet3/USConstitution.txt";
        String compressedPathName = "/Users/pacifique/Documents/IdeaProjects/cs10/problemSet3/CompressedUSConstitution.txt";
        String decompressedPathName = "/Users/pacifique/Documents/IdeaProjects/cs10/problemSet3/DecompressedUSConstitution.txt";


        Map<Character, Long> frequencyMap = null;
        BinaryTree<CodeTreeElement> codeTree = null;
        Map<Character, String> computeCodeMap = null;



        try {
            frequencyMap = test.countFrequencies(originalPathName);
        }
        catch (Exception e){
            System.err.println("File error while counting frequency: " + e.getMessage());
        }


        if (frequencyMap != null){ codeTree = test.makeCodeTree(frequencyMap);}

        if( codeTree != null){computeCodeMap = test.computeCodes(codeTree);}


        try {
            test.compressFile(computeCodeMap, originalPathName, compressedPathName);
        }

        catch (Exception e){
            System.err.println("Error while compressing: " + e.getMessage());
        }

        try {
            test.decompressFile(compressedPathName, decompressedPathName, codeTree);
        }

        catch (Exception e){
            System.err.println("Error while decompressing: " + e.getMessage());
        }

    }
}
