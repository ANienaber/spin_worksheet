bool flag[2] = {false, false};
int turn = 0;
bool crit[2] = {false, false};

active [2] proctype p(){
    int me = _pid;
    int other = 1 - me;
    do
    :: true -> {
        flag[me] = true;
        if 
        :: flag[other] == true ->{
            if 
                :: turn == other -> {
                    flag[me] = false;
                    do 
                    :: turn == other -> skip
                    :: else -> break
                    od
                    flag[me] = true;
                }
                ::else -> skip
            fi
            }
        :: else -> break
        fi
        crit[me] = true;
        //critical section
        crit[me] = false;
        turn = other;
        flag[me] = false;
        }
    :: else -> break
    od
}

active proctype Monitor(){
    atomic{(crit[0] && crit[1]) -> assert(!(crit[0] && crit[1]))}
}
