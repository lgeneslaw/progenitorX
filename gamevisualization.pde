  /* constants that control the sizes of various display elements */
int max_players_displayable; // the max number of players on the screen at once
float string_width; // width on the screen available for player strings 
float row_height;   // height on the screen for player rows
float spacing;      // width on the screen between player rows
float title_height; // height at top of screen for Task title
float task_view_height; // height of the main task display
float mission_caption_height; // height of the mission numbers at the bottom of each column
float control_space_height;   // height of the control space at the bottom of the screen

int num_tasks_displayed;
int first_task_displayed;

Parser parser;
int start_index;   // topmost player displayed
int end_index;     // bottommost player displayed
ArrayList tasks;   // one entry per task page
String players[];  // maps array indeces to player names
int selected_task; // which task is currently displayed
int selected_mission;
int num_players;
Button task_buttons[];
Button task_prev;
Button task_next;

void setup(){
  size(800, 600);
  frame.setResizable(true);
  setScreenDimensions();
  parser = new Parser("tasks.csv");
  tasks = parser.getTasks();
  players = parser.getPlayers();
  num_players = parser.getNumPlayers();
  start_index = 0;
  if(num_players < max_players_displayable)
    end_index = num_players - 1;
  else
    end_index = start_index + max_players_displayable;
  selected_task = 0;
  selected_mission = 0;
  task_buttons = new Button[tasks.size()];
  for(int i = 0; i < task_buttons.length; i++){
    task_buttons[i] = new Button(((Task)tasks.get(i)).get_name());
  }
  
  num_tasks_displayed = 4; //temporary. displaying four task buttons at bottom
  first_task_displayed = selected_task;
  task_prev = new Button("<");
  task_next = new Button(">");
  
  println(max_players_displayable);
}

void setScreenDimensions() {
  title_height = .05 * height;
  control_space_height = .1 * height;
  mission_caption_height = title_height;
  task_view_height = height - title_height - mission_caption_height - control_space_height;
  string_width = .1 * width;
  row_height = .03 * task_view_height;
  spacing = .25 * row_height;
  max_players_displayable = (int)(task_view_height / (row_height + spacing));

}

void draw(){
  background(255);
  setScreenDimensions();
  Task t = (Task)tasks.get(selected_task);
  textAlign(CENTER, CENTER);
  textSize(.8 * title_height);
  fill(0);
  text(t.get_name(), 0, 0, width, title_height);
  line(0, title_height, width, title_height);
  line(0, title_height + task_view_height, width, title_height + task_view_height);
  line(0, title_height + task_view_height + mission_caption_height,
      width, title_height + task_view_height + mission_caption_height);
  draw_mission_buttons();     
  for(int i = start_index; i < end_index; i++) {
    drawPlayer(find_player_with_rank(t, i + 1));
    
  //Testing out the drawing of one button;
  draw_task_buttons();
  }
}

void draw_mission_buttons(){
  //Needs to be filled in
}

void draw_buttons(){
  float y = height - (control_space_height * .75);
  float b_width = (width / 2 / num_tasks_displayed) * .75;
  float button_spacing = (b_width / .75) * .125;
  float x = button_spacing;
  float b_height = control_space_height / 2;
  
  float ib_width = b_width * .25;
  
  task_prev.update_button(x, y, ib_width, b_height);
  if(first_task_displayed != 0)
    task_prev.draw_button();
  else{
    fill(230);
    stroke(200);
    rect(x, y, ib_width, b_height);
    textSize((ib_width + b_height) * .4);
    fill(150);
    text("<", x, y, ib_width, b_height);   
  }
  stroke(0);
  x = x + button_spacing + ib_width;
  
  for(int i = first_task_displayed; i < (first_task_displayed + num_tasks_displayed); i++){
    if(i < first_task_displayed || i > (first_task_displayed + num_tasks_displayed)){
      task_buttons[i].update_button(0, 0, 0, 0);
    }
    else{
      task_buttons[i].update_button(x, y, b_width, b_height);
      task_buttons[i].draw_button();
      x = x + button_spacing + b_width;
    }
  }
  
  task_next.update_button(x, y, ib_width, b_height);
  if(first_task_displayed + num_tasks_displayed != tasks.size())
    task_next.draw_button();
  else{
    fill(230);
    stroke(200);
    rect(x, y, ib_width, b_height);
    textSize((ib_width + b_height) * .4);
    fill(150);
    text(">", x, y, ib_width, b_height);   
  }  
  stroke(0);
}

int find_player_with_rank(Task t, int rank) {
  for(int i = 0; i < num_players; i++) {
    if(t.get_rank(i, selected_mission) == rank)
      return i;
  }
  return -1;
}
  

void drawPlayer(int player) {
  Task t = (Task)tasks.get(selected_task);
  int bg;
  float x_pos = 0;
  int player_pos = t.get_rank(player, selected_mission) - 1;
  float y_pos = title_height + (player_pos * row_height) + (player_pos * spacing);
  fill(0);
  textSize(row_height * .7);
  text(players[player], x_pos, y_pos, string_width, row_height);
  int num_missions = t.get_num_objectives();
  float box_width = (width - string_width - 5) / num_missions;
  x_pos += (string_width + 5);
  final int COLOR_DIFF = 230 / num_players;
  for(int i = 0; i < num_missions; i++) {
    bg = 255 - (25 + (t.get_rank(player, i) * COLOR_DIFF));
    fill(255, bg, bg);
    rect(x_pos + (i * box_width), y_pos, box_width, row_height);
  }
}

void mouseMoved(){
  for(int i = 0; i < task_buttons.length; i++){
    task_buttons[i].check_intersection();
  }
  task_prev.check_intersection();
  task_next.check_intersection();
}

void mouseClicked(){
  for(int i = 0; i < task_buttons.length; i++){
    if(task_buttons[i].clicked_on()){
      selected_task = i;
      selected_mission = 0;
    }
  }
  if(task_prev.check_intersection()){
    if(first_task_displayed != 0){
      first_task_displayed--;
    }
  }
  if(task_next.check_intersection()){
    if(first_task_displayed + num_tasks_displayed != tasks.size()){
      first_task_displayed++;
    }
  }
}
