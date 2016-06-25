class All_dancers {
  
  Dancer[] dancers;
  
  // for each dancer, this arrays shows the possition: e.g. array is {4,4,3,1,2} means dancer 0 is on rank 4 together with dancer 2, dancer 2 is on rank 3 etc.
  int[] fitness_ranking;
  // shows the dancers in order of ranking, e.g. if array is {3,4,2,0,1}, then dancer 3 is on rank 1, dancer 4 is on rank rank 2, dancer 2 on rank 3 etc.
  int[] dancer_ranking;
  int best;
  int worst;
  float max_overall;
  int generation;
  int generation_counter = 0;
  float mutationRate = 0.9;
  float overall = 0;
  ArrayList<Dancer> matingPool;
  
  boolean performanceTime;
  boolean rankingTime;
  boolean reproductionTime;
  float ranking_time_counter;
  int time_left;
  int fertils_correct_moves;
  
  
  All_dancers(int num){
    
    // creates new dancers
    dancers = new Dancer[num];
    fitness_ranking = new int[num];
    dancer_ranking = new int[num];
    generation = 1;
    
    matingPool = new ArrayList<Dancer>();
    
    //initializes a new point for each of these arrays and passes the values needed and the names
    println();
    println();
    println("//////////////////////////////// Generation " + generation + " ////////////////////////////////");
    println();
    println();
    println("DNA of Generation " + generation + ":");
    for(int i = 0; i < dancers.length; i++){
      PVector location_of_dancer = new PVector((i*(width/num)) + ((width/num)/2), height/2);
      float width_of_dancer = (width/num);
      color dna_c = color(random(0,255),random(0,255),random(0,255));
      color[] col_array = new color[length_of_sequence];
      for(int j = 0; j < length_of_sequence; j++){
        col_array[j] = dna_c;
      }
      dancers[i] = new Dancer(i, location_of_dancer, width_of_dancer, new DNA(col_array));  
      
      //printing each dancers initial DNA
      print("DNA of dancer " + (i) + " ---> ");
      for(int j = 0; j < dancers[i].dna.genes.length; j++){
        print(dancers[i].dna.genes[j] + ", ");
      }
      println();
    }
    println();
    println();
    
    time_left = length_of_sequence;
    performanceTime = true;
    rankingTime = false;
    reproductionTime = false;
    for(int i = 0; i < dancers.length; i++){
       fitness_ranking[i] = 0;
       dancer_ranking[i] = -1;
    } 
    fertils_correct_moves = 0;
  
  }
 
  void display(){
      textSize(12);
      fill(255);
      textAlign(LEFT);
      if(!pure) text("Generation: " + generation, 15,15); 
      int averageFrame = 0;
      for(int i = 0; i < dancers.length; i++){
        averageFrame += dancers[i].currentmove;
      }
      time_left = length_of_sequence - (averageFrame/dancers.length);
      if(!performanceTime) time_left = 0;
      if(show_options) text("Remaining lifetime: " + time_left, 150,15); 
      for(int i = 0; i < dancers.length; i++){
       dancers[i].display();
      } 
  }
  
  void checkPerformance(){
    int c = 0;
    for(int i = 0; i < dancers.length; i++){
       if(dancers[i].sequenceDone){
         c++;
       }
    }
    if(c == dancers.length){
      performanceTime = false;
      rankingTime = true;
    } 
  }
  
  void fitness(){
    println("Fitness of Generation " + generation + ":");
    
    for(int i = 0; i < dancers.length; i++){
       dancers[i].fitness();
       overall += dancers[i].getFitness();
    } 

    println();
    println();
    max_overall = ((dancers[0].max_ind_fitness)*dancers.length);
    graph.update_fitness(overall);
    println("Overall fitness of Generation " + generation + " ---> " + overall + " of " + ((dancers[0].max_ind_fitness)*dancers.length));
    println();
    println();
    //making sure that not every dancers fitness is 0:
    if(overall == 0){
      for(int i = 0; i < dancers.length; i++){
       dancers[i].fitness = 1;
       
    }
    }
    
  }
  
  void rank() { 
    println("Ranking of Generation " + generation + ":");
    for(int i = 0; i < dancers.length; i++){
      int ranking = 1;
      for(int j = 0; j < dancers.length; j++){
        if(dancers[i].getFitness() < dancers[j].getFitness()){
         ranking++; 
        }
      }
      fitness_ranking[i] = ranking;
    }
    
    
    //the following loops sort the fitness_ranking array into the dancer_ranking array, this might be possible to do shorte
    for(int i = 0; i < fitness_ranking.length; i++){
      int record_rank = dancers.length+1;
      int record_index = i;
      for(int j = 0; j < fitness_ranking.length; j++){
        boolean tested = false;
        for(int g = 0; g < dancer_ranking.length; g++){
          if(j == dancer_ranking[g]) tested = true;
        }
        if(fitness_ranking[j] < record_rank && tested == false){
          record_index = j;
          record_rank = fitness_ranking[j];
        }
      }
      dancer_ranking[i] = record_index;
    }

    
    best = dancer_ranking[0];
    worst = dancer_ranking[dancer_ranking.length-1];

    
    for(int i = 0; i < dancers.length; i++){
     println("Ranking of dancer " + i + " -----> rank: " + fitness_ranking[i]);
    }
    println();
    println();
    println("Fittest of Generation " + generation + ": dancer " + best);
    for(int i = (dancer_ranking.length-1); i > fertils-1; i--){
      println("Too weak in Generation " + generation + ": dancer " + dancer_ranking[i]);
    }
    println();
    println();
    ranking_time_counter = millis();
   // showRank();
  }
  
  void showRank(){
    if(!pure){
       for(int i = 0; i < dancers.length; i++){
         textSize((200/dancers.length));
         fill(255);
         textAlign(LEFT);
         //text(fitness_ranking[i], (i*(width/dancers.length)) + ((width/dancers.length)/2), height/2 - (width/dancers.length) -40 ); 
         textAlign(RIGHT);
         
         text(fitness_ranking[i], (i*(width/dancers.length)) + ((width/dancers.length)/2) - 20 , height/2 + (200/dancers.length) );
         
         if(i == 0){
           textAlign(CENTER);
           text("fittest", (dancer_ranking[i]*(width/dancers.length)) + ((width/dancers.length)/2), height/2 - ((width/dancers.length)/2) );
         }else if(i >= fertils){
           textAlign(CENTER);
           text("too weak", (dancer_ranking[i]*(width/dancers.length)) + ((width/dancers.length)/2), height/2 - ((width/dancers.length)/2) );
         } 
       }
    }
     rankingTime = false;
     
  }
 
  void sacrificeWeakest(){
    if(!pure){
        if((millis() - ranking_time_counter) > 2000){
          fill(0,220);
          for(int i = (dancer_ranking.length-1); i > fertils-1; i--){
            rect(dancer_ranking[i]*(width/dancers.length),40,(width/dancers.length), height);   
          }
        }
        if((millis() - ranking_time_counter) > 7000){
          reproductionTime = true;
        }
    }else{
      reproductionTime = true;
    }
  }
  
  float getMaxFitness() {
    float record = 0;
    for (int i = 0; i < dancers.length; i++) {
      if(dancers[i].getFitness() > record){
        record = dancers[i].getFitness();
      }  
    }
    return record;
  }
  
  
  //generate a mating pool
  void selection() {    
    //clear array
    matingPool.clear();
    
    //Calculate total fitness of whole population
    float maxFitness = getMaxFitness();
    // Calculate fitness for each member of the population (scaled to value between 0 and 1)
    // Based on fitness, each member will get added to the mating pool a certain number of times
    // A higher fitness = more entries to mating pool = more likely to be picked as a parent
    // A lower fitness = fewer entries to mating pool = less likely to be picked as a parent
    for (int i = 0; i < fertils; i++) {
      float fitnessNormal = map(dancers[dancer_ranking[i]].getFitness(),0,maxFitness,0,1);
      int n = (int) (fitnessNormal * 100);  // Arbitrary multiplier
      for (int j = 0; j < n; j++) {
        matingPool.add(dancers[dancer_ranking[i]]);
      }
    }
//    //print matingpool
//    for(int i = 0; i< matingPool.size(); i++){
//      println("spot " + i + " is " + " dancer " + matingPool.get(i).dancer_index_number);
//    }
  }
  
  void reproduction() {
    println("max overall is " + max_overall);
    

    if(auto_mutation == true){ 
        println("1");
        for(int i = 0; i < fertils; i++){ 
          fertils_correct_moves+= dancers[dancer_ranking[i]].correct_moves;
        }
        
        println("correct moves of fertils = " + fertils_correct_moves);
       
        mutationRate = 1;
        float relevant_moves = fertils*length_of_sequence;
        float temp1 = 1/relevant_moves;
        println("number of relvant moves are " + relevant_moves);
        println("temp1 =  " + temp1);
        
        mutationRate = temp1 * (relevant_moves - fertils_correct_moves);
        mutationRate*= 0.6;
    }
    
    
    
    // auto goal settings
    
    boolean goal_changed = false;
    generation_counter++;
    if(auto_goal == true && generation_counter > 15 && mutationRate != 0){
      mutationRate = 1;
//      target++;
//      if(target>7) target = 0;
//      goal_changed = true;   
       //restart
       all_dancers = new All_dancers(number_of_dancers);
       gen_at_change = all_dancers.generation;
       graph.reset(); 
    }else if(auto_goal == true && generation_counter >16 && mutationRate == 0){      
      mutationRate = 1;
      target++;     
      if(target>7) target = 0;
      goal_changed = true;  
     //restart
       all_dancers = new All_dancers(number_of_dancers);
       gen_at_change = all_dancers.generation;
       graph.reset();    
    }
    
    
    graph.update_mutRate(mutationRate);
    
    
    
    println();
    println();
    println("Mutation rate: " + mutationRate);
    println();
    println();
   
    // Refill the population with children from the mating pool
    for (int i = 0; i < number_of_dancers; i++) {
      // Sping the wheel of fortune to pick two parents
      int m = int(random(matingPool.size()));
      int d = int(random(matingPool.size()));
      // Pick two parents
      Dancer mom = matingPool.get(m);
      Dancer dad = matingPool.get(d);
      // Get their genes
      DNA momgenes = mom.getDNA();
      DNA dadgenes = dad.getDNA();
      // Mate their genes
      DNA child = momgenes.crossover(dadgenes);
      // Mutate their genes
      child.mutate(mutationRate);
      // Fill the new population with the new child
      PVector location_of_dancer = new PVector((i*(width/dancers.length)) + ((width/dancers.length)/2), height/2);
      float width_of_dancer = (width/dancers.length);
      dancers[i] = new Dancer(i, location_of_dancer, width_of_dancer, child);  
    }
    generation++; 
    
    if(goal_changed){
      gen_at_change = all_dancers.generation;
      //generation_counter = 0;
      //reset colours
      for(int i = 0; i < number_of_dancers; i++){
        color new_dna_c = color(random(0,255),random(0,255),random(0,255));
        for(int j = 0; j < length_of_sequence; j++){
          all_dancers.dancers[i].dna.dna_color[j] = new_dna_c;
        }
      }
    }
     
    
    
    time_left = length_of_sequence;
    performanceTime = true;
    rankingTime = false;
    reproductionTime = false;  
    overall = 0;
    fertils_correct_moves = 0;
    
    println();
    println();
    println("//////////////////////////////// Generation " + generation + " ////////////////////////////////");
    println();
    println();
    println("Goal: " + cat_titles[target]);
    println("Generations since goal was selected: " + ((all_dancers.generation - gen_at_change)));
    println();
    println();
    println("DNA of Generation " + generation + ":");
    for(int i = 0; i < dancers.length; i++){
      //printing each dancers initial DNA
      print("DNA of dancer " + (i) + " ---> ");
      for(int j = 0; j < dancers[i].dna.genes.length; j++){
        print(dancers[i].dna.genes[j] + ", ");
      }
      println();
    }
    println();
    println();
    
    for(int i = 0; i < dancers.length; i++){
       fitness_ranking[i] = 0;
       dancer_ranking[i] = -1;
    } 
    
  }

  
  
}

