const ENC_TMPS_DRM_EMPTY=56; //thick boi
const ENC_TMPS_DRM=ENC_TMPS_DRM_EMPTY+ENC_9_LOADED*70;
const ENC_TMPS_DRM_LOADED=ENC_TMPS_DRM_EMPTY*0.8; 
const RILD_TMPDRM="TDM";
const ENC_TMPS_45ACPDRM=ENC_TMPS_DRM_EMPTY+ENC_45ACPLOADED*50;
const ENC_TMPS_45ACPDRM_LOADED=ENC_TMPS_DRM_EMPTY*0.8; 
const RILD_TMP45ACPDRM="T4D";
const ENC_TMPS_45ACPMAG=ENC_9MAG30_EMPTY+ENC_45ACPLOADED*20;
const ENC_TMPS_45ACPMAG_LOADED=ENC_9MAG30_EMPTY*0.8; 
const RILD_TMP45ACPMAG="T4M";
const ENC_AST_DRM_EMPTY=56; //thiccer boi
const ENC_AST_DRM=ENC_AST_DRM_EMPTY+0.6*20;
const ENC_AST_DRM_LOADED=ENC_AST_DRM_EMPTY*0.8; 
const RILD_ASTDRM="RDM";
const ENC_AST_STK_EMPTY=32; //Big, but plastic and hollow
const ENC_AST_STK=ENC_AST_STK_EMPTY+0.6*8;
const ENC_AST_STK_LOADED=ENC_TMPS_DRM_EMPTY*0.5; 
const RILD_ASTSTK="RSM";


// ------------------------------------------------------------
// 9mm Ammo
// ------------------------------------------------------------
class RITmpsD70:HD9mMag15{
	default{
		//$Category "Ammo/Hideous Destructor/"
		//$Title "Drum SMG Magazine"
		//$Sprite "TDRMA0"

		hdmagammo.maxperunit 70;
		hdmagammo.roundtype "HDPistolAmmo";
		hdmagammo.roundbulk ENC_9_LOADED;
		hdmagammo.magbulk ENC_TMPS_DRM_EMPTY;
		tag "$TAG_THOMPSON_DRUMMAG";
		inventory.pickupmessage "$PICKUP_THOMPSON_DRUMMAG";
		hdpickup.refid RILD_TMPDRM;
	}
	override bool Extract(){
		SyncAmount();
		int mindex=mags.size()-1;
		if(
			mags.size()<1
			||mags[mags.size()-1]<1
			||owner.A_JumpIfInventory(roundtype,0,"null")
		)return false;
		HDF.Give(owner,roundtype,1);
		owner.A_StartSound("weapons/rifleclick2",CHAN_WEAPON);
		mags[mags.size()-1]--;
		// extracttime=6+(mags[mindex]*0.08); //0.058 orig calc, felt bad
		if(mags[mindex]>=60){
			extracttime=10;
		}else if(mags[mindex]>=50){
			extracttime=7;
		}else if(mags[mindex]>=40){
			extracttime=6;
		}else if(mags[mindex]>=30){
			extracttime=5;
		}else if(mags[mindex]>=20){
			extracttime=4;
		}else if(mags[mindex]>=10){
			extracttime=3;
		}else{
			extracttime=2;
		}
		if(mags[mindex]==0){
		owner.A_StartSound("weapons/tmpdrumfin",CHAN_WEAPON);
		}
		return true;
	}
	override bool Insert(){
		SyncAmount();
		int mindex=mags.size()-1;
		if(
			mags.size()<1
			||mags[mags.size()-1]>=maxperunit
			||!owner.countinv(roundtype)
		)return false;
		owner.A_TakeInventory(roundtype,1,TIF_NOTAKEINFINITE);
		owner.A_StartSound("weapons/rifleclick2",CHAN_WEAPON);
		mags[mags.size()-1]++;
		// inserttime=6+(mags[mindex]*0.1);
		if(mags[mindex]>=60){
			inserttime=10;
		}else if(mags[mindex]>=50){
			inserttime=9;
		}else if(mags[mindex]>=40){
			inserttime=8;
		}else if(mags[mindex]>=30){
			inserttime=7;
		}else if(mags[mindex]>=20){
			inserttime=6;
		}else if(mags[mindex]>=10){
			inserttime=5;
		}else{
			inserttime=5;
		}
		return true;
	}
	
