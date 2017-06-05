package components {
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;

public class Player extends Sprite {

    public function Player() {
        super();
        this.addEventListener(Event.ADDED_TO_STAGE, this._onAddedToStage);
    }
    private var _player:Image;
    private var _playerSprite:Sprite;

    private function _renderPlayer():void {
        this._player = new Image(Assets.getAtlas().getTexture('player'));
        this._player.width = State.stage.width / 10 * 3;
        this._player.height = 50;
        this._playerSprite = new Sprite();
        this._playerSprite.addChild(this._player);
        this.addChild(_playerSprite);
    }

    private function _onAddedToStage(event:Event):void {
        this.removeEventListener(Event.ADDED_TO_STAGE, this._onAddedToStage);
        this._renderPlayer();
    }

}
}
