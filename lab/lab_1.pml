#define N 2

//c)
ltl p1 {[] (wants_lock[0] -> <>!wants_lock[0]) && (wants_lock[1] -> <>!wants_lock[1])}

int level [N]; //automatically initialized with 0
int turn [N];
bool critical [N];
bool wants_lock[N];

active [N] proctype process() {
    do 
    :: {
        //start lock
        int me = _pid;
        wants_lock[me] = true;
        int i = 1;
        do 
        :: i < N -> {
            level[me] = i;
            turn[i] = me;
            int k;
            bool no_k_found;
            do 
            :: no_k_found -> break;
            :: else -> atomic {
                do
                :: k < N && k != me && level[k] >= i && turn[i] == me -> {k = 0; break;};
                :: k < N && !(k != me && level[k] >= i && turn[i] == me) -> k++;
                :: else -> {no_k_found = true; break;}
                od
            }
            od
            i++;
        }
        :: else -> break;
        od
        wants_lock[me] = false;
        //end lock
        //start critical
        critical[me] = true;
        i = 0;
        do
        :: i < N && i != me -> {assert(!critical[i]); i++}
        :: i < N && i == me -> i++;
        :: else break;
        od
        critical[me] = false;
        //end critical
        //start unlock
        level[me] = 0;
        //end unlock
    }
    od
}

// b) Spin verifies for 2, 3, 4 and 5 processes

// c) Doesn't verify