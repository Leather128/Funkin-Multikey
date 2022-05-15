package;

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
	public var prevNote:Note;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	public var noteScore:Float = 1;

	public static var swagWidth:Float = 160 * 0.7;

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false)
	{
		super();

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		x += 50 - ManiaBullshit.noteOffsets[PlayState.SONG.mania];
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		this.strumTime = strumTime;

		this.noteData = noteData;

		var daStage:String = PlayState.curStage;

		switch (daStage)
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
				frames = Paths.getSparrowAtlas('NOTE_assets');

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

		x += swagWidth * noteData;
		animation.play('normal');

		// trace(prevNote);

		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;
			alpha = 0.6;

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

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (mustPress)
		{
			// The * 0.5 is so that it's easier to hit them too late, instead of too early
			if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
				&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
				canBeHit = true;
			else
				canBeHit = false;

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit)
				tooLate = true;
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
