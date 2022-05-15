package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class OptionsSubState extends MusicBeatSubstate
{
	var textMenuItems:Array<String> = ['Extra Score Info', 'Extra FPS Info', 'Botplay', 'Reload Mods'];

	var selector:FlxSprite;
	var curSelected:Int = 0;

	var grpOptionsTexts:FlxTypedGroup<FlxText>;

	var reloadedText:FlxText;

	var timer:Float = 500.0;

	public function new()
	{
		super();

		grpOptionsTexts = new FlxTypedGroup<FlxText>();
		add(grpOptionsTexts);

		selector = new FlxSprite().makeGraphic(5, 5, FlxColor.RED);
		add(selector);

		for (i in 0...textMenuItems.length)
		{
			var optionText:FlxText = new FlxText(20, 20 + (i * 50), 0, textMenuItems[i], 32);
			optionText.ID = i;
			grpOptionsTexts.add(optionText);
		}

		changeSelection();

		reloadedText = new FlxText(20,0,0,"Mods Reloaded!", 32);
		reloadedText.y = 720 + reloadedText.height;
		add(reloadedText);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		timer += elapsed;

		if (controls.UP_P)
			changeSelection(-1);

		if (controls.DOWN_P)
			changeSelection(1);

		if (timer > 1)
			reloadedText.y = 720 - reloadedText.height - 25 + ((timer - 1) * 50);

		if (controls.ACCEPT)
		{
			switch (textMenuItems[curSelected])
			{
				case "Extra Score Info":
					LocalSettings.extra_score_info = !LocalSettings.extra_score_info;
				case "Extra FPS Info":
					LocalSettings.extra_fps_info = !LocalSettings.extra_fps_info;
				case "Botplay":
					LocalSettings.botplay = !LocalSettings.botplay;
				case "Reload Mods":
					TitleState.reloadMods();

					reloadedText.y = 720 - reloadedText.height - 25;
					timer = 0.0;
			}
		}

		if (controls.BACK)
			FlxG.switchState(new MainMenuState());
	}

	function changeSelection(amount:Int = 0)
	{
		curSelected += amount;

		FlxG.sound.play(Paths.sound("scrollMenu"));

		if (curSelected < 0)
			curSelected = textMenuItems.length - 1;

		if (curSelected >= textMenuItems.length)
			curSelected = 0;
		
		grpOptionsTexts.forEach(function(txt:FlxText)
		{
			txt.color = FlxColor.WHITE;

			if (txt.ID == curSelected)
				txt.color = FlxColor.YELLOW;
		});
	}
}
