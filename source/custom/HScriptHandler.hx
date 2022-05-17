package custom;

import openfl.utils.Assets;
import hscript.Parser;
import hscript.Expr;
import hscript.Interp;

/**
    Handles hscript shit for u lmfao
**/
class HScriptHandler
{
    var script:String;

    var parser:Parser = new Parser();
    var program:Expr;
    var interp:Interp = new Interp();

    var other_scripts:Array<HScriptHandler> = [];

    public function new(hscript_path: String)
    {
        // load text
        program = parser.parseString(Assets.getText(hscript_path));

        // parser settings
        parser.allowJSON = true;
        parser.allowTypes = true;
        parser.allowMetadata = true;

        // global class shit

        // haxeflixel classes
        interp.variables.set("FlxG", flixel.FlxG);
        interp.variables.set("Polymod", polymod.Polymod);
        interp.variables.set("Assets", openfl.utils.Assets);
        interp.variables.set("LimeAssets", lime.utils.Assets);
        interp.variables.set("FlxSprite", flixel.FlxSprite);
        interp.variables.set("Math", Math);
        interp.variables.set("Std", Std);

        // game classes
        interp.variables.set("PlayState", PlayState);
        interp.variables.set("Conductor", Conductor);
        interp.variables.set("Paths", Paths);
        interp.variables.set("CoolUtil", CoolUtil);

        // function shits
        interp.variables.set("trace", haxe.Log.trace);

        interp.variables.set("loadScript", function(script_path:String) {
            var new_script = new HScriptHandler(script_path);
            new_script.start();
            new_script.callFunction("createPost");

            other_scripts.push(new_script);
        });

        interp.variables.set("otherScripts", other_scripts);

        // playstate local shit
        interp.variables.set("bf", PlayState.instance.boyfriend);
        interp.variables.set("gf", PlayState.instance.gf);
        interp.variables.set("dad", PlayState.instance.dad);

        interp.variables.set("removeStage", function() {
            PlayState.instance.remove(PlayState.instance.bg);
            PlayState.instance.remove(PlayState.instance.stageFront);
            PlayState.instance.remove(PlayState.instance.stageCurtains);
        });

        interp.execute(program);
    }

    public function start()
    {
        callFunction("create");
    }

    public function update(elapsed:Float)
    {
        callFunction("update", [elapsed]);
    }

    public function callFunction(func:String, ?args:Array<Dynamic>)
    {
        if(interp.variables.exists(func))
        {
            var real_func = interp.variables.get(func);

            try {
                if(args == null)
                    real_func();
                else
                    Reflect.callMethod(null, real_func, args);
            } catch(e) {
                trace(e);
            }
        }

        for(other_script in other_scripts)
        {
            other_script.callFunction(func, args);
        }
    }
}