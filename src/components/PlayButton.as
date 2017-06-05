package components {
import starling.display.Button;
import starling.display.Sprite;
import starling.events.Event;

public class PlayButton extends Sprite {
    public function PlayButton() {
        super();
        this.addEventListener(Event.ADDED_TO_STAGE, this._onAddedToStage)
    }

    private var _button:Button;

    private function _renderBall():void {
        this._button = new Button(Assets.getAtlas().getTexture('ball'));
        this.addChild(this._button);
        this._button.width = State.stage.width / 10;
        this._button.height = State.stage.width / 10;
        this.x = State.stage.width / 2 - this._button.width / 2;
        this.y = State.stage.height / 2 - this._button.height / 2;
    }

    private function _onAddedToStage(event:Event):void {
        this.removeEventListener(Event.ADDED_TO_STAGE, this._onAddedToStage);
        this._renderBall();
    }

}
}
