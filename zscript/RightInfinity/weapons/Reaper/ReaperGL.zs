// ------------------------------------------------------------
// SMG
// ------------------------------------------------------------
const RILD_REAPGL="RPG";

class RIReaperGL:RIReaper{
	default{
		//$Category "Weapons/Hideous Destructor"
		//$Title "REAPRGL"
		//$Sprite "ASHGA0"

		obituary "$OB_REAPER_GL";
		inventory.pickupmessage "$PICKUP_REAPER_GL";
		inventory.icon "ASHGA0";
		hdweapon.refid RILD_REAPGL;
		tag "$TAG_REAPER_GL";
	}

	override double gunmass(){
		return super.gunmass() + 1 + (weaponstatus[0]&ASHTF_GZCHAMBER ? 1.0 : 0.0);
	}

	override double weaponbulk(){
		double blx=super.weaponbulk() + 25;
		bool mgl=weaponstatus[0]&ASHTF_GZCHAMBER;

		return blx + (mgl?ENC_ROCKETLOADED:0.);
	}

	//returns the power of the load just fired
	static double Fire(actor caller,int choke=1){
		double spread=7.;
		double speedfactor=1.;
		let hhh=RIreaperGL(caller.findinventory("RIReaperGL"));
		if(hhh)choke=hhh.weaponstatus[ASHTS_CHOKE];

		choke=clamp(choke,0,7);
		spread=6.5-0.5*choke;
		speedfactor=1.+0.02857*choke;

		double shotpower=frandom(0.9,1.05);
		spread*=shotpower;
		speedfactor*=shotpower;
		HDBulletActor.FireBullet(caller,"HDB_wad");
		let p=HDBulletActor.FireBullet(caller,"HDB_00",
			spread:spread,speedfactor:speedfactor,amount:10
		);
		distantnoise.make(p,"world/shotgunfar");
		caller.A_StartSound("weapons/rprbang",CHAN_WEAPON);
		return shotpower;
	}

	override string,double getpickupsprite(){
		string spr;
		int wepstat0=weaponstatus[0];
		spr="ASHG";
		//set to no-mag frame
		if(weaponstatus[ASHTS_BOXER]==1){
			if(weaponstatus[ASHTS_MAG]<0)spr=spr.."B";
				else spr=spr.."E";
			}else{
				if(weaponstatus[ASHTS_MAG]<0)spr=spr.."B";
				else spr=spr.."A";
			}
		return spr.."0",1.;
	}

	override void DrawHUDStuff(HDStatusBar sb,HDWeapon hdw,HDPlayerPawn hpl){
		super.DrawHUDStuff(sb, hdw, hpl);

		if(sb.hudlevel == 1){
			// Draw Extra Rocquettes
			sb.drawimage("ROQPA0",(-73,-4),sb.DI_SCREEN_CENTER_BOTTOM,scale:(0.6,0.6));
			sb.drawnum(hpl.countinv("HDRocketAmmo"),-73,-8,sb.DI_SCREEN_CENTER_BOTTOM,font.CR_BLACK);
		}
	}

	override void DrawChamberedRounds(HDStatusBar sb, HDWeapon hdw, HDPlayerPawn hpl) {

		// Draw Chambered Shell
		if(hdw.weaponstatus[ASHTS_CHAMBER]==3){
			sb.drawrect(-30-3,-25-5,3,5);
			sb.drawrect(-30-3,-22-2,3,2);
		}else if(hdw.weaponstatus[ASHTS_CHAMBER]==2){
			sb.drawrect(-30-3,-25-2,3,2);
			sb.drawrect(-30-3,-22-2,3,2);
		}else if(hdw.weaponstatus[ASHTS_CHAMBER]==1){
			sb.drawrect(-30-3,-22-2,3,2);
		}

		// Draw Chambered Rocquette
		if(hdw.weaponstatus[0]&ASHTF_GZCHAMBER){
			sb.drawrect(-23-3,-22-1.5,3,1.5);
			sb.drawrect(-24-1,-22-8,1,8);
			sb.drawrect(-23-3,-25-4,3,4);
		}
	}

