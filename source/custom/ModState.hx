package custom;

import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import MainMenuState.MainMenuItem;
import flixel.FlxG;

using StringTools;

class ModState extends MusicBeatState
{
    var selected_mods:Array<String> = [];
    var total_mods:Array<String> = [];

    var mod_alphabets:FlxTypedGroup<Alphabet> = new FlxTypedGroup<Alphabet>();

    var selected:Int = 0;

    public function new()
    {
        super();
        
        var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

        selected_mods = FlxG.save.data.mods;

        #if sys
        for(dir in sys.FileSystem.readDirectory(Sys.getCwd() + "mods"))
        {
            if(sys.FileSystem.exists(Sys.getCwd() + "mods/" + dir + "/_polymod_meta.json"))
                total_mods.push(dir);
        }
        #end

        add(mod_alphabets);

        for(mod in total_mods)
        {
            var new_alpha = new Alphabet(0, 0, mod, true);
            new_alpha.isMenuItem = true;
            new_alpha.targetY = total_mods.indexOf(mod);

            if(!selected_mods.contains(mod))
                new_alpha.alpha = 0.6;

            mod_alphabets.add(new_alpha);
        }

        for(mod in selected_mods)
        {
            if(!total_mods.contains(mod))
            {
                var new_alpha = new Alphabet(0, 0, "(BROKEN)-" + mod, true);
                new_alpha.isMenuItem = true;
                new_alpha.targetY = total_mods.length + selected_mods.indexOf(mod);
                new_alpha.color = FlxColor.RED;

                mod_alphabets.add(new_alpha);
            }
        }

        changeItem(0);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if(controls.UI_UP_P)
            changeItem(-1);
        if(controls.UI_DOWN_P)
            changeItem(1);

        if(controls.BACK)
        {
            FlxG.switchState(new MainMenuState());

            #if sys
            FlxG.save.data.mods = selected_mods;
            FlxG.save.flush();

            TitleState.reloadMods();
            #end
        }

        if(controls.ACCEPT)
        {
            if(selected_mods.contains(total_mods[selected]))
                selected_mods.remove(total_mods[selected]);
            else
                selected_mods.push(total_mods[selected]);

            updateAlphabets();
        }

        if(controls.RESET)
        {
            selected_mods = [];
            updateAlphabets();

            FlxG.save.data.mods = selected_mods;
            FlxG.save.flush();

            for(alpha in mod_alphabets.members)
            {
                if(alpha.color == FlxColor.RED) // removes broken shit anyways, so u good :D
                    mod_alphabets.remove(alpha);
            }
        }
    }

    function changeItem(amount:Int = 0)
    {
        selected += amount;

        if(selected < 0)
            selected = mod_alphabets.members.length - 1;
        if(selected > mod_alphabets.members.length - 1)
            selected = 0;

        updateAlphabets();

        FlxG.sound.play(Paths.sound("scrollMenu"));
    }

    function updateAlphabets()
    {
        for(i in 0...mod_alphabets.members.length)
        {
            var text = mod_alphabets.members[i];

            text.targetY = i - selected;

            if(selected_mods.contains(total_mods[i]))
                text.alpha = 1;
            else
                text.alpha = 0.6;
        }
    }
}