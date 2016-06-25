
class Move{
  boolean[] categories = new boolean[number_categories];
  Gif animation;
  boolean playonce = true;
  int number_of_frames;
  int currentframe;
  
  Move(Gif animation_, boolean[] cat){
    animation = animation_; 
    categories = cat;
    number_of_frames = animation.getPImages().length;
    
  }
 
  void play_gif(float locX, float locY, float size){
    //if(playonce){
      //animation.jump(0);
      animation.play();
      playonce = false;
    //}
    currentframe = animation.currentFrame();
    image(animation,locX,locY, size, size); 
    
  }
  
  void play_gif_frame(int fra, float locX, float locY, float size){
    
    animation.jump(fra);
    //animation.play();
    playonce = false;
   
    currentframe = animation.currentFrame();
    image(animation,locX,locY, size, size); 
    
  }
  
  boolean moving(){
    return animation.isPlaying();
  }
  
  void reset(){
    animation.jump(0);
    animation.stop();
  }
  
  boolean getCategory(int target_cat){
    return categories[target_cat];
  }
  
  
}
