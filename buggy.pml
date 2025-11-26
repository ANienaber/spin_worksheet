int x;
int y;
int z;
int crit;

active [2] proctype user(){
    int me = _pid +1;
L1: x = me;

    if 
    :: (y != 0 && y != me) -> goto L1;
    :: else
    fi

    z = me;

    if 
    :: (x!= me) -> goto L1;
    :: else
    fi

    y= me;
    
    if 
    :: z != me -> goto L1;
    :: else 
    fi

    crit++;
    assert(crit == 1)
    count--;
    goto L1;
}