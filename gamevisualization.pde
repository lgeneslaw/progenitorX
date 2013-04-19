  /* constants that control the sizes of various display elements */
int max_players_displayable; // the max number of players on the screen at once
float string_width; // width on the screen available for player strings 
float row_height;   // height on the screen for player rows
float spacing;      // width on the screen bedtween player rows
float title_height; // height at top of screen for Task title
float task_view_height; // height of the main task display
float mission_caption_height; // height of the mission numbers at the bottom of each column
float control_space_height;   // height of the control space at the bottom of the screen

Parser parser;
int start_index;   // topmost player displayed
int end_index;     // bottommost player displayed
ArrayList tasks;   // one entry per task page
String players[];  // maps array indeces to player names
int selected_task; // which task is currently displayed
int selected_mission;
int num_players;

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
  selected_task = 9;
  selected_mission = 1;
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
  setScreenDimensions();
  fill(0);
  stroke(0);
  line(0, title_height, width, title_height);
  line(0, title_height + task_view_height, width, title_height + task_view_height);
  line(0, title_height + task_view_height + mission_caption_height,
      width, title_height + task_view_height + mission_caption_height);
  Task t = (Task)tasks.get(selected_task);
  background(255);
  for(int i = start_index; i < end_index; i++) {
    drawPlayer(find_player_with_rank(t, selected_mission, i + 1));
  }
}

int find_player_with_rank(Task t, int mission, int rank) {
  for(int i = 0; i < num_players; i++) {
    if(t.get_rank(i, mission) == rank)
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
