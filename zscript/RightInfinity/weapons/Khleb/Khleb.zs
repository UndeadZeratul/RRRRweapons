// ------------------------------------------------------------
// A 12-gauge pump for protection
// ------------------------------------------------------------
class RIKhleb : HDShotgun {
	default {
		//$Category "Weapons/Hideous Destructor"
		//$Title "Khleb shotgun"
		//$Sprite "KHLEBA0"

		tag "$TAG_KHLEB";
		obituary "$OB_KHLEB";

		scale 0.6;

		Inventory.pickupmessage "$PICKUP_KHLEB";

		Weapon.selectionorder 31;
		Weapon.slotnumber 3;
		Weapon.slotpriority 1;
		Weapon.bobrangex 0.21;
		Weapon.bobrangey 0.86;

		HDWeapon.barrelsize 30, 0.5, 2;
		HDWeapon.refid "klb";
		hdweapon.loadoutcodes "
			\cuslugs - 0/1, loaded with slugs";
	}

	override string,double getpickupsprite(bool usespare) { return "KLEBA0", 1.0; }

	//returns the power of the load just fired
	static double FireShell(actor caller) {
		double spread = 6.5;
		double speedfactor = 1.02857;

		double shotpower = getshotpower();
		spread *= shotpower;
		speedfactor *= shotpower;

		HDBulletActor.FireBullet(caller, "HDB_4wad");
		let p = HDBulletActor.FireBullet(caller, "HDB_400", spread: spread, speedfactor: speedfactor, amount: 12);

		DistantNoise.make(p, "world/shotgunfar");
		caller.A_StartSound("weapons/khlebShot", CHAN_WEAPON);
		// caller.A_StartSound("weapons/khlebBlast", 9, CHANF_DEFAULT, 0.1);

		return shotpower;
	}

	static double FireSlug(actor caller) {
		double spread = 3.5;
		double speedfactor = 1.0;

		double shotpower = getshotpower();
		spread *= shotpower;
		speedfactor *= shotpower;

		HDBulletActor.FireBullet(caller, "HDB_4wad");
		let p = HDBulletActor.FireBullet(caller, "HDB_4GS", spread: spread, speedfactor: 1.01);
		DistantNoise.make(p, "world/shotgunfar");
		caller.A_StartSound("weapons/khlebShot", CHAN_WEAPON);
		// caller.A_StartSound("weapons/khlebBlast", 9, CHANF_DEFAULT, 0.1);

		return shotpower;
	}

	action void A_FireKhleb() {
		double shotpower = invoker.weaponStatus[KHLEBS_CHAMBER] == 4 ? invoker.FireSlug(self) : invoker.FireShell(self);

		A_GunFlash();

		Vector2 shotrecoil = (randompick(-1, 1), -3.2) * shotpower;
		A_ZoomRecoil(0.855);
		A_MuzzleClimb(
			0, 0,
			shotrecoil.x, shotrecoil.y,
			randompick(-2, 4) * shotpower, -1.3 * shotpower
		);

		invoker.weaponStatus[KHLEBS_CHAMBER] -= 2;
		invoker.shotpower = shotpower;
	}

