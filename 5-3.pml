bool b1 = false;
bool b2 = false;
int x = 0;
bool crit1 = false;
bool crit2 = false;

 proctype p1(){
    do 
    :: true -> {
        b1 = true;
        x = 2;
        if 
        :: x == 1 || !b2 -> crit1 = true
        :: else -> skip
        fi  
        crit1 = false;
        b1 = false;
    }
    od
    }

    proctype p2(){
    do 
    :: true -> {
        b2 = true;
        x = 2;
        if 
        :: x == 2 || !b1 -> crit2 = true
        :: else -> skip
        fi  
        crit2 = false;
        b2 = false;
    }
    od
    }

proctype Monitor(){
    atomic{(crit1 && crit2) -> assert(!(crit1 && crit2))}
}

init{
    run p1(); run p2(); run Monitor();
}

