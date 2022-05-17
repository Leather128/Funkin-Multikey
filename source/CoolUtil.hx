package;

import flixel.FlxG;
import lime.utils.Assets;

using StringTools;

class CoolUtil
{
	public static var difficultyArray:Array<String> = ['EASY', "NORMAL", "HARD"];

	public static function difficultyString():String
	{
		return difficultyArray[PlayState.storyDifficulty];
	}

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}

	public static function camLerpShit(ratio:Float)
	{
		return FlxG.elapsed / (1 / 60) * ratio;
	}

	public static function coolLerp(a:Float, b:Float, ratio:Float)
	{
		return a + camLerpShit(ratio) * (b - a);
	}

	// stolen from psych lmao cuz i'm lazy
	public static function dominantColor(sprite:flixel.FlxSprite):Int
	{
		var countByColor:Map<Int, Int> = [];

		for(col in 0...sprite.frameWidth)
		{
			for(row in 0...sprite.frameHeight)
			{
				var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);

				if(colorOfThisPixel != 0){
					if(countByColor.exists(colorOfThisPixel))
						countByColor[colorOfThisPixel] =  countByColor[colorOfThisPixel] + 1;
					else if(countByColor[colorOfThisPixel] != 13520687 - (2*13520687))
						countByColor[colorOfThisPixel] = 1;
				}
			}
		}

		var maxCount = 0;
		var maxKey:Int = 0; // after the loop this will store the max color

		countByColor[flixel.util.FlxColor.BLACK] = 0;

		for(key in countByColor.keys())
		{
			if(countByColor[key] >= maxCount)
			{
				maxCount = countByColor[key];
				maxKey = key;
			}
		}

		return maxKey;
	}

}
