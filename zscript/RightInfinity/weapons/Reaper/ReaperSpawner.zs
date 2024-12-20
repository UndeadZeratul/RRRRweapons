class ReaperRandom:IdleDummy{
	states{
	spawn:
		TNT1 A 0 nodelay{
			let lll=random(0,6);
			if(lll<=3){
				spawn("RIreaper",pos,ALLOW_REPLACE);
				spawn("RIReapD20",pos+(7,0,0),ALLOW_REPLACE);
				spawn("RIReapD20",pos+(5,0,0),ALLOW_REPLACE);
			}else if(lll==6){
				spawn("RIreaperZM",pos,ALLOW_REPLACE);
				spawn("RIReapM8",pos+(10,0,0),ALLOW_REPLACE);
				spawn("RIReapM8",pos+(9,0,0),ALLOW_REPLACE);
				spawn("HD4mMag",pos+(8,0,0),ALLOW_REPLACE);
				spawn("HD4mMag",pos+(6,0,0),ALLOW_REPLACE);
			}else{
				spawn("RIreaperGL",pos,ALLOW_REPLACE);
				spawn("HDRocketAmmo",pos+(10,0,0),ALLOW_REPLACE);
				spawn("HDRocketAmmo",pos+(8,0,0),ALLOW_REPLACE);
				spawn("RIReapD20",pos+(5,0,0),ALLOW_REPLACE);
			}
		}stop;
	}
}
