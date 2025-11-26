ltl p1 {[]eating[0] -> }
bool chopsticks [5] = {true, true, true, true, true}; //true = available
bool eating [5] 

active [5] proctype philosopher() {
    int left_chopstick = _pid - 1;
    if 
    :: left_chopstick == -1 -> left_chopstick = 4;
    :: else -> skip;
    fi
    int right_chopstick = _pid;
    do 
    :: true -> {
        // thinking
        atomic{
            if 
            :: chopsticks[left_chopstick] && chopsticks[right_chopstick] -> {
                chopsticks[left_chopstick] = false;
                chopsticks[right_chopstick] = false;
            }
            fi
        }
        eating[pid] = true;
        eating[pid] = false;
        chopsticks[left_chopstick] = true;
        chopsticks[right_chopstick] = true;
    }
    od
}


