class All_moves{
  Move[][] moves;
 
 
  All_moves(){
    
    moves = new Move[number_of_dancers][number_of_moves];
    
    for(int j = 0; j < number_of_dancers; j++){
      for(int i = 0; i < number_of_moves; i++){
        moves[j][i] = new Move(gif_array[j][i], categories[i]);
      }
    }

  }
  
  void play(int dancerindex, int index, float locX, float locY, float size){
      moves[dancerindex][index].play_gif(locX, locY, size);
  }
  
  void playFrame(int frame, int dancerindex, int index, float locX, float locY, float size){
      moves[dancerindex][index].play_gif_frame(frame,locX, locY, size);
  }
  
  
  boolean moving (int dancerindex, int index){
    if(!moves[dancerindex][index].moving()){
      moves[dancerindex][index].playonce = true;
      return false;
    }else{
      return true;
    }
  }
  
  int getFrames_of_move(int dancerindex, int index){
    return moves[dancerindex][index].number_of_frames;
  }
  
  int getCurrentFrame_of_move(int dancerindex, int index){
    return moves[dancerindex][index].currentframe;
  }
  
  boolean getCategory(int target_ca, int dancerindex, int index){
    return moves[dancerindex][index].getCategory(target_ca);
  }

   
  
  
}