	override string gethelptext(){
		return
		WEPHELP_FIRESHOOT
		..WEPHELP_ALTFIRE.."  Swap to Grenade Launcher\n"
		..WEPHELP_ALTRELOAD.."  Reload Grenade Launcher\n"
		..WEPHELP_RELOAD.."  Reload/Cycle bolt (Hold "..WEPHELP_FIREMODE.." to swap magazine types\)\n"
		..WEPHELP_FIREMODE.."  Destroy/Annihilate\n"
		..WEPHELP_MAGMANAGER
		..WEPHELP_UNLOADUNLOAD
		;
	}
	override void DrawSightPicture(
		HDStatusBar sb,HDWeapon hdw,HDPlayerPawn hpl,
		bool sightbob,vector2 bob,double fov,bool scopeview,actor hpc,string whichdot
	){
		if(hdw.weaponstatus[0]&ASHTF_GLMODE){
			sb.drawgrenadeladder(hdw.airburst,bob);
		}else {
			super.DrawSightPicture(sb, hdw, hpl, sightbob, bob, fov, scopeview, hpc, whichdot);
		}
	}
	states{
	select0:
		#### # 0 A_JumpIf(invoker.weaponstatus[ASHTS_FLAGS]&ASHTF_GLMODE,"select0rigren");
		ASTA JIHGFEDCBA 0 A_ReaperSpriteSelect();
		goto select0big;
	deselect0:
		#### # 0 A_JumpIf(invoker.weaponstatus[ASHTS_FLAGS]&ASHTF_GLMODE,"deselect0rigren");
		ASTA JIHGFEDCBA 0 A_ReaperSpriteSelect();
		goto deselect0big;
	ready:
		ASTA JIHGFEDCBA 0 A_ReaperSpriteSelect();
		#### # 0 A_JumpIf(invoker.weaponstatus[ASHTS_FLAGS]&ASHTF_GLMODE, 2);
		#### # 1{
			A_SetCrosshair(21);
			A_WeaponReady(WRF_ALL);
		}
		goto readyend;
		ASTL JIHGFEDCBA 0 A_ReaperSpriteSelect();
		#### # 1{
			A_SetCrosshair(21);
			A_WeaponReady(WRF_ALL);
		}
		goto readyend;

	user2:
	firemode:
		#### # 0 A_JumpIf(invoker.weaponstatus[0]&ASHTF_GLMODE,"abadjust");
		ASTA JIHGFEDCBA 0 A_ReaperSpriteSelect();
		#### # 3;
		#### # 0 { if(PressingReload())setweaponstate("reloadselect");
					}
		#### # 1{
			int aut=invoker.weaponstatus[ASHTS_AUTO];
			if(aut>=0){
				invoker.weaponstatus[ASHTS_AUTO]=aut==0?1:0;
			}
		}goto nope;
	fire:
		#### JIHGFEDCBA 0 A_ReaperSpriteSelect();
		#### # 0{
			if(invoker.weaponstatus[ASHTS_FLAGS]&ASHTF_GLMODE)setweaponstate("firefrag");
		}goto fire2;
	user4:
	unload:
		ASTA JIHGFEDCBA 0 A_ReaperSpriteSelect();
		#### # 0{
			invoker.weaponstatus[ASHTS_FLAGS]|=ASHTF_JUSTUNLOAD;
			if(invoker.weaponstatus[0]&ASHTF_GLMODE){
				setweaponstate("unloadgrenade");
			}else if(invoker.weaponstatus[ASHTS_MAG]>=0){
				if(invoker.weaponstatus[ASHTS_BOXER]>0){
				setweaponstate("boxout");
				}else{
				setweaponstate("unmag");
				}
			}else if(invoker.weaponstatus[ASHTS_CHAMBER]>0){
				setweaponstate("prechamber");
			}
		}goto nope;
	nadeflash:
		ASTL JIHGFEDCBA 0 A_ReaperSpriteSelect();		
		#### # 0 A_JumpIf(invoker.weaponstatus[ASHTS_FLAGS]&ASHTF_GZCHAMBER,1);
		stop; // this does nothing (?now?) but I'll keep it here anyway~
		#### # 2 offset(0,15){
			A_FireHDGL();
			invoker.weaponstatus[ASHTS_FLAGS]&=~ASHTF_GZCHAMBER;
			A_StartSound("weapons/grenadeshot",CHAN_WEAPON);
			A_ZoomRecoil(0.95);
		}
		#### # 2 A_MuzzleClimb(
			0,0,0,0,
			-1.2,-3.,
			-1.,-2.8
		);
		stop;
	firefrag:
		ASTL JIHGFEDCBA 0 A_ReaperSpriteSelect();
		#### # 0 A_JumpIf(invoker.weaponstatus[ASHTS_FLAGS]&ASHTF_GZCHAMBER,1);
		goto nope; //Note to tell Matt that the ZM's GL causes a flash even when unloaded
		#### # 2;
		#### # 1 A_Gunflash("nadeflash");
		#### # 2 offset(0,15);
		goto nope;


	altfire:
		ASTL JIHGFEDCBA 0 A_ReaperSpriteSelect();
		#### # 1 offset(6,0){
			invoker.weaponstatus[0]^=ASHTF_GLMODE;
			invoker.airburst=0;
			A_SetCrosshair(21);
			A_SetHelpText();
		}goto nope;
	
	altreload:
		#### # 0{
			invoker.weaponstatus[ASHTS_FLAGS]&=~ASHTF_JUSTUNLOAD;
			if(!(invoker.weaponstatus[ASHTS_FLAGS]&ASHTF_GZCHAMBER)
				&&countinv("HDRocketAmmo")
			)setweaponstate("unloadgrenade");
		}goto nope;
	unloadgrenade:
	//unload is also reload. Genius
		ASTL JIHGFEDCBA 0 A_ReaperSpriteSelect();
		#### # 0{
			A_SetCrosshair(21);
			A_MuzzleClimb(-0.3,-0.3);
		}
		ASTJ JIHGFEDCBA 0 A_ReaperSpriteSelect();
		#### # 2 offset(0,34);
		#### # 1 offset(4,38){
			A_MuzzleClimb(-0.3,-0.3);
		}
		#### # 2 offset(8,48){
			A_StartSound("weapons/grenopen",5);
			A_MuzzleClimb(-0.3,-0.3);
			if(invoker.weaponstatus[ASHTS_FLAGS]&ASHTF_GZCHAMBER)A_StartSound("weapons/grenreload",CHAN_WEAPON);
		}
		ASTK JIHGFEDCBA 0 A_ReaperSpriteSelect();
		#### # 10 offset(10,49){
			if(!(invoker.weaponstatus[ASHTS_FLAGS]&ASHTF_GZCHAMBER)){
				if(!(invoker.weaponstatus[ASHTS_FLAGS]&ASHTF_JUSTUNLOAD))A_SetTics(3);
				return;
			}
			invoker.weaponstatus[ASHTS_FLAGS]&=~ASHTF_GZCHAMBER;
			if(
				!PressingUnload()
				||A_JumpIfInventory("HDRocketAmmo",0,"null")
			){
				A_SpawnItemEx("HDRocketAmmo",
					cos(pitch)*10,0,height-10-10*sin(pitch),vel.x,vel.y,vel.z,0,
					SXF_ABSOLUTEMOMENTUM|SXF_NOCHECKPOSITION|SXF_TRANSFERPITCH
				);
			}else{
				A_StartSound("weapons/pocket",5);
				A_GiveInventory("HDRocketAmmo",1);
				A_MuzzleClimb(frandom(0.8,-0.2),frandom(0.4,-0.2));
			}
		}
		#### # 0 A_JumpIf(invoker.weaponstatus[ASHTS_FLAGS]&ASHTF_JUSTUNLOAD,"greloadend");
	loadgrenade:
		#### # 4 offset(10,50) A_StartSound("weapons/pocket",CHAN_WEAPON);
		#### # 8 offset(10,50) A_MuzzleClimb(frandom(-0.2,0.8),frandom(-0.2,0.4));
		#### # 8 offset(10,50) A_MuzzleClimb(frandom(-0.2,0.8),frandom(-0.2,0.4));
		#### # 8 offset(10,50) A_MuzzleClimb(frandom(-0.2,0.8),frandom(-0.2,0.4));
		#### # 18 offset(8,50){
			A_TakeInventory("HDRocketAmmo",1,TIF_NOTAKEINFINITE);
			invoker.weaponstatus[ASHTS_FLAGS]|=ASHTF_GZCHAMBER;
			A_StartSound("weapons/grenreload",CHAN_WEAPON);
		}
	greloadend:
		ASTJ JIHGFEDCBA 0 A_ReaperSpriteSelect();
		#### # 4 offset(4,44) A_StartSound("weapons/grenopen",CHAN_WEAPON);
		ASTL JIHGFEDCBA 0 A_ReaperSpriteSelect();
		#### # 1 offset(0,40);
		#### # 1 offset(0,34) A_MuzzleClimb(frandom(-2.4,0.2),frandom(-1.4,0.2));
		goto nope;

	spawn:
		ASHG A -1 nodelay{
			if(invoker.weaponstatus[ASHTS_MAG]<0)frame=1;
			if(invoker.weaponstatus[ASHTS_BOXER]==1&&invoker.weaponstatus[ASHTS_MAG]>=0)frame=4;
		}
	}
	override void InitializeWepStats(bool idfa){
		super.InitializeWepStats(idfa);
		weaponstatus[ASHTS_FLAGS]|=ASHTF_GZCHAMBER;
	}
}
