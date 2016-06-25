import gifAnimation.*;

int number_of_moves = 40;
int number_of_dancers = 4;
int number_categories = 8;
int length_of_sequence = 4;


int lifeCounter = 0;

int fertils = 3;
int crossover_mode = 1;
int target = 6;

All_moves all_moves;
All_dancers all_dancers;



Gif[][] gif_array = new Gif[number_of_dancers][number_of_moves];

Graph graph;



Rectangle[] buttons = new Rectangle[number_categories];
String[] cat_titles = {"Free", "Bound", "Indirect", "Direct", "Light", "Strong", "Sustained", "Quick"};
int gen_at_change = 1;
Rectangle options;
Rectangle fitness_graph;
Rectangle colour;
Rectangle refresh_col;
Rectangle reset;
Rectangle pure_dance;

boolean show_colour = true;
boolean show_options = true;
boolean auto_mutation = true;
boolean auto_goal = true;
boolean refresh_colours = true;
boolean show_graph = true;
boolean pure = false;

void setup(){
 size(displayWidth, displayHeight);
 background(0);
 frameRate(24);
 

 
 graph = new Graph((height/2) + 150, 100);
 
 for (int j = 0; j < number_of_dancers; j++){
   for(int i = 0; i < number_of_moves; i++){
        String name = "move" + i + "_500.gif";
        gif_array[j][i] = new Gif(this, name); // load animated GIF file from 
   }
 }
 for(int i = 0; i < number_categories; i++){
      buttons[i] = new Rectangle((width-660) + 80*i, 15, 80, 12, cat_titles[i], i);
 }
 options = new Rectangle(15, height-32, 80, 12, "options", -2);
 fitness_graph = new Rectangle(95, height-20, 150, 12, "show overall fitness", -2);
 colour = new Rectangle(245, height-20, 80, 12, "colours", -2);
 refresh_col = new Rectangle(325, height-20, 110, 12, "refresh colours", -2);
 reset = new Rectangle(width-100, height-20, 80, 12, "reset", -2);
 pure_dance = new Rectangle((width/2)-75, height-72, 150, 12, "pure dance performance", -2);
 

 all_moves = new All_moves();
 all_dancers = new All_dancers(number_of_dancers);
 
}




void draw(){
  background(0);
 
  all_dancers.display();
  
  
  if(all_dancers.performanceTime){
    all_dancers.checkPerformance();
  }
  
  if(!all_dancers.performanceTime){
   if(all_dancers.rankingTime){
     all_dancers.fitness();
     all_dancers.rank();
   }
   
   if(!all_dancers.rankingTime){
     all_dancers.sacrificeWeakest();
     
     if(all_dancers.reproductionTime){
       all_dancers.selection();
       all_dancers.reproduction();
     }
   }
   
   all_dancers.showRank();
 
  }
  
  if(show_graph == true && pure == false) graph.display();

  //buttons
  
  
  if(!pure) options.display();
  
  if(show_options){
    fill(255);
    stroke(255);
    strokeWeight(1);
    textSize(12);
    textAlign(LEFT);
    text("Mutation rate: ", 330,15); 
    if(auto_mutation){ 
      text("(auto is on*)", 330,30); 
      text("* regulates the mutation rate depending on the generation's overall amount of movements within the goal category", width-870,height-32);
    }else if(!auto_mutation) text("(auto is off)", 330,30); 
    text( String.format("%.2f", all_dancers.mutationRate), map(all_dancers.mutationRate, 0, 1, 420, 570),15);
    line(420, 23, 420, 27);
    line(570, 23, 570, 27);
    line(map(all_dancers.mutationRate, 0, 1, 420, 570), 20, map(all_dancers.mutationRate, 0, 1, 420, 570), 30);
    line(420, 24, 570, 25);
    text("Goal: ", (width-780),15);
    if(auto_goal){
      text("(auto is on**)", width-780,30);
      text("** changes the goal automatically every 20-25 generations", width-870,height-20);
    }else if(!auto_goal) text("(auto is off)", width-780,30);  
    for(int i = 0; i < number_categories; i++){
      buttons[i].display(); 
    }
    colour.display();
    fitness_graph.display();
    reset.display();
    
    if(show_colour == true) refresh_col.display();
    textAlign(CENTER);
    text("(" + ((all_dancers.generation - gen_at_change)+1) + ")" , buttons[target].x + (buttons[target].w/2) ,30); 
  }else{
    pure_dance.display();
  }
  
  noStroke();
  


}


void mouseClicked() {
 
  
  if(reset.contains(mouseX,mouseY) && show_options == true){ 
    all_dancers = new All_dancers(number_of_dancers);
    gen_at_change = all_dancers.generation;
    graph.reset(); 
  }
  
  if (mouseX >=420 && mouseX <=570 && mouseY < 32) {
    all_dancers.mutationRate = map(mouseX, 420, 570, 0, 1);
    auto_mutation = false;
  }else if (mouseX >=328 && mouseX <=380 && mouseY < 32 && mouseY > 15 && auto_mutation == false) {
    auto_mutation = true;
  }else if (mouseX >=328 && mouseX <=380 && mouseY < 32 && mouseY > 15 && auto_mutation == true) {
    auto_mutation = false;
  }  
  
  if (mouseX >=(width-782) && mouseX <=(width-730) && mouseY < 32 && mouseY > 15 && auto_goal==true) {
    auto_goal = false;
  }else if (mouseX >=(width-782) && mouseX <=(width-730) && mouseY < 32 && mouseY > 15 && auto_goal == false) {
    auto_goal = true;
  } 
  
  
  for(int i = 0; i < buttons.length; i++){
    if(buttons[i].contains(mouseX,mouseY) == true && target != i){
      target = i;
      gen_at_change = all_dancers.generation;
      auto_goal = false;
    }
  }
  
  if(pure_dance.contains(mouseX,mouseY) && pure == true){ 
    pure = false;
    pure_dance.text = "pure dance performance";
    pure_dance.w = 150;
  }else if(pure_dance.contains(mouseX,mouseY) && pure == false && show_options == false){
    pure = true;
    pure_dance.text = "genetic dance algorithm";
    pure_dance.w = 150;
  }
  
  if(options.contains(mouseX,mouseY) && show_options == true) show_options = false;
  else if(options.contains(mouseX,mouseY) && show_options == false && pure == false) show_options = true;
  
  if(colour.contains(mouseX,mouseY) && show_colour == true && show_options == true) show_colour = false;
  else if(colour.contains(mouseX,mouseY) && show_colour == false && show_options == true) show_colour = true; 
  
  if(fitness_graph.contains(mouseX,mouseY) && show_graph == true){
    show_graph = false; 
    fitness_graph.text = "show overall fitness";
  }else if(fitness_graph.contains(mouseX,mouseY) && show_graph == false && show_options == true){ 
    show_graph = true; 
    fitness_graph.text = "hide overall fitness";
  }
  
  if(graph.res_up.contains(mouseX,mouseY) && graph.resolution < 40) graph.resolution++;
  if(graph.res_down.contains(mouseX,mouseY) && graph.resolution > 1) graph.resolution--; 
  
  if(refresh_col.contains(mouseX,mouseY) && show_colour == true && show_options == true) {
    for(int i = 0; i < number_of_dancers; i++){
      color new_dna_c = color(random(0,255),random(0,255),random(0,255));
      for(int j = 0; j < length_of_sequence; j++){
        all_dancers.dancers[i].dna.dna_color[j] = new_dna_c;
      }
    }
    
  }
  
}
