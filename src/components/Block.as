package components {
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;

public class Block extends Sprite {

    public static var SIZE:Number = State.stage.width / State.block.colCount;

    public function Block() {
        super();
        this.addEventListener(Event.ADDED_TO_STAGE, this._onAddedToStage)
    }

    private var _blockSprite:Sprite;

    private function _renderBall():void {
        var texture:Texture = Assets.getAtlas().getTexture('block');
        var image:Image = new Image(texture);
        image.width = Block.SIZE;
        image.height = Block.SIZE;
        this._blockSprite = new Sprite();
        this._blockSprite.addChild(image);
        this.addChild(this._blockSprite);
    }

    private function _onAddedToStage(event:Event):void {
        this.removeEventListener(Event.ADDED_TO_STAGE, this._onAddedToStage);
        this._renderBall();
    }

}
}