	override void GetItemsThatUseThis(){
		itemsthatusethis.push("RIThompson");
	}
	override string,string,name,double getmagsprite(int thismagamt){
		string magsprite;
		double fmag=10;
		for(int i=thismagamt;i>0;i--){
			fmag++;
			if(fmag>4)fmag=0;
		}
		if(thismagamt==0)magsprite="TDRMU0";
		else if(fmag==0)magsprite="TDRMZ0";
		else if(fmag==1)magsprite="TDRMY0";
		else if(fmag==2)magsprite="TDRMX0";
		else if(fmag==3)magsprite="TDRMW0";
		else if(fmag==4)magsprite="TDRMV0";
		else magsprite="TDRMV0";
		return magsprite,"PRNDA0","HDPistolAmmo",1.5;
	}
	states{
	spawn:
		TDRM D -1;
		stop;
	spawnempty:
		TDRM C -1{
			brollsprite=true;brollcenter=true;
			roll=randompick(2,2,2,3,3)*90;
		}stop;
	}
}

class RIThompsonEmptyMag:IdleDummy{
	override void postbeginplay(){
		super.postbeginplay();
		HDMagAmmo.SpawnMag(self,"RITmpsD70",0);
		destroy();
	}
}

// ------------------------------------------------------------
// .45 ACP Ammo
// ------------------------------------------------------------


class RITmpsD50:HD9mMag15{
	default{
		//$Category "Ammo/Hideous Destructor/"
		//$Title "Drum SMG Magazine"
		//$Sprite "TDRMA0"

		hdmagammo.maxperunit 50;
		hdmagammo.roundtype "HD45ACPAmmo";
		hdmagammo.roundbulk ENC_45ACPLOADED;
		hdmagammo.magbulk ENC_TMPS_DRM_EMPTY;
		tag "$TAG_THOMPSON_45ACPDRUMMAG";
		inventory.pickupmessage "$PICKUP_THOMPSON_45ACPDRUMMAG";
		hdpickup.refid RILD_TMP45ACPDRM;
	}
	override bool Extract(){
		SyncAmount();
		int mindex=mags.size()-1;
		if(
			mags.size()<1
			||mags[mags.size()-1]<1
			||owner.A_JumpIfInventory(roundtype,0,"null")
		)return false;
		HDF.Give(owner,roundtype,1);
		owner.A_StartSound("weapons/rifleclick2",CHAN_WEAPON);
		mags[mags.size()-1]--;
		// extracttime=6+(mags[mindex]*0.08); //0.058 orig calc, felt bad
		if(mags[mindex]>=60){
			extracttime=10;
		}else if(mags[mindex]>=50){
			extracttime=7;
		}else if(mags[mindex]>=40){
			extracttime=6;
		}else if(mags[mindex]>=30){
			extracttime=5;
		}else if(mags[mindex]>=20){
			extracttime=4;
		}else if(mags[mindex]>=10){
			extracttime=3;
		}else{
			extracttime=2;
		}
		if(mags[mindex]==0){
			owner.A_StartSound("weapons/tmpdrumfin",CHAN_WEAPON);
		}
		return true;
	}
	override bool Insert(){
		SyncAmount();
		int mindex=mags.size()-1;
		if(
			mags.size()<1
			||mags[mags.size()-1]>=maxperunit
			||!owner.countinv(roundtype)
		)return false;
		owner.A_TakeInventory(roundtype,1,TIF_NOTAKEINFINITE);
		owner.A_StartSound("weapons/rifleclick2",CHAN_WEAPON);
		mags[mags.size()-1]++;
		// inserttime=6+(mags[mindex]*0.1);
		if(mags[mindex]>=60){
			inserttime=10;
		}else if(mags[mindex]>=50){
			inserttime=9;
		}else if(mags[mindex]>=40){
			inserttime=8;
		}else if(mags[mindex]>=30){
			inserttime=7;
		}else if(mags[mindex]>=20){
			inserttime=6;
		}else if(mags[mindex]>=10){
			inserttime=5;
		}else{
			inserttime=5;
		}
		return true;
	}
	
	override void GetItemsThatUseThis(){
		itemsthatusethis.push("RIThompson");
	}
	override string,string,name,double getmagsprite(int thismagamt){
		string magsprite;
		double fmag=10;
		for(int i=thismagamt;i>0;i--){
			fmag++;
			if(fmag>4)fmag=0;
		}
		if(thismagamt==0)magsprite="TDRMU0";
		else if(fmag==0)magsprite="TDRMZ0";
		else if(fmag==1)magsprite="TDRMY0";
		else if(fmag==2)magsprite="TDRMX0";
		else if(fmag==3)magsprite="TDRMW0";
		else if(fmag==4)magsprite="TDRMV0";
		else magsprite="TDRMV0";
		return magsprite,"45RNA0","HD45ACPAmmo",1.5;
	}
	states{
	spawn:
		TDRM D -1;
		stop;
	spawnempty:
		TDRM C -1{
			brollsprite=true;brollcenter=true;
			roll=randompick(2,2,2,3,3)*90;
		}stop;
	}
}

