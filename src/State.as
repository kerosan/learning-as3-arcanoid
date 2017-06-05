package {
import flash.geom.Point;

public class State {
    public static var ball:Object = {
        point: new Point(0, 0),
        speed: 5,
        fx: 1,
        fy: -1
    };
    public static var game:Object = {
        isPlaying: false,
        isWin: false,
        score: 0
    };
    public static var stage:Object = {
        width: 0,
        height: 0

    };
    public static var block:Object = {
        rowCount: 2,
        colCount: 10
    }
}
}
