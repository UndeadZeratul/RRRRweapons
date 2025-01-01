// ------------------------------------------------------------
// Bronto buddy
// ------------------------------------------------------------
const RILD_BB="BRR";


class RIBrontoBuddy : Brontornis {

	default {
		weapon.selectionorder 61;
		inventory.pickupmessage "$PICKUP_BRONTOBUDDY";
		hdweapon.barrelsize 24,1,3;
		tag "$TAG_BRONTOBUDDY";
		hdweapon.refid RILD_BB;
	}

	action void A_UnloadSideSaddle(int slot){
		int uamt=clamp(invoker.weaponstatus[slot],0,1);
		if(!uamt)return;
		invoker.weaponstatus[slot]-=uamt;
		int maxpocket=min(uamt,HDPickup.MaxGive(self,"BrontornisRound",ENC_BRONTOSHELL));
		if(maxpocket>0&&pressingunload()){
			A_SetTics(16);
			uamt-=maxpocket;
			A_GiveInventory("BrontornisRound",maxpocket);
		}
		A_StartSound("weapons/pocket");
		EmptyHand(uamt);
	}

	action void A_CannibalizeOtherShotgun(){
		let zzz=hdweapon(findinventory("RIBrontoBuddy"));
		if(zzz){
			int totake=min(
				zzz.weaponstatus[BRONS_SIDESADDLE],
				HDPickup.MaxGive(self,"BrontornisRound",ENC_BRONTOSHELL),
				4
			);
			if(totake>0){
				zzz.weaponstatus[BRONS_SIDESADDLE]-=totake;
				A_GiveInventory("BrontornisRound",totake);
			}
		}
	}

	override double gunmass(){
		return super.gunmass() + (weaponstatus[BRONS_SIDESADDLE] * 0.12);
	}

	override double weaponbulk(){
		return super.weaponbulk() + 2 + (weaponstatus[BRONS_SIDESADDLE] * ENC_BRONTOSHELL);
	}

	override string,double getpickupsprite(){
		int ssh=weaponstatus[BRONS_SIDESADDLE];
		if(ssh==0)return "BLBRA0",1.;
		if(ssh==1)return "BLBRB0",1.;
		if(ssh==2)return "BLBRC0",1.;
		if(ssh==3)return "BLBRD0",1.;
		return "BLBRD0",1.;	
	}

	// TODO: Extend super.DrawHUDStuff() instead?
	override void DrawHUDStuff(HDStatusBar sb,HDWeapon hdw,HDPlayerPawn hpl){
		if(sb.hudlevel==1){
			sb.drawimage("BROCA0",(-48,-10),sb.DI_SCREEN_CENTER_BOTTOM,scale:(0.7,0.7));
			sb.drawnum(hpl.countinv("BrontornisRound"),-45,-8,sb.DI_SCREEN_CENTER_BOTTOM,font.CR_BLACK); // Only part that changes is font color
		}
		if(hdw.weaponstatus[BRONS_CHAMBER]>1)sb.drawrect(-21,-13,5,3);
		sb.drawwepnum(
			hpl.countinv("BrontornisRound"),
			(HDCONST_MAXPOCKETSPACE/ENC_BRONTOSHELL)
		);

		// only new logic
		for(int i=hdw.weaponstatus[BRONS_SIDESADDLE];i>0;i--){
			sb.drawwepdot(-8-i*8,-2,(6,3));
			sb.drawwepdot(-9-i*8,-3,(6,1));
		}
	}

	override string gethelptext(){
		LocalizeHelp();
		return
		LWPHELP_FIRESHOOT
		// ..LWPHELP_ALTFIRE.." or "..LWPHELP_FIREMODE.."  Toggle zoom\n"
		..LWPHELP_RELOAD.."  Reload From Rack First\n"
		..LWPHELP_ALTRELOAD.."  Reload From Pockets\n"
		..LWPHELP_UNLOADUNLOAD
		;
	}

	override void failedpickupunload(){
		int sss=weaponstatus[BRONS_SIDESADDLE];
		if(sss<1)return;
		A_StartSound("weapons/pocket",5);
		int dropamt=min(sss,1);
		A_DropItem("BrontornisRound",dropamt);
		weaponstatus[BRONS_SIDESADDLE]-=dropamt;
		setstatelabel("spawn");
	}

	override void ForceBasicAmmo(){
		owner.A_SetInventory("BrontornisRound",1);
	}