	override void DrawHUDStuff(HDStatusBar sb, HDWeapon hdw, HDPlayerPawn hpl) {

		if (sb.hudlevel == 1) {
			sb.drawimage("4GSIA0", (-55, -10), sb.DI_SCREEN_CENTER_BOTTOM);
			sb.drawnum(hpl.countinv("HD4GBAmmo"), -54, -8, sb.DI_SCREEN_CENTER_BOTTOM);

			sb.drawimage("4GS1A0",(-65, -10), sb.DI_SCREEN_CENTER_BOTTOM);
			sb.drawnum(hpl.countinv("HD4GSAmmo"), -64, -8, sb.DI_SCREEN_CENTER_BOTTOM);
		}

		int chm = hdw.weaponStatus[KHLEBS_CHAMBER];
		int tb1 = hdw.weaponStatus[KHLEBS_TB1];
		int tb2 = hdw.weaponStatus[KHLEBS_TB2];
		int tb3 = hdw.weaponStatus[KHLEBS_TB3];
		// int tb4 = hdw.weaponStatus[KHLEBS_TB4];
		
		let pos = (-16, -11);
		
		// Draw Chambered Round
		if (chm > 0) {

			if (chm == 4) {
				HDCore.DrawFancySlug(
					sb,
					Color(255, sb.sbColour.r, sb.sbColour.g, sb.sbColour.b),
					pos,
					DRAWPREFAB_EW,
					1.0,
					sb.DI_SCREEN_CENTER_BOTTOM
				);
			} else if (chm == 3) {
				HDCore.DrawFancyShell(
					sb,
					Color(255, sb.sbColour.r, sb.sbColour.g, sb.sbColour.b),
					pos,
					DRAWPREFAB_EW,
					1.0,
					sb.DI_SCREEN_CENTER_BOTTOM
				);
			} else if (chm == 1) {
				HDCore.DrawSpentShell(
					sb,
					Color(255, sb.sbColour.r, sb.sbColour.g, sb.sbColour.b),
					pos,
					DRAWPREFAB_EW,
					1.0,
					sb.DI_SCREEN_CENTER_BOTTOM
				);
			}
		}

		// Draw Rounds in Tube
		if (tb1 > 0) {
			pos = (-16, -7);

			if (tb1 == 4) {
				HDCore.DrawFancySlug(
					sb,
					Color(255, sb.sbColour.r, sb.sbColour.g, sb.sbColour.b),
					pos,
					DRAWPREFAB_EW,
					1.0,
					sb.DI_SCREEN_CENTER_BOTTOM
				);
			} else if (tb1 == 3) {
				HDCore.DrawFancyShell(
					sb,
					Color(255, sb.sbColour.r, sb.sbColour.g, sb.sbColour.b),
					pos,
					DRAWPREFAB_EW,
					1.0,
					sb.DI_SCREEN_CENTER_BOTTOM
				);
			} else if (tb1 == 1) {
				HDCore.DrawSpentShell(
					sb,
					Color(255, sb.sbColour.r, sb.sbColour.g, sb.sbColour.b),
					pos,
					DRAWPREFAB_EW,
					1.0,
					sb.DI_SCREEN_CENTER_BOTTOM
				);
			}
		}

		if (tb2 > 0) {
			pos = (-25, -7);

			if (tb2 == 4) {
				HDCore.DrawFancySlug(
					sb,
					Color(255, sb.sbColour.r, sb.sbColour.g, sb.sbColour.b),
					pos,
					DRAWPREFAB_EW,
					1.0,
					sb.DI_SCREEN_CENTER_BOTTOM
				);
			} else if (tb2 == 3) {
				HDCore.DrawFancyShell(
					sb,
					Color(255, sb.sbColour.r, sb.sbColour.g, sb.sbColour.b),
					pos,
					DRAWPREFAB_EW,
					1.0,
					sb.DI_SCREEN_CENTER_BOTTOM
				);
			} else if (tb2 == 1) {
				HDCore.DrawSpentShell(
					sb,
					Color(255, sb.sbColour.r, sb.sbColour.g, sb.sbColour.b),
					pos,
					DRAWPREFAB_EW,
					1.0,
					sb.DI_SCREEN_CENTER_BOTTOM
				);
			}
		}

		if (tb3 > 0) {
			pos = (-34, -7);

			if (tb3 == 4) {
				HDCore.DrawFancySlug(
					sb,
					Color(255, sb.sbColour.r, sb.sbColour.g, sb.sbColour.b),
					pos,
					DRAWPREFAB_EW,
					1.0,
					sb.DI_SCREEN_CENTER_BOTTOM
				);
			} else if (tb3 == 3) {
				HDCore.DrawFancyShell(
					sb,
					Color(255, sb.sbColour.r, sb.sbColour.g, sb.sbColour.b),
					pos,
					DRAWPREFAB_EW,
					1.0,
					sb.DI_SCREEN_CENTER_BOTTOM
				);
			} else if (tb3 == 1) {
				HDCore.DrawSpentShell(
					sb,
					Color(255, sb.sbColour.r, sb.sbColour.g, sb.sbColour.b),
					pos,
					DRAWPREFAB_EW,
					1.0,
					sb.DI_SCREEN_CENTER_BOTTOM
				);
			}
		}

		// if (tb4 > 0) {
		// 	pos = (-43, -7);

		// 	if (tb4 == 4) {
		// 		HDCore.DrawFancySlug(
		// 			sb,
		// 			Color(255, sb.sbColour.r, sb.sbColour.g, sb.sbColour.b),
		// 			pos,
		// 			DRAWPREFAB_EW,
		// 			1.0,
		// 			sb.DI_SCREEN_CENTER_BOTTOM
		// 		);
		// 	} else if (tb4 == 3) {
		// 		HDCore.DrawFancyShell(
		// 			sb,
		// 			Color(255, sb.sbColour.r, sb.sbColour.g, sb.sbColour.b),
		// 			pos,
		// 			DRAWPREFAB_EW,
		// 			1.0,
		// 			sb.DI_SCREEN_CENTER_BOTTOM
		// 		);
		// 	} else if (tb4 == 1) {
		// 		HDCore.DrawSpentShell(
		// 			sb,
		// 			Color(255, sb.sbColour.r, sb.sbColour.g, sb.sbColour.b),
		// 			pos,
		// 			DRAWPREFAB_EW,
		// 			1.0,
		// 			sb.DI_SCREEN_CENTER_BOTTOM
		// 		);
		// 	}
		// }
	}

	// FIXME: Replace with Khleb Help Text
	override string gethelptext() {
		LocalizeHelp();
		return
		LWPHELP_FIRESHOOT
		..LWPHELP_ALTFIRE..StringTable.Localize("$PUMP")
		..WEPHELP_RELOAD..StringTable.Localize("$KLBWH_RELOAD")
		..WEPHELP_ALTRELOAD..StringTable.Localize("$KLBWH_ALTRELOAD")
		..StringTable.Localize("$KLBWH_WHENPUMPED")..WEPHELP_ALTRELOAD.."/"..WEPHELP_RELOAD..StringTable.Localize("$KLBWH_SLUGSHELL")
		..LWPHELP_MAGMANAGER
		..LWPHELP_UNLOADUNLOAD
		;
	}

