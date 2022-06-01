package;

import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import openfl.system.System;
import haxe.Timer;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
class FPS extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;

	public var currentTime:Float;
	public var times:Array<Float>;

	public var lastKeyPressed:Int = -1;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("_sans", 12, color);
		text = "FPS: ";

		width = 1280;
		height = 720;

		currentTime = 0;
		times = [];
	}

	// Event Handlers
	private override function __enterFrame(deltaTime:Float):Void
	{
		currentTime += deltaTime;

		times.push(currentTime);

		while (currentTime > times[0] + 1000)
		{
			times.shift();
		}

		currentFPS = times.length;

		text = "FPS: " + currentFPS;

        if(ui.PreferencesMenu.developer_mode)
        {
			text += "\n";
            text += "Memory: " + Math.abs(Math.round(System.totalMemory / 1024 / 1024 * 100)/100) + " mb\n";
			text += "Delta Time: " + (deltaTime / 1000) + " (" + (1 / (deltaTime / 1000)) + " fps)" + "\n";
			text += "Current State: " + Type.getClassName(Type.getClass(FlxG.state)) + "\n";
			text += "Max Texture Size: " + FlxG.bitmap.maxTextureSize + "\n";
			text += "Loaded Sound Count: " + FlxG.sound.list.length + "\n";

			var keyJustPressed = FlxG.keys.firstJustPressed();

			if(lastKeyPressed != keyJustPressed && keyJustPressed != -1)
				lastKeyPressed = keyJustPressed;

			text += "Last Pressed Key: " + (lastKeyPressed != -1 ? InputFormatter.format(lastKeyPressed, Keys) : "null") + "\n";
        }
	}
}
