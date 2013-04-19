  /* constants that control the sizes of various display elements */
final int PLAYERS_DISPLAYED = 30; // the max number of players on the screen at once
final int STRING_WIDTH = 50; // width on the screen available for player strings 
final float ROW_HEIGHT = 12;   // height on the screen for player rows
final int SPACING = 5;      // width on the screen bedtween player rows

final int WINDOW_WIDTH = 800;
final int WINDOW_HEIGHT = 600;

Parser parser;
int start_index;   // topmost player displayed
int end_index;     // bottommost player displayed
ArrayList tasks;   // one entry per task page
String players[];  // maps array indeces to player names
int selected_task; // which task is currently displayed
int selected_mission;
int num_players;

void setup(){
  size(WINDOW_WIDTH, WINDOW_HEIGHT);
  parser = new Parser("tasks.csv");
  tasks = parser.getTasks();
  players = parser.getPlayers();
  num_players = parser.getNumPlayers();
  start_index = 0;
  if(num_players < PLAYERS_DISPLAYED)
    end_index = num_players - 1;
  else
    end_index = start_index + PLAYERS_DISPLAYED;
  selected_task = 9;
  selected_mission = 1;
}

void draw(){
  Task t = (Task)tasks.get(selected_task);
  background(255);
  for(int i = start_index; i < end_index; i++) {
    drawPlayer(find_player_with_rank(t, selected_mission, i + 1));
  }
  println(' ');
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
  int player_pos = t.get_rank(player, selected_mission);
  float y_pos = (player_pos * ROW_HEIGHT) + (player_pos * SPACING);
  fill(0);
  textSize(ROW_HEIGHT * .7);
  text(players[player], x_pos, y_pos, STRING_WIDTH, ROW_HEIGHT);
  int num_missions = t.get_num_objectives();
  float box_width = (WINDOW_WIDTH - STRING_WIDTH - 5) / num_missions;
  x_pos += (STRING_WIDTH + 5);
  final int COLOR_DIFF = 230 / num_players;
  for(int i = 0; i < num_missions; i++) {
    bg = 255 - (25 + (t.get_rank(player, i) * COLOR_DIFF));
    fill(255, bg, bg);
    rect(x_pos + (i * box_width), y_pos, box_width, ROW_HEIGHT);
  }
}
