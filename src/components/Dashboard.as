package components {
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;

public class Dashboard extends Sprite {
    public static var TEXT_SCORE:String = 'Score:';

    public function Dashboard() {
        super();
        this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage)
    }

    private var _dashboard:Sprite = new Sprite();
    private var scoreTextField:TextField;


    public function resetScore():void {
        State.game.score = 0;
        scoreTextField.text = Dashboard.TEXT_SCORE + ' ' + State.game.score;
    }

    public function addScore(count:Number):void {
        State.game.score += count;
        scoreTextField.text = Dashboard.TEXT_SCORE + ' ' + State.game.score;
    }

    private function onAddedToStage(event:Event):void {
        this.removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        scoreTextField = new TextField(480, 40, Dashboard.TEXT_SCORE + ' ' + State.game.score);
        _dashboard.addChild(scoreTextField);
        this.addChild(_dashboard);
        _dashboard.width = State.stage.width;
        _dashboard.height = 40;
    }

}
}
