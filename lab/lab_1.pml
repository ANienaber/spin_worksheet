#define N 2

int level [N]; //automatically initialized with 0
int turn [N];
bool critical [N];

active [N] proctype process() {
    lock();
    critical[_pid] = true;
    //critical
    critical[_pid] = false;
    unlock();
}

proctype lock() {
    int me = _pid;
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
}

proctype unlock() {
    level[_pid] = 0;
}

