version "4.14"

#Include "zscript/Players.txt"
#Include "zscript/Inventorys.txt"
#Include "zscript/ONaF1Enemies.txt"
#Include "zscript/ONaF2Enemies.txt"
#Include "zscript/Weapons.txt"
#Include "zscript/EventHandlers.txt"

class SwitchOutlet : Actor
{
	Default
	{
		Radius 15;
		Height 5;
		Scale 1.0;
		-SOLID;
		+NOGRAVITY;
	}
	
	States
	{
	Spawn:
		CYBI A 1;
	On:
		#### # 2 A_PlaySound("CameraOff", 0, 1.5);
		CYBI A 1;
		Wait;
	Off:
		#### # 2 A_PlaySound("CameraOff", 0, 1.5);
		CYBI B 1;
		Wait;
	}
}

class Cactus : Actor
{
	override void Activate(Actor activator) 
	{ 
		A_PlaySound("Cacto",0,3.5);
		SetStateLabel("ImACactus");
	}
	Default
	{
		Radius 15;
		Height 5;
		Scale 1.0;
		Activation THINGSPEC_Switch;
		-SOLID
		+NOGRAVITY
		+USESPECIAL
	}
	
	States
	{
	Spawn:
		CYBI A 1;
		Wait;
	ImACactus:
		CYBI ABCDEFGHIJKLMNO 1;
		Goto Spawn;
	}
}