class RIThompsonEmptyDrumMag:IdleDummy{
	override void postbeginplay(){
		super.postbeginplay();
		HDMagAmmo.SpawnMag(self,"RITmpsD50",0);
		destroy();
	}
}


class RITmpsM20:HD9mMag15{
	default{
		//$Category "Ammo/Hideous Destructor/"
		//$Title "SMG Magazine"
		//$Sprite "CLP3A0"

		hdmagammo.maxperunit 20;
		hdmagammo.magbulk ENC_9MAG30_EMPTY;
		tag "$TAG_THOMPSON_45ACPBOXMAG";
		inventory.pickupmessage "$PICKUP_THOMPSON_45ACPBOXMAG";
		hdpickup.refid RILD_TMP45ACPMAG;
	}
	override void GetItemsThatUseThis(){
		itemsthatusethis.push("RIThompson");
	}
	override string,string,name,double getmagsprite(int thismagamt){
		string magsprite=(thismagamt>0)?"CLP3A0":"CLP3B0";
		return magsprite,"45RNA0","HD45ACPAmmo",2.;
	}
	states{
	spawn:
		CLP3 A -1;
		stop;
	spawnempty:
		CLP3 B -1 A_SpawnEmpty();
		stop;
	}
}

class RIThompsonEmptyBoxMag:IdleDummy{
	override void postbeginplay(){
		super.postbeginplay();
		HDMagAmmo.SpawnMag(self,"RITmpsM20",0);
		destroy();
	}
}

// ------------------------------------------------------------
// SHOT Ammo
// ------------------------------------------------------------

// class RIReapD20:RITmpsD70{
class RIReapD20:HD9mMag15{
	default{
		//$Category "Ammo/Hideous Destructor/"
		//$Title "Drum Shotty Magazine"
		//$Sprite "ASDMA0"
		scale 0.50;
		hdmagammo.maxperunit 20;
		hdmagammo.roundtype "HDShellAmmo";
		hdmagammo.roundbulk ENC_SHELLLOADED;
		hdmagammo.magbulk ENC_AST_DRM_EMPTY;
		tag "$TAG_REAPER_DRUMMAG";
		inventory.pickupmessage "$PICKUP_REAPER_DRUMMAG";
		hdpickup.refid RILD_ASTDRM;
	}

	override void GetItemsThatUseThis(){
		itemsthatusethis.push("RIReaper");
		itemsthatusethis.push("RIReaperGL");
		itemsthatusethis.push("RIReaperZM");
	}

	override bool Extract(){
		SyncAmount();
		int mindex=mags.size()-1;
		if(
			mags.size()<1
			||mags[mags.size()-1]<1
			||owner.A_JumpIfInventory(roundtype,0,"null")
		)return false;
		HDF.Give(owner,roundtype,1);
		owner.A_StartSound("weapons/rifleclick2",CHAN_WEAPON);
		mags[mags.size()-1]--;
		// extracttime=6+(mags[mindex]*0.08); //0.058 orig calc, felt bad
		if(mags[mindex]>=17){
			extracttime=10;
		}else if(mags[mindex]>=13){
			extracttime=7;
		}else if(mags[mindex]>=10){
			extracttime=6;
		}else if(mags[mindex]>=7){
			extracttime=5;
		}else{
			extracttime=4;
		}
		if(mags[mindex]==0){
		owner.A_StartSound("weapons/tmpdrumfin",CHAN_WEAPON);
		}
		return true;
	}

	override bool Insert(){
		SyncAmount();
		int mindex=mags.size()-1;
		if(
			mags.size()<1
			||mags[mags.size()-1]>=maxperunit
			||!owner.countinv(roundtype)
		)return false;
		owner.A_TakeInventory(roundtype,1,TIF_NOTAKEINFINITE);
		owner.A_StartSound("weapons/rifleclick2",CHAN_WEAPON);
		mags[mags.size()-1]++;
		// inserttime=6+(mags[mindex]*0.1);
		if(mags[mindex]>=17){
			inserttime=10;
		}else if(mags[mindex]>=13){
			inserttime=9;
		}else if(mags[mindex]>=10){
			inserttime=8;
		}else if(mags[mindex]>=7){
			inserttime=7;
		}else if(mags[mindex]>=4){
			inserttime=6;
		}else{
			inserttime=5;
		}
		return true;
	}

