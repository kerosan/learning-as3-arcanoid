package components {
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.filters.BlurFilter;
import starling.textures.Texture;

public class Background extends Sprite {

    public function Background() {
        super();
        this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage)
    }

    private function onAddedToStage(event:Event):void {
        this.removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        var bg:Sprite = new Sprite();
        var bgTexture:Texture = Assets.getAtlas().getTexture('bg');
        var image:Image = new Image(bgTexture);
        bg.addChild(image);
        image.width = State.stage.width;
        image.height = State.stage.height;
        bg.filter = new BlurFilter(3, 3);
        this.addChild(bg);
    }

}
}
