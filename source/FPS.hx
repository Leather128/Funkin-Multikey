package;

import openfl.system.System;
import openfl.text.TextFormat;
import openfl.text.TextField;

class FPS extends TextField
{
    var currentTime:Float = 0;
    public var times:Array<Float> = [];
    
    var max_mem:Int = 0;

    public function new(x:Float, y:Float, color:Int)
    {
        super();

		this.x = x;
		this.y = y;

		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("_sans", 12, color);
		text = "FPS: ";

        width = 1280;
        height = 720;
    }

    private override function __enterFrame(deltaTime:Float):Void
    {
        currentTime += deltaTime;
        times.push(currentTime);

        while(times[0] + 1000 < currentTime)
        {
            times.shift();
        }

        text = "FPS: " + times.length + "\n";

        if(LocalSettings.developer_mode && LocalSettings.extra_fps_info)
        {
            text += 'RAM Usage: ${CoolUtil.fastRound(System.totalMemory / 1048576, 2)} MB (${System.totalMemory} Bytes)\n';

            if(System.totalMemory > max_mem)
                max_mem = System.totalMemory;

            text += 'Max RAM Usage: ${CoolUtil.fastRound(max_mem / 1048576, 2)} MB (${max_mem} Bytes)\n';

            text += "Developer Mode: On\n";
            text += "Extra Score Info: " + LocalSettings.extra_score_info + "\n";
            text += "Extra FPS Info: " + LocalSettings.extra_fps_info + "\n";
            text += "Botplay: " + LocalSettings.botplay + "\n";
        }
    }
}