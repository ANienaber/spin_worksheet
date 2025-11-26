chan c = [0] of {bool, bool, bool}; //patty, bun, salad

bool pattyGuy;
bool bunGuy;
bool saladGuy;

ltl p1 {(always eventually pattyGuy) && (always eventually bunGuy) && (always eventually saladGuy)}

active proctype agent(){
    do
    :: {c!false,true,true;}//notify patty
    :: {c!true,false,true;}//notify bun
    :: {c!true,true,false;}//notify salad
    od
}

active [3] proctype burgerEater(){
    int me = _pid;

    do 
    :: (me == 0) -> {
        c?false,true,true;
        pattyGuy = true;
        //eat
        pattyGuy = false;
        skip;
    }
    :: (me == 1) -> {
        c?true,false,true;
        bunGuy = true;
        //eat
        bunGuy = false;
        skip;
    }
    :: (me == 2) -> {
        c?true,true,false;
        saladGuy = true;
        //eat
        saladGuy = false;
        skip;
    }
    od

}
