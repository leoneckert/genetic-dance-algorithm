class Dancer{
  PVector location;
  float dancer_size;
  
  
  float max_ind_fitness = 1;
  
  DNA dna;
  float fitness;
  boolean[] moves_done;
  int currentmove;

  boolean sequenceDone;
  
  int dancer_index_number;
  int correct_moves;
  
  Dancer(int d_index, PVector loc, float size, DNA dna_){
    dancer_index_number = d_index;
    location = new PVector(loc.x, loc.y); 
    dancer_size = size;
    //for now:
    dna = dna_;
    
    fitness = 1;
    correct_moves = 0;
    moves_done = new boolean[dna.genes.length];
    
    for(int i = 0; i < dna.genes.length; i++){
      moves_done[i] = false;
    }
    
    currentmove = 0;

    sequenceDone = false;
  }
  
  
  void display(){ 
    
    
    for(int i = 0; i < dna.genes.length-1; i++){
      if(moves_done[i] == true){
        currentmove = i+1;
      }
    }
    
    
    if(sequenceDone == false){
      all_moves.play(dancer_index_number, dna.genes[currentmove], location.x - (dancer_size/2), location.y - dancer_size, dancer_size);
    }else if(sequenceDone){
      all_moves.playFrame(((all_moves.getFrames_of_move(dancer_index_number, dna.genes[moves_done.length-1]))-1), dancer_index_number, dna.genes[moves_done.length-1], location.x - (dancer_size/2), location.y - dancer_size, dancer_size);
    }
    
    
    
    
    if(((all_moves.getCurrentFrame_of_move(dancer_index_number, dna.genes[currentmove])) + 1) == all_moves.getFrames_of_move(dancer_index_number, dna.genes[currentmove])){
      all_moves.moves[dancer_index_number][dna.genes[currentmove]].reset();
      moves_done[currentmove] = true;
      
      if(currentmove == length_of_sequence -1){
        sequenceDone = true; 
        //println("sequence count!!");
      }
      
    }
    
    //show dna
    for(int i = 0; i < dna.genes.length; i++){
      fill(dna.dna_color[i]);
      if(show_colour == true && pure == false)rect(location.x - 16, location.y + 7 + i*15, 5, 15);
      
      fill(255);
      //moves that match target light red
//      if(all_moves.getCategory(target, dancer_index_number, dna.genes[i])){
//       fill(156,156,255); 
//      }
      //current move red
      if(i == currentmove && sequenceDone==false ){
       fill(255,0,0); 
      }
      textSize(12);
      textAlign(LEFT);
      //arrow behiond moves that fit the target
      if(!pure){
        if(all_moves.getCategory(target, dancer_index_number, dna.genes[i])){
          text(dna.genes[i] + " ~", location.x, location.y + 18 + i*15);
        }else{
          text(dna.genes[i], location.x, location.y + 18 + i*15);
        }
      }
      
      
      //text(dna.genes[i], location.x, location.y + 18 + i*15);
      
      
    }

  }
  
  //fitness
//  void fitness() {
//    int sequence = 0;
//    int max_sequence = 0;
//    
//    for(int i = 0; i < dna.genes.length; i++){
//     
//      
//      max_ind_fitness+=((2*number_of_moves)/length_of_sequence);
//      //max_ind_fitness*=max_ind_fitness;
//      max_sequence++;
//      if(max_sequence >=2 ){
//       max_ind_fitness += max_sequence*length_of_sequence;
//      }
//      
//      if(all_moves.getCategory(target, dancer_index_number, dna.genes[i])){
//        fitness+=((2*number_of_moves)/length_of_sequence);
//        //fitness*=fitness;
//        sequence++;
//        if(sequence >= 2){
//            println(" sequence of " + sequence + "!!");
//            fitness += sequence*length_of_sequence;
//        }
//      }else{
//        sequence = 0;
//      }
//    }
//    //fitness = fitness*fitness;
//    fitness = 1 + fitness;
//    max_ind_fitness = 1 + max_ind_fitness;
//    graph.max_overall = max_ind_fitness * number_of_dancers;
//    println("Fitness of dancer " + dancer_index_number + " ---> " + fitness + " of " + max_ind_fitness);
//  }
void fitness() {
    int sequence = 0;
    int max_sequence = 0;
    int multiple = 0;
    int max_multiple = 0;
    float low_value = 0;
    
    for(int i = 0; i < dna.genes.length; i++){
     
      
      max_ind_fitness+= 30;
      //max_ind_fitness *= (1+ 0.1*max_ind_fitness);
      max_sequence++;
      max_multiple++;
      if(max_sequence >=2 ){
       //max_ind_fitness += max_sequence * max_sequence * length_of_sequence;
       max_ind_fitness += 80;
      }
      if(max_multiple >=2){
        max_ind_fitness += 50;
      }
      
      
      if(all_moves.getCategory(target, dancer_index_number, dna.genes[i])){
        correct_moves ++;
        fitness+= 30;
        //fitness *= (1+ 0.1*fitness);
        sequence++;
        multiple++;
        if(sequence >= 2){
            println(" sequence of " + sequence + "!!");
            //fitness += sequence * sequence * length_of_sequence;
            fitness += 80;
        }
        if(multiple >= 2){
           fitness += 50;
        }
       }else{
        sequence = 0;
      }
    }
    
    //fitness = fitness*fitness;
//    fitness = 1 + fitness;
//    max_ind_fitness = 1 + max_ind_fitness;
    graph.max_overall = max_ind_fitness * number_of_dancers;
    println("Fitness of dancer " + dancer_index_number + " ---> " + fitness + " of " + max_ind_fitness);
  }


 
  
  float getFitness() {
   return fitness;
  }
 
  DNA getDNA() {
   return dna;
 }
  
  
}
