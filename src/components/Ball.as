package components {
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;

public class Ball extends Sprite {
    public function Ball() {
        super();
        this.addEventListener(Event.ADDED_TO_STAGE, this._onAddedToStage)
    }

    private var _ball:Image;

    public function move(fHorizontal:Number = 1, fVertical:Number = 1):void {
        var newX:Number = this.x + State.ball.speed * fHorizontal;
        var newY:Number = this.y + State.ball.speed * fVertical;
        if ((newY + this.height ) >= State.stage.height) {
            State.game.isPlaying = false;
            State.game.isWin = false;
            this.removeFromParent(true);
        } else {
            State.game.isPlaying = true;
            State.game.isWin = false;

            this.x = newX;
            this.y = newY;
        }
    }

    private function _renderBall():void {
        this._ball = new Image(Assets.getAtlas().getTexture('ball'));
        this.addChild(this._ball);
        this._ball.width = State.stage.width / 10;
        this._ball.height = State.stage.width / 10;
        this.x = State.ball.point.x - this._ball.width / 2 - 1;
        this.y = State.ball.point.y - this._ball.height / 2 - 10;
    }

    private function _onAddedToStage(event:Event):void {
        this.removeEventListener(Event.ADDED_TO_STAGE, this._onAddedToStage);
        this._renderBall();
    }

}
}
