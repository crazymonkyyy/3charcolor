int dis(int a,int b){
	if(a>b){return a-b;}
	return b-a;
}
struct localcolor{
	int r;
	int g;
	int b;
	int distence(localcolor a){
		int sq(int i){return i*i;}
		import std.math;import std.conv;
		return sqrt(sq(r-a.r)+sq(g-a.g)+sq(b-a.b)+float(0)).to!int;
	}
	import raylib;
	auto get(){
		return Color(cast(ubyte)r,cast(ubyte)g,cast(ubyte)b,255);
	}
	alias get this;
}
localcolor[2] nearest(localcolor[] niehbors,localcolor target){
	auto f(localcolor a){
		struct pair{
			int _1; alias _1 this;
			localcolor _2;
		}
		return pair(a.distence(target),a);
	}
	import std.algorithm; import std.array;
	auto o=niehbors[].map!f.array.sort;
	return [o[0]._2,o[1]._2];
}
auto wieghts(localcolor target){
	import std.algorithm; import std.array;
	struct pair{
		localcolor c; alias c this;
		float w;
	}
	pair[4] o;
	enum hue=[
		localcolor(255,  0,  0),
		localcolor(255,255,  0),
		localcolor(  0,255,  0),
		localcolor(  0,255,255),
		localcolor(  0,  0,255),
		localcolor(255,  0,255)];
	enum grey=[
		localcolor(  0,  0,  0),
		localcolor(100,100,100),
		localcolor(200,200,200),
		localcolor(255,255,255)];
	auto hueout=hue.nearest(target);
	o[0]=hueout[0];
	o[1]=hueout[1];
	auto greyout=grey.nearest(target);
	o[2]=greyout[0];
	o[3]=greyout[1];
	int[4] d;
	float totald=0;
	foreach(i,e;o[]){
		d[i]=e.distence(target);
		totald+=d[i];
	}
	foreach(i,ref e;o[]){
		e.w=d[i]/totald;}
	o[].sort!((a,b)=>a.w<b.w);
	float left=1;
	foreach(ref e;o[0..3]){
		auto percent=left-(left*e.w);
		//auto percent=left-(e.w*e.w);
		left-=percent;
		e.w=percent;
	}
	o[3].w=left;
	return o;
}
unittest{
	import std.stdio;import std.algorithm; import std.array;
	localcolor(218,218,48).wieghts.writeln;
	localcolor(255,255,0).wieghts.writeln;
}
localcolor hextolocalcolor(string s){//lazy copy paste
	import std.range;
	localcolor output;
	//I wish c foreach abuse worked in d
	//for(int i=0,int j=0,bool b=true;i<6;i++,j+=b,b!=b)
	enum zippy= zip(
		[16].cycle,
		["r","g","b"],
		iota(0,100));
	static foreach(digit,mix,i;zippy){ {
		int t;
		if(s[i]>='0' && s[i]<='9'){
			t=s[i]-'0';}
		if(s[i]>='a' && s[i]<='f'){
			t=s[i]-'a'+11;}
		if(s[i]>='A' && s[i]<='F'){
			t=s[i]-'A'+11;}
		t*=digit;
		import std.algorithm;
		mixin("output."~mix)+=min(t,255);
	} }
	return output;
}
unittest{
	import std.stdio;
	hextolocalcolor("cc3").writeln;
}