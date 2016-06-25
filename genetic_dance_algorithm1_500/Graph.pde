class Graph {
  FloatList fitnesses;
  FloatList mutRate;
  PVector loc;
  float hgt;
  float max_overall;
  int resolution = 20;
  //to align graph on the right enter width-300;
  //to align graph in the middle enter width/2;
  int graph_start = width-300;
  
  
  Rectangle res_down;
  Rectangle res_up;
  
  Graph(float yPos, float hei){
    loc = new PVector(graph_start, yPos);
    hgt = hei; 
    max_overall = 0;
    fitnesses = new FloatList();
    mutRate = new FloatList();
    
    res_down = new Rectangle((graph_start) + 190, int(loc.y+hgt + 36), 20, 12, "▼", -2);
    res_up = new Rectangle((graph_start) + 210, int(loc.y+hgt + 36), 20, 12, "▲", -2);
    
  } 
  
  void display(){
    stroke(255);
    loc.x = graph_start - fitnesses.size()*resolution;
    //line(loc.x,loc.y,loc.x,loc.y+hgt);
    line((graph_start) + 42,loc.y,(graph_start) + 42,loc.y+hgt);
    line((graph_start) + 39,loc.y,(graph_start) + 45,loc.y);
    line((graph_start) + 39,loc.y+hgt,(graph_start) + 45,loc.y+hgt);
    textSize(12);
    fill(255);
    textAlign(LEFT);
    text("max", (graph_start) + 60,loc.y+3); 
    text("min", (graph_start) + 60,loc.y+hgt+3);
    text("overall", (graph_start) + 120,loc.y+(hgt/2)-24); 
    text("fitness", (graph_start) + 120,loc.y+(hgt/2)-11); 
    text("resolution", (graph_start) + 120,loc.y+hgt + 36); 
    fill(130);
    text("mutation", (graph_start) + 120,loc.y+(hgt/2)+16); 
    text("rate", (graph_start) + 120,loc.y+(hgt/2)+29); 
    fill(255);
    PVector oldloc_fitness = new PVector(loc.x, loc.y+hgt);
    PVector oldloc_mutation = new PVector(loc.x, loc.y+hgt);
    
    for(int i = 0; i < fitnesses.size(); i++){
       strokeWeight(1);
      //show mutation rate
       
       if(i < mutRate.size()){
         stroke(130);
         point(loc.x + ((i+1)*resolution), map(mutRate.get(i), 0, 1, loc.y+hgt, loc.y));
         //ellipse(loc.x + ((i+1)*resolution), map(mutRate.get(i), 0, 1, loc.y+hgt, loc.y), 1,1); 
         if(i != 0) line(loc.x + ((i+1)*resolution),map(mutRate.get(i), 0, 1, loc.y+hgt, loc.y), oldloc_mutation.x, oldloc_mutation.y);
         oldloc_mutation.x = loc.x + ((i+1)*resolution);
         oldloc_mutation.y = map(mutRate.get(i), 0, 1, loc.y+hgt, loc.y);
       }
      
       
       stroke(255);
       strokeWeight(2);
       if(i != 0) line(loc.x + ((i+1)*resolution),map(fitnesses.get(i), 0, max_overall, loc.y+hgt, loc.y), oldloc_fitness.x, oldloc_fitness.y);
       if(map(fitnesses.get(i), 0, max_overall, loc.y+hgt, loc.y) == loc.y){
         stroke(255,0,0);
         strokeWeight(3);
       }
       ellipse(loc.x + ((i+1)*resolution), map(fitnesses.get(i), 0, max_overall, loc.y+hgt, loc.y), 1,1); 
   
       oldloc_fitness.x = loc.x + ((i+1)*resolution);
       oldloc_fitness.y = map(fitnesses.get(i), 0, max_overall, loc.y+hgt, loc.y);
       
       
       //show generation text
       if(resolution > 5){
         if(i == 0 || (i+1)%10 == 0){
           textAlign(CENTER);
           textSize(8);
           text("G" + (i+1), loc.x + ((i+1)*resolution),loc.y+hgt + 16); 
         }
       }
       
    }
    
    res_down.display();
    res_up.display();
    
    noStroke();
    
  }
  
  void update_fitness(float overall){
    fitnesses.append(overall);
  }
  
  void update_mutRate(float muR){
    mutRate.append(muR);
  }
  
  void reset(){
    fitnesses.clear();
    mutRate.clear();
  }
  
  
}
