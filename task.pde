class Task{
 int num_missions;
 int num_players;
 boolean on_task;
 int selected; //integer of selected mission 
 int scores[][];
 int ranks[][]; //First index corresponds to player
                //Second index corresponds to mission
 String name;               
 
 public Task(String _name, int _num_missions, int _num_players){
   name = _name;
   on_task = determine_onoff();
   selected = 0; //Default to sorting by first mission.
   num_missions = _num_missions;
   num_players = _num_players;
   scores = new int[num_players][num_missions];
   ranks = new int[num_players][num_missions];
 }
 
 public boolean determine_onoff(){
  return name[1] == 'n'; 
 }
 
 public void set_score(int player, int mission, int score){
  scores[player][mission] = score; 
 }
 
 public int get_score(int player, int mission){
   return scores[player][mission];
 }
 
 public int get_num_missions(){
   return num_missions;
 }
 
 public int get_num_players(){
   return num_players;
 }
}
