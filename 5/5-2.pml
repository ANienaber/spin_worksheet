int x = 0;
int y = 0;
int z = 0;
int b = 0;

 proctype p1(){
	x = 1;
	z = 1;
	b = 1;
}

 proctype p2(){
	do 
	:: true -> {
		if 
		:: x==0 -> y = y+1
		:: else -> skip
		fi
		if 
		:: z==0 -> y = y+5
		:: else -> skip
		fi
		if 
		:: b==1 -> break
		:: else -> skip
		fi
	}
	od
}

init{
	run p1(); run p2();
}


