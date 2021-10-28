import raylib;
import colorswap;
import color_;

enum windowx=800;
enum windowy=600;


	

void main(){
	InitWindow(windowx, windowy, "Hello, Raylib-D!");
	SetWindowPosition(2000,0);
	SetTargetFPS(60);
	mixin makecolors!();
	loaddefualtcolors;
	color[localcolor] fixedpoints;
	alias ws=typeof(wieghts(localcolor()));
	alias hex=hextolocalcolor;
	localcolor parse(string s){
		ws ws_=wieghts(hex(s));
		float[3] f=0;
		foreach(wightedcolor;ws_){
		static foreach(i,c;["r","g","b"]){
			import std.stdio;
			//fixedpoints[hex("F00")].writeln;
			//hex("F00").writeln;
			//wightedcolor.writeln;
			//fixedpoints[wightedcolor].writeln;
			f[i]+=mixin("fixedpoints[wightedcolor]."~c~"*wightedcolor.w");
		}}
		localcolor o;
		static foreach(i,c;["r","g","b"]){
			import std.conv;
			mixin("o."~c)=f[i].to!int;
		}
		return o;
	}
	void loadfixedpoints(){
		fixedpoints[hex("F00")]=red;
		fixedpoints[hex("FF0")]=yellow;
		fixedpoints[hex("0F0")]=green;
		fixedpoints[hex("0FF")]=cyan;
		fixedpoints[hex("00F")]=blue;
		fixedpoints[hex("F0F")]=purple;
		fixedpoints[hex("000")]=background;
		fixedpoints[localcolor(100,100,100)]=brightbackground;
		fixedpoints[localcolor(200,200,200)]=selection;
		fixedpoints[hex("FFF")]=text;
	}
	loadfixedpoints;
	
	while (!WindowShouldClose()){
		BeginDrawing();
			ClearBackground(background);
			DrawText("Hello, World!", 10,10, 20, text);
			DrawRectangle(0,30,200,30,text);
			static foreach(i,mix;colornames){ {
				int j=(i+1)*30;
				color c=mixin(mix);
				DrawRectangle(0,j,25,25,c);
				DrawText(mix,30,j,20,c);
			} }
			if(IsKeyPressed(KeyboardKey.KEY_F11)){
				changecolors;
				loadfixedpoints;
			}
			
			
			enum hexstrings=['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'];
			foreach(x,a;hexstrings){
			foreach(i,b;hexstrings){
			foreach(j,c;hexstrings){
				import std.conv;
				DrawRectangle(((x%5)*100+230+i*5).to!int,((x/5)*100+j*5).to!int,5,5,parse([a]~b~c));
			}}}
			//DrawFPS(10,10);
		EndDrawing();
	}
	CloseWindow();
}