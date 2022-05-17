package;

class ManiaBullshit
{
    // mania shit
    public static var keyCounts:Array<Int> = [4, 6, 7, 9];

    public static var noteSizes:Array<Float> = [0.7, 0.6, 0.55, 0.46];

    public static var noteOffsets:Array<Float> = [0, 3, 5, 7];

    public static var strumOffsets:Array<Float> = [0, 5, 10, -20];

    public static var anims:Array<Array<String>> = [
        ["left", "down", "up", "right"],
        ["left", "up", "right", "left2", "down", "right2"],
        ["left", "up", "right", "square", "left2", "down", "right2"],
        ["left", "down", "up", "right", "square", "left2", "down2", "up2", "right2"]
    ];

    public static var static_anims:Array<Array<String>> = [
        ["left", "down", "up", "right"],
        ["left", "up", "right", "left", "down", "right"],
        ["left", "up", "right", "square", "left", "down", "right"],
        ["left", "down", "up", "right", "square", "left", "down", "up", "right"]
    ];

    public static var singAnims:Map<String, String> = [
        "left" => "left",
        "down" => "down",
        "up" => "up",
        "right" => "right",
        "square" => "up", // square
        "left2" => "left",
        "down2" => "down",
        "up2" => "up",
        "right2" => "right"
    ];
}