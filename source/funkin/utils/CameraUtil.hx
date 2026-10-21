package funkin.utils;

import flixel.system.FlxAssets.FlxShader;

import openfl.filters.ShaderFilter;

@:access(flixel.FlxCamera)
@:access(flixel.system.frontEnds.CameraFrontEnd)
@:nullSafety
class CameraUtil
{
	/**
		returns the last camera in FlxG.cameras.list
		equivalent to `FlxG.cameras.list[FlxG.cameras.list.length - 1]`
	**/
	public static var lastCamera(get, never):FlxCamera;
	
	static function get_lastCamera():FlxCamera return FlxG.cameras.list[FlxG.cameras.list.length - 1];
	
	/**
		convenient function to making a camera and adding it to the stack as well
		* @param	add	whether it should be automatically added to the stack
		* @return	The new Camera
	**/
	public static inline function quickCreateCam(add:Bool = true):FlxCamera
	{
		var cam = new FunkinCamera();
		cam.bgColor = 0x0;
		
		if (add) FlxG.cameras.add(cam, false);
		
		return cam;
	}
	
	public static function camPosLerp(cam:flixel.FlxCamera, target:flixel.FlxObject, lerp:Float = 1)
	{
		cam.scroll.x = MathUtil.decayLerp(cam.scroll.x, target.x - FlxG.width / 2, 4, lerp);
		cam.scroll.y = MathUtil.decayLerp(cam.scroll.y, target.y - FlxG.height / 2, 4, lerp);
	}
}