	override void DrawSightPicture(
		HDStatusBar sb, HDWeapon hdw, HDPlayerPawn hpl,
		bool sightbob, Vector2 bob, double fov, bool scopeview, Actor hpc
	) {
		int cx,cy,cw,ch;
		[cx,cy,cw,ch]=screen.GetClipRect();

		sb.SetClipRect(
			-16 + bob.x, -4 + bob.y, 32, 40,
			sb.DI_SCREEN_CENTER
		);

		Vector2 bobb = bob * 1.1;
		sb.drawimage(
			"frntsite",
			(0, 0) + bobb,
			sb.DI_SCREEN_CENTER|sb.DI_ITEM_TOP
		);
		sb.SetClipRect(cx,cy,cw,ch);

		sb.drawimage(
			"sgbaksit",
			(0, 0) + bob,
			sb.DI_SCREEN_CENTER|sb.DI_ITEM_TOP,
			alpha: 0.9
		);
	}

	override double gunmass() {
		return 10;
	}

	override double weaponbulk() {
		return 125
			+ ((weaponStatus[KHLEBS_TB1] > 2 ? 1 : 0) * weaponStatus[KHLEBS_TB1] > 3 ? ENC_4GSLOADED : ENC_4GBLOADED)
			+ ((weaponStatus[KHLEBS_TB2] > 2 ? 1 : 0) * weaponStatus[KHLEBS_TB2] > 3 ? ENC_4GSLOADED : ENC_4GBLOADED)
			+ ((weaponStatus[KHLEBS_TB3] > 2 ? 1 : 0) * weaponStatus[KHLEBS_TB3] > 3 ? ENC_4GSLOADED : ENC_4GBLOADED)
			/* + ((weaponStatus[KHLEBS_TB4] > 2 ? 1 : 0) * weaponStatus[KHLEBS_TB4] > 3 ? ENC_4GSLOADED : ENC_4GBLOADED) */;
	}

	override void DropOneAmmo(int amt) {
		if (owner) {
			amt = clamp(amt, 1, 10);
			owner.A_DropInventory("HD4GSAmmo", amt * 4);
			owner.A_DropInventory("HD4GBAmmo", amt * 4);
		}
	}

	override void ForceBasicAmmo() {
		if (weaponStatus[0]&KHLEBF_SLUGLOADOUT) {
			owner.A_SetInventory("HD4GSAmmo", 4);
		} else {
			owner.A_SetInventory("HD4GBAmmo", 4);
		}
	}

	override void DetachFromOwner() {
		if (handshells > 0) {
			let ammo = (weaponStatus[0]&KHLEBF_SLUG) ? "HD4GSAmmo" : "HD4GBAmmo";
			
			if (owner) {
				owner.A_DropItem(ammo, handshells);
			} else {
				A_DropItem(ammo, handshells);
			}
		}

		handshells = 0;
		HDWeapon.detachfromowner();
	}

	action void A_SetAltHold(bool which) {
		if (which) {
			invoker.weaponStatus[0] |= KHLEBF_ALTHOLDING;
		} else {
			invoker.weaponStatus[0] &= ~KHLEBF_ALTHOLDING;
		}
	}
	action void A_PushKhlebTube() {
		invoker.weaponStatus[KHLEBS_TB1] = invoker.weaponStatus[KHLEBS_TB2];
		invoker.weaponStatus[KHLEBS_TB2] = invoker.weaponStatus[KHLEBS_TB3];
		invoker.weaponStatus[KHLEBS_TB3] = 0; // invoker.weaponStatus[KHLEBS_TB4];
		// invoker.weaponStatus[KHLEBS_TB4] = 0;
	}

	action void A_Chamber(bool careful = false) {
		int chm = invoker.weaponStatus[KHLEBS_CHAMBER];
		invoker.weaponStatus[KHLEBS_CHAMBER] = invoker.weaponStatus[KHLEBS_TB1];

		A_PushKhlebTube();

		Vector3 cockdir;
		double cp = cos(pitch);

		if (careful) {
			cockdir = (-cp, cp, -5);
		} else {
			cockdir = (0, -cp * 5, sin(pitch) * frandom(4, 6));
		}

		cockdir.xy = RotateVector(cockdir.xy, angle);

		bool pocketed = false;
		if ( chm > 2) {
			if (careful && !A_JumpIfInventory(chm == 4 ? "HD4GSAmmo" : "HD4GBAmmo", 0, "null")) {
				HDF.Give(self, "HD4GBAmmo", 1);
				pocketed = true;
			}
		} else if (chm > 0) {	
			cockdir *= frandom(1.0, 1.3);
		}

		if (!pocketed && chm >= 1) {
			Vector3 gunofs = HDMath.RotateVec3D((9, -1, -2), angle, pitch);
			Actor rrr = null;

			if (chm > 2) {
				rrr = spawn(chm == 4 ? "HDFumbling4GS" : "HDFumbling4GB", (pos.xy, pos.z + height * 0.85) + gunofs + viewpos.offset);
			} else {
				rrr = spawn(chm == 2 ? "HDSpent4GS" : "HDSpent4GBb", (pos.xy, pos.z + height * 0.85) + gunofs + viewpos.offset);
			}

			rrr.target = self;
			rrr.angle = angle;
			rrr.vel = HDMath.RotateVec3D((1, -5, 0.2), angle, pitch);

			if (chm == 1) rrr.vel *= 1.3;

			rrr.vel += vel;
		}
	}

