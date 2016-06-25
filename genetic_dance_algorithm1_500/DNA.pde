// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Genetic Algorithm, Evolving Shakespeare

// A class to describe a psuedo-DNA, i.e. genotype
//   Here, a virtual organism's DNA is an array of character.
//   Functionality:
//      -- convert DNA into a string
//      -- calculate DNA's "fitness"
//      -- mate DNA with another set of DNA
//      -- mutate DNA


class DNA {

  // The genetic sequence
  int[] genes;
  float fitness;
  color[] dna_color;
  
  // Constructor (makes a random DNA)
  DNA(color[] dna_col) {
    genes = new int[length_of_sequence];
    dna_color = dna_col;
    for (int i = 0; i < length_of_sequence; i++) {
      genes[i] = int(random(0,number_of_moves));  // Pick from range of chars
    }
    
    
  }
  
  //Constructor 2, creates instance based on an existing array
  DNA(int[] newgenes, color[] dna_c) {
    dna_color = dna_c;
    genes = newgenes;
  }
  
//  // Converts character array to a String
//  String getPhrase() {
//    return new String(genes);
//  }
  
  // Fitness function (returns floating point % of "correct" characters)
  void fitness (String target) {
     int score = 0;
     for (int i = 0; i < genes.length; i++) {
        if (genes[i] == target.charAt(i)) {
          score++;
        }
     }
     
     
     fitness = (float)score / (float)target.length();
  }
  
  //crossover
  DNA crossover(DNA partner){
    int[] child = new int[genes.length];
    color[] child_dn_col = new color[length_of_sequence];
    //pick midpoint
    int crossover = int(random(genes.length));
    //take half of one and half from the other
    for (int i = 0; i < genes.length; i++) {
// random midpoint method
//      if(i > crossover){
//        child[i] = genes[i];
//        child_dn_col[i] = dna_color[i];
//      }
//      else{
//        child[i] = partner.genes[i];
//        child_dn_col[i] = partner.dna_color[i];
//      }

// select parent for each gene at random
      int a = 0;
      if(crossover_mode == 1) a = i;
      else if(crossover_mode ==2) a = int(random(genes.length));
      
      if(random(1) > 0.5){
        child[i] = genes[a];
        child_dn_col[i] = dna_color[a];
      }else{
        child[i] = partner.genes[a];
        child_dn_col[i] = partner.dna_color[a];
      }
    }
    DNA newgenes = new DNA(child, child_dn_col);
    return newgenes;
  }
  
  // Based on a mutation probability, picks a new random character
  // dancer index needed for tryout
  void mutate(float mutationRate) {
    for (int i = 0; i < genes.length; i++) {
      //secind opart of function assures only not target genes are mutated .... i guess that is cheating?
      if (random(1) < mutationRate) {
        genes[i] = int(random(number_of_moves));
        
        //show mutation through darkening of the color
        
        float factor1 = 0.85;
        float factor2 = 2 - factor1;
        if(random(1)<=0.5){
          dna_color[i] = color((int(red(dna_color[i])*factor1)),(int(green(dna_color[i])*factor1)),(int(blue(dna_color[i])*factor1)));
        }else {
          dna_color[i] = color((int(red(dna_color[i])*factor2)),(int(green(dna_color[i])*factor2)),(int(blue(dna_color[i])*factor2)));
        }
        
      }
    }
  }
}
