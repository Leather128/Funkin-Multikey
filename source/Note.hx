package;

import ui.PreferencesMenu;
import shaderslmfao.ColorSwap;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var willMiss:Bool = false;
	public var altNote:Bool = false;
	public var prevNote:Note;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	var colorSwap:ColorSwap;
	
	public static var swagWidth:Float = 160 * 0.7;
	public static var arrowColors = [1, 1, 1, 1];
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	public var raw_note:Array<Dynamic>;

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false)
	{
		super();

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		x += 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		this.strumTime = strumTime;

		this.noteData = noteData;

		switch (PlayState.curStage)
		{
			case 'school' | 'schoolEvil':
				if (isSustainNote)
					loadGraphic(Paths.image('weeb/pixelUI/arrowEnds'), true, 7, 6);
				else
					loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);

				switch(noteData % 4)
				{
					case 0:
						animation.add('normal', [4]);
						animation.add('held', [0]);
						animation.add('end', [4]);
					case 1:
						animation.add('normal', [5]);
						animation.add('held', [1]);
						animation.add('end', [5]);
					case 2:
						animation.add('normal', [6]);
						animation.add('held', [2]);
						animation.add('end', [6]);
					case 3:
						animation.add('normal', [7]);
						animation.add('held', [3]);
						animation.add('end', [7]);
				}

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
			default:
				frames = Paths.getSparrowAtlas('default');

				animation.addByPrefix('normal', ManiaBullshit.anims[PlayState.SONG.mania][noteData] + '0');
				animation.addByPrefix('held', ManiaBullshit.anims[PlayState.SONG.mania][noteData] + ' hold0');
				animation.addByPrefix('end', ManiaBullshit.anims[PlayState.SONG.mania][noteData] + ' hold end0');

				if(!isSustainNote)
					setGraphicSize(Std.int(width * ManiaBullshit.noteSizes[PlayState.SONG.mania]));
				else
					setGraphicSize(Std.int(width * ManiaBullshit.noteSizes[PlayState.SONG.mania]), Std.int(height * ManiaBullshit.noteSizes[0]));
				
				updateHitbox();
				antialiasing = true;
		}

		colorSwap = new ColorSwap();
		shader = colorSwap.shader;
		updateColors();

		animation.play('normal');

		// trace(prevNote);

		if (isSustainNote && prevNote != null)
		{
			alpha = 0.6;

			if (PreferencesMenu.getPref('downscroll'))
			{
				angle = 180;
			}

			x += width / 2;

			animation.play('end');

			updateHitbox();

			x -= width / 2;

			if (PlayState.curStage.startsWith('school'))
				x += 30;

			if (prevNote.isSustainNote)
			{
				prevNote.animation.play('held');

				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}
	}

	function updateColors()
	{
		colorSwap.update(arrowColors[noteData]);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (mustPress)
		{
			if (willMiss && !wasGoodHit)
			{
				tooLate = true;
				canBeHit = false;
			}
			else
			{
				if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset)
				{
					if (strumTime < Conductor.songPosition + 0.5 * Conductor.safeZoneOffset)
						canBeHit = true;
				}
				else
				{
					willMiss = true;
					canBeHit = true;
				}
			}
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}
