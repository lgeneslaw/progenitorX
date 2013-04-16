class Task{
 int num_columns;
 int num_players;
 boolean on_task;
 int selected; //integer of selected mission 
 int scores[][];
 int ranks[][]; //First index corresponds to player
                //Second index corresponds to mission
 ArrayList columns;
 String name;               
 
 //this will need to be changed
 
 public Task(Column col, int _num_players){
   name = col.get_task_name();
   columns = new ArrayList();
   columns.add(col);
   num_columns = 1;
   num_players = _num_players;
 }
 
 /*public Task(String _name, int _num_missions, int _num_players){
   name = _name;
   on_task = determine_onoff();
   selected = 0; //Default to sorting by first mission.
   num_missions = _num_missions;
   num_players = _num_players;
   scores = new int[num_players][num_missions];
   ranks = new int[num_players][num_missions];
 }*/
 
 public boolean determine_onoff(){
   return name.substring(1,2) == "n";
 }
 
 public void set_score(int player, int mission, int score){
  scores[player][mission] = score; 
 }
 
 public int get_score(int player, int mission){
   return scores[player][mission];
 }
 
 public int get_num_objectives(){
   return num_columns;
 }
 
 public int get_num_players(){
   return num_players;
 }
 
 public String get_name(){
   return name; 
 }
 
 public void add_col(Column col){
   columns.add(col);
   num_columns++;
 }
 
 public void finish_initialization(){
   scores = new int[num_players][num_columns];
   ranks = new int[num_players][num_columns];
   //figure out what to do with ranks later
   for(int i = 0; i < num_players; i++){
     for(int j = 0; j < num_columns; j++){
       Column curr_col = (Column)columns.get(j);
       scores[i][j] = curr_col.get_action(i);
     }
   }    
 }
 
 public void print_scores(){
   println(name);
   for(int i = 0; i < num_players; i++){
     for(int j = 0; j < num_columns; j++){
       print(scores[i][j]);
       print(' ');
     }
     println(' ');
   }
 }
}
