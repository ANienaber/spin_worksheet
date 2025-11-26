int sum = 0;
 proctype p1(){
	int x = 8;
	sum = sum +8;
	if
	:: sum == 12 -> x = x + 1
	:: else -> skip
	fi
}

 proctype p2(){
	int y = 4;
	sum = sum +4;
	if 
	:: sum == 12 -> y = y + 1
	:: else -> skip
	fi
}
init{
	run p1(); run p2();
}