	states {
		ready:
			BLSG A 0 A_JumpIf(pressingunload()&&(pressinguse()||pressingzoom()),"cannibalize");
			BLSG A 1 A_WeaponReady(WRF_ALL);
			goto readyend;
		altfire:
		firemode:
			BLSG A 1 offset(0,34);
			BLSG A 1 offset(0,36);
			// BLSG A 2 offset(2,37){invoker.weaponstatus[0]^=BRONF_ZOOM;}
			BLSG A 1 offset(1,36);
			BLSG A 1 offset(0,34);
			goto nope;

		altreload:
		reloadfrompockets:
			BLSG A 0{
				int ppp=countinv("BrontornisRound");
				if(ppp<1)setweaponstate("nope");
					else if(ppp<1)
						invoker.weaponstatus[0]|=BRONF_FROMPOCKETS;
					else invoker.weaponstatus[0]&=~BRONF_FROMPOCKETS;
			}goto startreload;
		reload:
		reloadfromsidesaddles:
			BLSG A 0{
				int sss=invoker.weaponstatus[BRONS_SIDESADDLE];
				int ppp=countinv("BrontornisRound");
				if(ppp<1&&sss<1)setweaponstate("nope");
					else if(sss<1)
						invoker.weaponstatus[0]&=~BRONF_FROMPOCKETS;
					else invoker.weaponstatus[0]|=BRONF_FROMPOCKETS;
			}goto startreload;
		startreload:
			BLSG A 0{
				invoker.weaponstatus[0]&=~BRONF_JUSTUNLOAD;
				if(
					invoker.weaponstatus[BRONS_CHAMBER]>1
					){
					if(
						invoker.weaponstatus[BRONS_SIDESADDLE]<3
						&&countinv("BrontornisRound")
					)setweaponstate("reloadSS");
					else setweaponstate("nope");
				}
			}goto unloadstart;
		reloadSS:
			BLSG A 1 offset(1,34);
			BLSG A 2 offset(2,34);
			BLSG A 3 offset(3,36);
		reloadSSrestart:
			BLSG A 6 offset(3,35);
			BLSG A 9 offset(4,34);
			BLSG A 4 offset(3,34){
				int hnd=1;
				if(invoker.weaponstatus[BRONS_SIDESADDLE]>2)setweaponstate("reloadSSend");
				else{
					A_TakeInventory("BrontornisRound",hnd);
					invoker.weaponstatus[BRONS_SIDESADDLE]+=hnd;
					A_StartSound("weapons/pocket",CHAN_WEAPON);
				}
			}
			BLSG A 0 {
				if(
					!PressingReload()
					&&!PressingAltReload()
				)setweaponstate("reloadSSend");
				else if(
					invoker.weaponstatus[BRONS_SIDESADDLE]<3
					&&countinv("BrontornisRound")
				)setweaponstate("ReloadSSrestart");
			}
		reloadSSend:
			BLSG A 3 offset(2,34);
			BLSG A 1 offset(1,34);
			goto nope;

		unloadSS:
			BLSG A 2 offset(1,34) A_JumpIf(invoker.weaponstatus[BRONS_SIDESADDLE]<1,"nope");
			BLSG A 1 offset(2,34);
			BLSG A 1 offset(3,36);
		unloadSSLoop1:
			BLSG A 4 offset(4,36);
			BLSG A 2 offset(5,37) A_UnloadSideSaddle(BRONS_SIDESADDLE);
			BLSG A 3 offset(4,36){	//decide whether to loop
				if(
					PressingReload()
					||PressingFire()
					||PressingAltfire()
					||invoker.weaponstatus[BRONS_SIDESADDLE]<1
				)setweaponstate("unloadSSend");
			}goto unloadSSLoop1;
		unloadSSend:
			BLSG A 3 offset(4,35);
			BLSG A 2 offset(3,35);
			BLSG A 1 offset(2,34);
			BLSG A 1 offset(1,34);
			goto nope;
		
		unload:
			BLSG A 0{
				if(
					invoker.weaponstatus[BRONS_SIDESADDLE]>0
					&&!(player.cmd.buttons&BT_USE)
				)setweaponstate("unloadSS");
			}
			BLSG A 0{
				invoker.weaponstatus[0]|=BRONF_JUSTUNLOAD;
			}goto unloadstart;

		unloadstart:
			BLSG A 1;
			BLSG CCC 2 A_MuzzleClimb(
				-frandom(0.5,0.6),frandom(0.5,0.6),
				-frandom(0.5,0.6),frandom(0.5,0.6)
			);
			BLSG C 1 offset(1,34);
			BLSG C 1 offset(2,44) A_SetTics(invoker.weaponstatus[BRONS_HEAT]>>3);
			BLSG C 1 offset(3,42) A_StartSound("weapons/brontoopen",8,CHANF_OVERLAP);
			BLSG D 3 offset(4,34){
				int chm=invoker.weaponstatus[BRONS_CHAMBER];
				int bheat=invoker.weaponstatus[BRONS_HEAT];
				invoker.weaponstatus[BRONS_CHAMBER]=0;
				if(chm<1){
					A_SetTics(3+max(0,bheat-20));
					return;
				}

				A_StartSound("weapons/brontoload",8,CHANF_OVERLAP);
				if(chm>1){
					double aaa=angle;
					bool id=(Wads.CheckNumForName("id",0)!=-1);
					if(id)aaa+=5;else aaa-=5;
					let bbr=spawn("BrontornisRound",
						pos+(
							cos(pitch)*(
								cos(aaa)*10,
								sin(aaa)*10
							),
							height*0.8-sin(pitch)*8
						),ALLOW_REPLACE
					);
					bbr.translation=translation;
					if(id)aaa=angle+50;else aaa=angle-50;
					bbr.vel=(vel.xy+(cos(aaa),sin(aaa)),vel.z+1.);
					if(!A_JumpIfInventory("BrontornisRound",0,"null"))GrabThinker.Grab(self,bbr,5);
				}else if(chm==1){
					A_StartSound("weapons/brontopop",8,CHANF_OVERLAP,
						volume:0.04*bheat
					);
					A_SpawnItemEx("TerrorCasing",
						cos(pitch)*4,0,height*0.8-sin(pitch)*4,
						vel.x,vel.y,vel.z+min(0.12*bheat,4),
						frandom(-1,1),SXF_ABSOLUTEMOMENTUM|
						SXF_NOCHECKPOSITION|SXF_TRANSFERPITCH|
						SXF_TRANSFERTRANSLATION
					);
				}
			}
			BLSG E 1 offset(0,36);
			BLSG E 1 offset(0,38){
				if(!(invoker.weaponstatus[0]&BRONF_JUSTUNLOAD))A_StartSound("weapons/pocket",9,CHANF_OVERLAP);
			}
			BLSG E 1 offset(0,42);
			BLSG E 1 offset(0,48);
			BLSG E 1 offset(0,54);
			BLSG E 1 offset(0,62);
			TNT1 A 0 A_JumpIf(invoker.weaponstatus[BRONS_SIDESADDLE]>0&&invoker.weaponstatus[0]&BRONF_FROMPOCKETS,"reloadsaddle");
			TNT1 A 3;
			TNT1 A 8 A_JumpIf(invoker.weaponstatus[0]&BRONF_JUSTUNLOAD,1);
			TNT1 A 10{
				if(invoker.weaponstatus[0]&BRONF_JUSTUNLOAD)return;
				invoker.weaponstatus[BRONS_CHAMBER]=2;
				A_TakeInventory("BrontornisRound",1,TIF_NOTAKEINFINITE);
				A_StartSound("weapons/brontoload",8,CHANF_OVERLAP);
			}
			BLSG B 1 offset(0,67);
			BLSG B 1 offset(0,60);
			BLSG B 1 offset(0,56);
			BLSG B 1 offset(0,53);
			BLSG B 1 offset(0,52);
			goto reloadend;

		reloadsaddle:
			TNT1 A 3;
			TNT1 A 8 A_JumpIf(invoker.weaponstatus[0]&BRONF_JUSTUNLOAD,1);
			TNT1 A 4{
				invoker.weaponstatus[BRONS_CHAMBER]=2;
				invoker.weaponstatus[BRONS_SIDESADDLE]--;
				A_StartSound("weapons/brontoload",CHAN_WEAPON);
			}
			BLSG B 1 offset(0,67);
			BLSG B 1 offset(0,60);
			BLSG B 1 offset(0,56);
			BLSG B 1 offset(0,53);
			BLSG B 1 offset(0,52);
			goto reloadend;

		cannibalize:
			BLSG A 2 offset(0,36) A_JumpIf(!countinv("RIBrontoBuddy"),"nope");
			BLSG A 2 offset(0,40) A_StartSound("weapons/pocket",CHAN_WEAPON);
			BLSG A 6 offset(0,42);
			BLSG A 4 offset(0,44);
			BLSG A 6 offset(0,42);
			BLSG A 2 offset (0,36) A_CannibalizeOtherShotgun();
			goto ready;

		spawn:
			BLBR A -1 nodelay{
				if(invoker.weaponstatus[BRONS_SIDESADDLE]==1){frame=1;
				}else if(invoker.weaponstatus[BRONS_SIDESADDLE]==2){frame=2;
				}else if(invoker.weaponstatus[BRONS_SIDESADDLE]==3){frame=3;
				}else if(invoker.weaponstatus[BRONS_SIDESADDLE]<1){frame=0;
				}
			}
	}