	override string,string,name,double getmagsprite(int thismagamt){
		string magsprite;
		if(thismagamt==0)magsprite="RPRDA0";
		else if(thismagamt==1)magsprite="RPRDB0";
		else if(thismagamt==2)magsprite="RPRDC0";
		else if(thismagamt==3)magsprite="RPRDD0";
		else if(thismagamt==4)magsprite="RPRDE0";
		else if(thismagamt==5)magsprite="RPRDF0";
		else if(thismagamt==6)magsprite="RPRDG0";
		else if(thismagamt==7)magsprite="RPRDH0";
		else if(thismagamt==8)magsprite="RPRDI0";
		else if(thismagamt==9)magsprite="RPRDJ0";
		else if(thismagamt==10)magsprite="RPRDK0";
		else if(thismagamt==11)magsprite="RPRDL0";
		else if(thismagamt==12)magsprite="RPRDN0";
		else if(thismagamt==13)magsprite="RPRDM0";
		else if(thismagamt==14)magsprite="RPRDO0";
		else if(thismagamt==15)magsprite="RPRDP0";
		else if(thismagamt==16)magsprite="RPRDQ0";
		else if(thismagamt==17)magsprite="RPRDR0";
		else if(thismagamt==18)magsprite="RPRDS0";
		else if(thismagamt==19)magsprite="RPRDT0";
		else if(thismagamt==20)magsprite="RPRDU0";
		else magsprite="RPRDA0";
		return magsprite,"SHL1A0","HDShellAmmo",.60;
	}

	states{
	cacheSprites:
		RPRD A 0;
	spawn:
		ASDM B -1;
		stop;
	spawnempty:
		ASDM A -1{
			brollsprite=true;brollcenter=true;
			roll=randompick(2,2,2,3,3)*90;
		}stop;
	}
}

class RIReapD20EmptyMag:IdleDummy{
	override void postbeginplay(){
		super.postbeginplay();
		HDMagAmmo.SpawnMag(self,"RIReapD20",0);
		destroy();
	}
}

// ================================================================================

class RIReapM8:HD9mMag15{
	default{
		//$Category "Ammo/Hideous Destructor/"
		//$Title "Shotty Magazine"
		//$Sprite "ASSMA0"
		scale 0.50;
		hdmagammo.maxperunit 8;
		hdmagammo.roundtype "HDShellAmmo";
		hdmagammo.roundbulk ENC_SHELLLOADED;
		hdmagammo.magbulk ENC_AST_STK_EMPTY;
		tag "$TAG_REAPER_MAG";
		inventory.pickupmessage "$PICKUP_REAPER_MAG";
		hdpickup.refid RILD_ASTSTK;
	}
	override void GetItemsThatUseThis(){
		itemsthatusethis.push("RIReaper");
		itemsthatusethis.push("RIReaperGL");
		itemsthatusethis.push("RIReaperZM");
	}

	override bool Extract(){
		SyncAmount();
		int mindex=mags.size()-1;
		if(
			mags.size()<1
			||mags[mags.size()-1]<1
			||owner.A_JumpIfInventory(roundtype,0,"null")
		)return false;
		HDF.Give(owner,roundtype,1);
		owner.A_StartSound("weapons/rifleclick2",CHAN_WEAPON);
		mags[mags.size()-1]--;
		if(mags[mindex]>=7){
			extracttime=9;
		}else if(mags[mindex]>=5){
			extracttime=8;
		}else if(mags[mindex]>=3){
			extracttime=7;
		}else{
			extracttime=6;
		}
		if(mags[mindex]==0){
		owner.A_StartSound("weapons/tmpdrumfin",CHAN_WEAPON);
		}
		return true;
	}

	override bool Insert(){
		SyncAmount();
		int mindex=mags.size()-1;
		if(
			mags.size()<1
			||mags[mags.size()-1]>=maxperunit
			||!owner.countinv(roundtype)
		)return false;
		owner.A_TakeInventory(roundtype,1,TIF_NOTAKEINFINITE);
		owner.A_StartSound("weapons/rifleclick2",CHAN_WEAPON);
		mags[mags.size()-1]++;
		if(mags[mindex]>=7){
			inserttime=9;
		}else if(mags[mindex]>=5){
			inserttime=8;
		}else if(mags[mindex]>=3){
			inserttime=7;
		}else{
			inserttime=6;
		}
		return true;
	}

	override string,string,name,double getmagsprite(int thismagamt){
		string magsprite;
		if(thismagamt==0)magsprite="ASSMA0";
		else magsprite="ASSMB0";
		return magsprite,"SHL1A0","HDShellAmmo",.60;
	}

	states{
	spawn:
		ASSM B -1;
		stop;
	spawnempty:
		ASSM A -1{
			brollsprite=true;brollcenter=true;
			roll=randompick(2,2,2,3,3)*90;
		}stop;
	}
}

class RIReapM8EmptyMag:IdleDummy{
	override void postbeginplay(){
		super.postbeginplay();
		HDMagAmmo.SpawnMag(self,"RIReapM8",0);
		destroy();
	}
}