	action bool A_LoadTubeFromHand() {
		bool slg = invoker.weaponStatus[0]&KHLEBF_SLUG;
		int hand = invoker.handshells;
		if (
			!hand
			|| (
				invoker.weaponStatus[KHLEBS_CHAMBER] > 0
				&& invoker.weaponStatus[KHLEBS_TB1] > 0
				&& invoker.weaponStatus[KHLEBS_TB2] > 0
				&& invoker.weaponStatus[KHLEBS_TB3] > 0
				// && invoker.weaponStatus[KHLEBS_TB4] > 0
			)
		) {
			EmptyHand();
			return false;
		}
		// invoker.weaponStatus[KHLEBS_TB4] = invoker.weaponStatus[KHLEBS_TB3];
		invoker.weaponStatus[KHLEBS_TB3] = invoker.weaponStatus[KHLEBS_TB2];
		invoker.weaponStatus[KHLEBS_TB2] = invoker.weaponStatus[KHLEBS_TB1];
		invoker.weaponStatus[KHLEBS_TB1] = slg ? 4 : 3;
		invoker.handshells--;
		A_StartSound("weapons/khlebReload", 8, CHANF_OVERLAP);
		return true;
	}

	action bool A_GrabShells(int maxhand = 2, bool settics = false, bool alwaysone = false) {
		bool slg = invoker.weaponStatus[0]&KHLEBF_SLUG;

		if (maxhand > 0) {
			EmptyHand();
		} else {
			maxhand = abs(maxhand);
		}

		int toload = min(
			slg ? countinv("HD4GSAmmo") : countinv("HD4GBAmmo"),
			1,
			max(1, health / 22),
			maxhand
		);

		if (toload < 1) return false;

		invoker.handshells = toload;
		A_TakeInventory(slg ? "HD4GSAmmo" : "HD4GBAmmo", toload, TIF_NOTAKEINFINITE);

		if (settics) A_SetTics(7);

		A_StartSound("weapons/pocket",9);
		A_MuzzleClimb(
			frandom(0.1, 0.15), frandom(0.2, 0.4),
			frandom(0.2, 0.25), frandom(0.3, 0.4),
			frandom(0.1, 0.35), frandom(0.3, 0.4),
			frandom(0.1, 0.15), frandom(0.2, 0.4)
		);

		return true;
	}

	action void EmptyHand(int amt = -1, bool careful = false) {
		if (!amt) return;

		if(amt > 0) invoker.handshells = amt;

		while (invoker.handshells > 0) {
			let slug = invoker.weaponStatus[0]&KHLEBF_SLUG;
			let ammo = slug ? "HD4GSAmmo" : "HD4GBAmmo";

			if (careful && !A_JumpIfInventory(ammo, 0, "null")) {
				invoker.handshells--;
				HDF.Give(self, ammo, 1);
 			} else if(invoker.handshells >= 3) {
				invoker.handshells -= 3;

				A_SpawnItemEx(
					slug ? "HD4GSAmmo" : "HD4GBAmmo",
					// slug ? "HDFumbled4GS" : "HDFumbled4GB",
					cos(pitch) * 1, 1, height - 7 - sin(pitch) * 1,
					cos(pitch) * cos(angle) * frandom(1, 2) + vel.x,
					cos(pitch) * sin(angle) * frandom(1, 2) + vel.y,
					-sin(pitch) + vel.z,
					0,
					SXF_ABSOLUTEMOMENTUM|SXF_NOCHECKPOSITION|SXF_TRANSFERPITCH
				);
			} else {
				invoker.handshells--;
				A_SpawnItemEx(slug ? "HDFumbling4GS" : "HDFumbling4GB",
					cos(pitch) * 5, 1, height - 7 - sin(pitch) * 5,
					cos(pitch) * cos(angle) * frandom(1, 4) + vel.x,
					cos(pitch) * sin(angle) * frandom(1, 4) + vel.y,
					-sin(pitch) * random(1, 4) + vel.z,
					0,
					SXF_ABSOLUTEMOMENTUM|SXF_NOCHECKPOSITION|SXF_TRANSFERPITCH
				);
			}
		}
	}

