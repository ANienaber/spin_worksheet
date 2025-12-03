#define N 2
#define BUFFSIZE 5
mtype = {X, Y, LEVEL, TURN};

int x;
int y;
int r0;
int r1;
chan buffer[N] = [BUFFSIZE] of {mtype, int, int};
chan temp = [BUFFSIZE] of {mtype, int, int};
bool atEnd[N];

//dekker
ltl p1 {[] (wants_lock[0] -> <>!wants_lock[0]) && (wants_lock[1] -> <>!wants_lock[1])}
int level [N]; //automatically initialized with 0
int turn [N];
bool critical [N];
bool wants_lock [N];

inline write(variable, index, value, id) {
    buffer[id]!variable, index, value;
}

inline read(variable, index, value, id) {
    if
    :: buffer[id]??[eval(variable),eval(index), value] -> {
        mtype read_var;
        int read_index;
        int read_val;
        atomic {
            do 
            :: buffer[id]?[read_var, read_index, read_val] -> {
                buffer[id]?read_var, read_index, read_val;
                temp!read_var, read_index, read_val;
                if 
                :: read_var == variable && read_index == index -> value = read_val;
                :: else -> skip;
                fi
            }
            :: else -> break;
            od
            do 
            :: temp?[read_var, read_index, read_val] -> {
                temp?read_var, read_index, read_val;
                buffer[id]!read_var, read_index, read_val;
            }
            :: else -> break;
            od
        }
    }
    :: else -> {
        if 
        :: variable == X -> value = x;
        :: variable == Y -> value = y;
        :: variable == TURN -> value = turn[index];
        :: variable == LEVEL -> value = level[index];
        fi
    }
    fi
}

inline fence(id) {
    empty(buffer[id]);
}

proctype prop(int id) {
    int index;
    int value;
    do
    :: buffer[id]?X,0,x;
    :: buffer[id]?Y,0,y;
    :: buffer[id]?[TURN,index,value] -> {
        atomic {
            buffer[id]?TURN,index,value;
            turn[index] = value;
        }
    }
    :: buffer[id]?[LEVEL,index,value] -> {
        atomic {
            buffer[id]?LEVEL,index,value;
            level[index] = value;
        }
    }
    od
}

init {
    int count = 0;
    do 
    :: count < 2 -> {
        run dekker(count);
        run prop(count);
        count++;
    }
    :: else -> break;
    od
}

//dekker
proctype dekker(int id) {
    do 
    :: {
        //start lock
        int me = id;
        wants_lock[me] = true;
        int i = 1;
        do 
        :: i < N -> {
            write(LEVEL, me, i, me);
            write(TURN, i, me, me);
            fence(me);
            int k;
            bool no_k_found;
            do 
            :: no_k_found -> break;
            :: else -> {
                do
                :: k < N -> {
                    int levelk;
                    read(LEVEL, k, levelk, me);
                    int turni;
                    read(TURN, i, turni, me);
                    if 
                    :: k != me && levelk >= i && turni == me -> {
                        k = 0;
                        break;
                    }
                    :: else -> k++;
                    fi
                }
                :: else -> {
                    no_k_found = true;
                    break;
                }
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
        write(LEVEL, me, 0, me);
        //end unlock
    }
    od
}

//litmus test
proctype litmus(int id) {
    if 
    :: id == 0 -> {
        write(X, 0, 1, id);
        fence(id);
        read(Y, 0, r0, id);
    }
    :: id == 1 -> {
        write(Y, 0, 1, id);
        fence(id);
        read(X, 0, r1, id);
    }
    fi
    atEnd[id] = true;
}

/* active proctype monitor() {
    (atEnd[0] && atEnd[1]);
    assert(!(r0 == 0 && r1 == 0));
} */

//d) the assertion in line 78 is violated so the interesting
// outcome is indeed observable

// e) SPIN verifies with no assertions violated when inserting
// the fence operations in line 65 and 70