	override void InitializeWepStats(bool idfa){
		super.InitializeWepStats(idfa);

		weaponstatus[BRONS_SIDESADDLE]=3;
	}

	int handshells;
	action void EmptyHand(int amt=-1,bool careful=false){
		if(!amt)return;
		if(amt>0)invoker.handshells=amt;
		while(invoker.handshells>0){
			if(careful&&!A_JumpIfInventory("BrontornisRound",0,"null")){
				invoker.handshells--;
				HDF.Give(self,"BrontornisRound",1);
 			}else{
				invoker.handshells--;
				A_SpawnItemEx("BrontornisRound",
					cos(pitch)*5,1,height-7-sin(pitch)*5,
					cos(pitch)*cos(angle)*frandom(1,4)+vel.x,
					cos(pitch)*sin(angle)*frandom(1,4)+vel.y,
					-sin(pitch)*random(1,4)+vel.z,
					0,SXF_ABSOLUTEMOMENTUM|SXF_NOCHECKPOSITION|SXF_TRANSFERPITCH
				);
			}
		}
	}
}

enum brontostatus{
	BRONF_JUSTUNLOAD=1,
	BRONF_FROMPOCKETS=2,

	BRONS_STATUS=0,
	BRONS_CHAMBER=1,
	BRONS_HEAT=2,
	BRONS_DOT=3,
	BRONS_SIDESADDLE=4,
};