	states {
		select0:
			KLBG A 0;
			goto select0big;
		deselect0:
			KLBG A 0;
			goto deselect0big;
		ready:
			KLBG A 0 A_JumpIf(pressingAltFire(), 2);
			KLBG A 0 {
				if (!pressingAltFire()) {
					if (!pressingFire()) A_ClearRefire();

					A_SetAltHold(false);
				}
			}
			KLBG A 1 A_WeaponReady(WRF_ALL);
			KLBG A 0 {
				invoker.weaponStatus[0] &= ~KHLEBF_SLUG;
			}
			goto readyend;
		hold:
			KLBG A 0 {
				bool paf = pressingAltFire();
				if (
					paf && !(invoker.weaponStatus[0]&KHLEBF_ALTHOLDING)
				) {
					setWeaponState("chamber");
				} else if (!paf) {
					invoker.weaponStatus[0] &= ~KHLEBF_ALTHOLDING;
				}
			}
			KLBG A 1 A_WeaponReady(WRF_NOFIRE);
			KLBG A 0 A_Refire();
			goto ready;
		fire:
			KLBG A 0 A_JumpIf(invoker.weaponStatus[KHLEBS_CHAMBER] > 2, "shoot");
			KLBG A 1 A_WeaponReady(WRF_NONE);
			KLBG A 0 A_Refire();
			goto ready;
		shoot:
			KLBG A 2;
			KLBG A 1 offset(0, 36) A_FireKhleb();
			KLBG E 1;
			goto ready;
		altfire:
		chamber:
			KLBG A 0 A_JumpIf(invoker.weaponStatus[0]&KHLEBF_ALTHOLDING, "nope");
			KLBG A 0 A_SetAltHold(true);
			KLBG A 1 A_StartSound("weapons/khlebRackBak",8);
			KLBG AE 2 A_MuzzleClimb(0, frandom(0.6, 1.0));
			KLBG E 2 A_JumpIf(pressingAltFire(), "longstroke");
			KLBG EA 2 A_MuzzleClimb(0, -frandom(0.6, 1.0));
			KLBG E 0 A_StartSound("weapons/khlebShort", 8);
			KLBG E 0 A_Refire("ready");
			goto ready;
		longstroke:
			KLBG F 2 A_MuzzleClimb(frandom(1.0, 2.0));
			KLBG F 0 {
				A_Chamber();
				A_MuzzleClimb(-frandom(1.0, 2.0));
			}
		racked:
			KLBG F 1 A_WeaponReady(WRF_NOFIRE);
			KLBG F 0 A_JumpIf(!pressingAltFire(), "unrack");
			KLBG F 0 A_JumpIf(pressingunload(), "rackunload");
			KLBG F 0 A_JumpIf(invoker.weaponStatus[KHLEBS_CHAMBER], "racked");
			KLBG F 0{
				int rld = 0;
				if (pressingReload()) {
					rld = 1;
				}else if (pressingAltReload()) {
					rld = 2;
					invoker.weaponStatus[0] |= KHLEBF_SLUG;
				}

				if (
					rld > 0
					&& (
						countinv("HD4GSAmmo")
						|| countinv("HD4GBAmmo")
					)
				) {
					setWeaponState("rackreload");
				}
			}
			loop;
		rackreload:
			KLBG F 1 offset(-1, 35) A_WeaponBusy(true);
			KLBG F 2 offset(-2, 37);
			KLBG F 4 offset(-3, 40);
			KLBG F 1 offset(-4, 42); // A_GrabShells(1, true, true);
			KLBG F 6 offset(-5, 43);
			KLBG F 6 offset(-4, 41) A_StartSound("weapons/pocket",9);
		rackloadone:
			KLBG F 1 offset(-4, 42);
			KLBG F 2 offset(-4, 41) {
				if (pressingAltReload()) invoker.weaponStatus[0] |= KHLEBF_SLUG;
				if (countinv("HD4GSAmmo") > 0 && countinv("HD4GBAmmo") < 1) invoker.weaponStatus[0] |= KHLEBF_SLUG;
				if (countinv("HD4GSAmmo") < 1) invoker.weaponStatus[0] &= ~KHLEBF_SLUG;
			}
			KLBG F 3 offset(-4, 40) {
				bool slg = invoker.weaponStatus[0]&KHLEBF_SLUG;
				switch (invoker.weaponStatus[KHLEBS_CHAMBER]) {
					case 0:
						A_StartSound("weapons/khlebReload", 8, CHANF_OVERLAP);
						A_TakeInventory(slg ? "HD4GSAmmo" : "HD4GBAmmo", 1, TIF_NOTAKEINFINITE);
						invoker.weaponStatus[KHLEBS_CHAMBER] = invoker.weaponStatus[0]&KHLEBF_SLUG ? 4 : 3;
						break;
					case 3:
					case 4:
						if (
							invoker.weaponStatus[KHLEBS_TB1] > 0
							&& invoker.weaponStatus[KHLEBS_TB2] > 0
							&& invoker.weaponStatus[KHLEBS_TB3] > 0
							// && invoker.weaponStatus[KHLEBS_TB4] > 0
						) {
							A_Jump(256, 3);
							break;
						} else {
							A_StartSound("weapons/khlebReload", 8, CHANF_OVERLAP);
							A_TakeInventory(slg ? "HD4GSAmmo" : "HD4GBAmmo", 1, TIF_NOTAKEINFINITE);
							// invoker.weaponStatus[KHLEBS_TB4] = invoker.weaponStatus[KHLEBS_TB3];
							invoker.weaponStatus[KHLEBS_TB3] = invoker.weaponStatus[KHLEBS_TB2];
							invoker.weaponStatus[KHLEBS_TB2] = invoker.weaponStatus[KHLEBS_TB1];
							invoker.weaponStatus[KHLEBS_TB1] = invoker.weaponStatus[KHLEBS_CHAMBER];
							invoker.weaponStatus[KHLEBS_CHAMBER] = invoker.weaponStatus[0]&KHLEBF_SLUG ? 4 : 3;
							break;
						}
						break;
					case 1:
					case 2:
						break;
					default:
						break;
				}
			}
			KLBG F 5 offset(-4, 41);
			KLBG F 4 offset(-4, 40) A_JumpIf(invoker.handshells > 0, "rackloadone");
			goto rackreloadend;
		rackreloadend:
			KLBG F 1 offset(-3, 39) {
				invoker.weaponStatus[0] &= ~KHLEBF_SLUG;
			}
			KLBG F 1 offset(-2, 37);
			KLBG F 1 offset(-1, 34);
			KLBG F 0 A_WeaponBusy(false);
			goto racked;

		rackunload:
			KLBG F 1 offset(-1, 35) A_WeaponBusy(true);
			KLBG F 2 offset(-2, 37);
			KLBG F 4 offset(-3, 40);
			KLBG F 1 offset(-4, 42);
			KLBG F 2 offset(-4, 41);
			KLBG F 3 offset(-4, 40) {
				int chm = invoker.weaponStatus[KHLEBS_CHAMBER];
				invoker.weaponStatus[KHLEBS_CHAMBER] = 0;

				if (chm > 2) {
					A_StartSound("weapons/khlebReload", 8);

					if (A_JumpIfInventory(chm == 4 ? "HD4GSAmmo" : "HD4GBAmmo", 0, "null")) {
						A_SpawnItemEx(
							chm == 4 ? "HDFumbling4GS" : "HDFumbling4GB",
							cos(pitch) * 8, 0, height - 7 - sin(pitch) * 8,
							vel.x + cos(pitch) * cos(angle - random(86, 90)) * 5,
							vel.y + cos(pitch) * sin(angle - random(86, 90)) * 5,
							vel.z + sin(pitch) * random(4,6),
							0,
							SXF_ABSOLUTEMOMENTUM|SXF_NOCHECKPOSITION|SXF_TRANSFERPITCH
						);
					} else {
						HDF.Give(self, chm == 4 ? "HD4GSAmmo" : "HD4GBAmmo", 1);
						A_StartSound("weapons/pocket", 9);
						A_SetTics(5);
					}
				} else if (chm > 0) {
					A_SpawnItemEx(
						chm == 2 ? "HDSpent4GS" : "HDSpent4GBb",
						cos(pitch) * 8, 0, height - 7 - sin(pitch) * 8,
						vel.x + cos(pitch) * cos(angle - random(86, 90)) * 5,
						vel.y + cos(pitch) * sin(angle - random(86, 90)) * 5,
						vel.z + sin(pitch) * random(4,6),
						0,
						SXF_ABSOLUTEMOMENTUM|SXF_NOCHECKPOSITION|SXF_TRANSFERPITCH
					);
				}

				if (chm) A_StartSound("weapons/khlebReload", 8, CHANF_OVERLAP);
			}
			KLBG F 5 offset(-4, 41);
			KLBG F 4 offset(-4, 40) A_JumpIf(invoker.handshells > 0, "rackloadone");
			goto rackreloadend;

		unrack:
			KLBG F 0 A_StartSound("weapons/khlebRackFwd", 8);
			KLBG E 2 A_JumpIf(!pressingFire(), 1);
			KLBG EA 2 {
				if (pressingFire()) A_SetTics(1);
				A_MuzzleClimb(0, -frandom(0.6, 1.0));
			}
			KLBG A 0 A_ClearRefire();
			goto ready;
		flash:
			KLBF A 1 bright {
				A_Light2();
				HDFlashAlpha(-32);
			}
			TNT1 A 1 A_ZoomRecoil(0.9);
			TNT1 A 0 A_Light0();
			TNT1 A 0 A_AlertMonsters();
			stop;
		altreload:
			KLBG A 0 {
				invoker.weaponStatus[0] |= KHLEBF_SLUG;
			}
		reload:
		startreload:
			KLBG A 0 A_JumpIf(countinv("HD4GBAmmo") < 1 && countinv("HD4GSAmmo") < 1, "nope");
			KLBG A 1 A_JumpIf(invoker.weaponStatus[KHLEBS_TB3] > 0, "nope");
			// KLBG A 1 A_JumpIf(invoker.weaponStatus[KHLEBS_TB4] > 0, "nope");
			KLBG AB 4 A_MuzzleClimb(frandom(0.6, 0.7), -frandom(0.6, 0.7));
		reloadstarthand:
			KLBG C 1 offset(0, 36);
			KLBG C 1 offset(0, 38);
			KLBG C 2 offset(0, 36);
			KLBG C 2 offset(0, 34);
			KLBG C 3 offset(0, 36);
			KLBG C 3 offset(0, 40) {
				if (pressingAltReload()) invoker.weaponStatus[0] |= KHLEBF_SLUG;
				if (countinv("HD4GSAmmo") > 0 && countinv("HD4GBAmmo") < 1) invoker.weaponStatus[0] |= KHLEBF_SLUG;
				if (countinv("HD4GSAmmo") < 1) invoker.weaponStatus[0] &= ~KHLEBF_SLUG;
			}
			// KLBG C 0 A_JumpIf(invoker.weaponStatus[0]&KHLEBF_FROMPOCKETS,"reloadpocket");
		// reloadfast:
		// 	KLBG C 4 offset(0,40) A_GrabShells(3, false);
		// 	KLBG C 3 offset(0,42) A_StartSound("weapons/pocket", 9, volume: 0.4);
		// 	KLBG C 3 offset(0,41);
		// 	goto reloadashell;
		reloadpocket:
			KLBG C 4 offset(0, 39) A_GrabShells(3, false);
			// KLBG C 6 offset(0,40) A_JumpIf(health>40,1);
			KLBG C 4 offset(0, 40) A_StartSound("weapons/pocket", 9);
			KLBG C 8 offset(0, 42) A_StartSound("weapons/pocket", 9);
			KLBG C 6 offset(0, 41) A_StartSound("weapons/pocket", 9);
			KLBG C 6 offset(0, 40);
			goto reloadashell;
		reloadashell:
			KLBG C 2 offset(0, 36);
			KLBG C 4 offset(0, 34) A_LoadTubeFromHand();
			KLBG CCCCCC 1 offset(0, 33) {
				if (
					PressingReload()
					|| PressingAltReload()
					|| PressingUnload()
					|| PressingFire()
					|| PressingAltfire()
					|| PressingZoom()
					|| PressingFiremode()
				) {
					invoker.weaponStatus[0] |= KHLEBF_HOLDING;
				} else {
					invoker.weaponStatus[0] &= ~KHLEBF_HOLDING;
				}

				invoker.weaponStatus[0] &= ~KHLEBF_SLUG;

				if (
					invoker.weaponStatus[KHLEBS_TB3] > 0
					// invoker.weaponStatus[KHLEBS_TB4] > 0
					|| (
						invoker.handshells < 1
						&& !countinv("HD4GBAmmo")
						&& !countinv("HD4GSAmmo")
					)
				) {
					setWeaponState("reloadend");
				} else if (!(pressingReload() || pressingAltReload())) {
					setWeaponState("reloadend");
				} else if (invoker.handshells < 1) {
					setWeaponState("reloadstarthand");
				}
			}
			goto reloadashell;
		reloadend:
			KLBG C 4 offset(0, 34) A_StartSound("weapons/khlebOpen", 8, CHANF_OVERLAP);
			KLBG C 1 offset(0, 36) EmptyHand(careful: true);
			KLBG C 1 offset(0, 34) {
				invoker.weaponStatus[0] &= ~KHLEBF_SLUG;
			}
			KLBG CBA 3;
			KLBG A 0 A_JumpIf(invoker.weaponStatus[0]&KHLEBF_HOLDING, "nope");
			goto ready;

		cannibalize:
			goto nope;

		unloadSS:
			goto nope;

		unload:
			KLBG A 1 A_JumpIf(invoker.weaponStatus[KHLEBS_CHAMBER] < 1 && invoker.weaponStatus[KHLEBS_TB1] < 1, "nope");
			KLBG BC 4 A_MuzzleClimb(frandom(1.2, 2.4), -frandom(1.2, 2.4));
			KLBG C 1 offset(0, 34);
			KLBG C 1 offset(0, 36) A_StartSound("weapons/khlebOpen", 8);
			KLBG C 1 offset(0, 38);
			KLBG C 4 offset(0, 36) {
				A_MuzzleClimb(-frandom(1.2, 2.4), frandom(1.2, 2.4));
				if (invoker.weaponStatus[KHLEBS_CHAMBER] < 1) {
					setWeaponState("unloadtube");
				} else {
					A_StartSound("weapons/khlebRackBak", 8, CHANF_OVERLAP);
				}
			}
			KLBG D 8 offset(0, 34) {
				A_MuzzleClimb(-frandom(1.2, 2.4), frandom(1.2, 2.4));

				int chm = invoker.weaponStatus[KHLEBS_CHAMBER];
				invoker.weaponStatus[KHLEBS_CHAMBER] = 0;

				if (chm > 2) {
					A_StartSound("weapons/khlebReload",8);

					if (A_JumpIfInventory(chm == 4 ? "HD4GSAmmo" : "HD4GBAmmo", 0, "null")) {

						// FIXME: use A_EjectCasing() instead
						A_SpawnItemEx(
							chm == 4 ? "HDFumbling4GS" : "HDFumbling4GB",
							cos(pitch) * 8, 0, height - 7 - sin(pitch) * 8,
							vel.x + cos(pitch) * cos(angle - random(86, 90)) * 5,
							vel.y + cos(pitch) * sin(angle - random(86, 90)) * 5,
							vel.z + sin(pitch) * random(4, 6),
							0,
							SXF_ABSOLUTEMOMENTUM|SXF_NOCHECKPOSITION|SXF_TRANSFERPITCH
						);
					} else {
						HDF.Give(self, chm == 4 ? "HD4GSAmmo" : "HD4GBAmmo", 1);
						A_StartSound("weapons/pocket", 9);
						A_SetTics(5);
					}
				} else if (chm > 0) {

					// FIXME: use A_EjectCasing() instead
					A_SpawnItemEx(
						chm == 2 ? "HDSpent4GS" : "HDSpent4GBb",
						cos(pitch)*8, 0, height - 7 - sin(pitch) * 8,
						vel.x + cos(pitch) * cos(angle - random(86, 90)) * 5,
						vel.y + cos(pitch) * sin(angle - random(86, 90)) * 5,
						vel.z + sin(pitch) * random(4, 6),
						0,
						SXF_ABSOLUTEMOMENTUM|SXF_NOCHECKPOSITION|SXF_TRANSFERPITCH
					);
				}
			}
			KLBG C 0 A_StartSound("weapons/khlebRackFwd", 8);
			KLBG C 0 A_JumpIf(!pressingunload(), "reloadend");
			KLBG C 4 offset(0, 40);
		unloadtube:
			KLBG C 6 offset(0, 40) EmptyHand(careful: true);
		unloadloop:
			KLBG C 8 offset(1, 41) {
				if (invoker.weaponStatus[KHLEBS_TB1] < 1) {
					setWeaponState("reloadend");
				} else if (invoker.handshells >= 3) {
					setWeaponState("unloadloopend");
				} else {
					for ( int i = KHLEBS_TB1; i <= KHLEBS_TB3; i--) {
					// for ( int i = KHLEBS_TB1; i <= KHLEBS_TB4; i--) {
						if (invoker.weaponStatus[i] < 1) continue;

						if (invoker.weaponStatus[i] == 4) invoker.weaponStatus[0] |= KHLEBF_SLUG;

						invoker.weaponStatus[i] = 0;
						invoker.handshells = 1;
						A_PushKhlebTube();

						break;
					}
				}
			}
			KLBG C 4 offset(0, 40) {
				A_StartSound("weapons/khlebReload", 8);
				EmptyHand(careful: true);
				invoker.weaponStatus[0] &= ~KHLEBF_SLUG;
			}
			loop;
		unloadloopend:
			KLBG C 6 offset(1, 41);
			KLBG C 3 offset(1, 42) {
				A_StartSound("weapons/pocket", 9);
				A_SetTics(8);
			}
			KLBG C 6 {
				invoker.weaponStatus[0] &= ~KHLEBF_SLUG;
				A_Jumpif(!pressingunload(),"reloadend");
			}
			goto unloadloop;
		spawn:
			KLEB A -1 nodelay;
	}
	override void InitializeWepStats(bool idfa) {
		if (weaponStatus[0]&KHLEBF_SLUGLOADOUT) {
			weaponStatus[KHLEBS_CHAMBER] = 4;
			weaponStatus[KHLEBS_TB1] = 4;
			weaponStatus[KHLEBS_TB2] = 4;
			weaponStatus[KHLEBS_TB3] = 4;
			// weaponStatus[KHLEBS_TB4] = 4;
		} else {
			weaponStatus[KHLEBS_CHAMBER] = 3;
			weaponStatus[KHLEBS_TB1] = 3;
			weaponStatus[KHLEBS_TB2] = 3;
			weaponStatus[KHLEBS_TB3] = 3;
			// weaponStatus[KHLEBS_TB4] = 3;
		}

		handshells = 0;
	}
	override void loadoutconfigure(string input) {

		// Start with Slugs
		int shell = min(getloadoutvar(input, "slugs", 1), 1);
		if (shell >= 0) {
			weaponstatus[0] |= KHLEBF_SLUGLOADOUT;
			weaponstatus[KHLEBS_CHAMBER] = 4;
			weaponstatus[KHLEBS_TB1] = 4;
			weaponstatus[KHLEBS_TB2] = 4;
			weaponstatus[KHLEBS_TB3] = 4;
			// weaponstatus[KHLEBS_TB4] = 4;
		}
	}
}

enum khlebstatus {
	KHLEBS_TB1         = 1,     // mouth of tube
	KHLEBS_TB2         = 2,
	KHLEBS_TB3         = 3,
	// KHLEBS_TB4         = 4,
	KHLEBS_CHAMBER     = 5,    // 0 empty, 1 spent shl, 2 spent slg, 3 shell, 4 slug
	KHLEBS_HAND        = 6,

	KHLEBF_SLUG        = 1,
	KHLEBF_UNLOADONLY  = 2,
	KHLEBF_SLUGLOADOUT = 4,    // Refreshes with slugs at the range ammobox
	KHLEBF_ALTHOLDING  = 8,
	KHLEBF_HOLDING     = 16
};

class KhlebRandom : IdleDummy {
	states {
		spawn:
		TNT1 A 0 nodelay {
			let ggg = RIKhleb(spawn("RIKhleb", pos, ALLOW_REPLACE));

			if (!ggg) return;

			HDF.TransferSpecials(self, ggg, HDF.TS_ALL);

			// TODO: Spawn Slugs/Shells randomly?
		}
	}
}
