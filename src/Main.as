package {

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.display3D.Context3DProfile;
import flash.display3D.Context3DRenderMode;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.system.Capabilities;

import starling.core.Starling;

[SWF(width="480", height="800", frameRate="60", backgroundColor="#ffffff")]
public class Main extends Sprite {

    public function Main() {
        if (this.stage) {
            this.startup();
        } else {
            this.addEventListener(Event.ADDED_TO_STAGE, this.startup);
        }
    }

    private var _starling:Starling;

    private function startup(event:Event = null):void {
        if (event) {
            this.removeEventListener(Event.ADDED_TO_STAGE, this.startup);
        }
        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;
        var screenWidth:int;
        var screenHeight:int;
        if (Capabilities.playerType === 'Desktop ') {
            screenWidth = stage.fullScreenWidth;
            screenHeight = stage.fullScreenHeight;
        } else {
            screenWidth = stage.stageWidth;
            screenHeight = stage.stageHeight;
        }


        State.stage.width = screenWidth;
        State.stage.height = screenHeight;

        if (screenHeight >= 1000) {
            Context3DProfile.BASELINE_EXTENDED;
            _starling = new Starling(Game, stage, new Rectangle(0, 0, State.stage.width, State.stage.height), null, Context3DRenderMode.AUTO, Context3DProfile.BASELINE_EXTENDED);
        }
        else {
            Context3DProfile.BASELINE_CONSTRAINED;
            _starling = new Starling(Game, stage, new Rectangle(0, 0, State.stage.width, State.stage.height));
        }

        var viewPortRectangle:Rectangle = new Rectangle();
        viewPortRectangle.width = stage.stageWidth;
        viewPortRectangle.height = stage.stageHeight;
        Starling.current.viewPort = viewPortRectangle;
        stage.stageWidth = screenWidth;
        stage.stageHeight = screenHeight;
        Starling.current.viewPort.width = screenWidth;
        Starling.current.viewPort.height = screenHeight;

        _starling.stage3D.addEventListener(Event.CONTEXT3D_CREATE, function (e:Event):void {
            _starling.simulateMultitouch = true;
            _starling.showStats = true;
            _starling.antiAliasing = 1;
            _starling.start();
        });
    }

}
}
