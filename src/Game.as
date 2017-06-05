package {
import components.Background;
import components.Ball;
import components.Block;
import components.Dashboard;
import components.PlayButton;
import components.Player;

import flash.geom.Point;

import starling.display.Button;
import starling.display.DisplayObject;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.filters.GlowFilter;

public class Game extends Sprite {
    public function Game() {
        super();
        this.addEventListener(Event.ADDED_TO_STAGE, this._onAddedToStage)
    }

    private var _button:PlayButton;
    private var _dashboard:Dashboard;
    private var _player:Player;
    private var _ball:Ball;
    private var _blockCollection:Vector.<Block>;

    private function _renderBackground():void {
        this.addChild(new Background());
    }

    private function _renderBall():void {
        this._ball = new Ball();
        this.addChild(this._ball);
    }

    private function _renderBlock(block:Block, key:Number, self:*):void {
        this.addChild(block);
    }

    private function _renderDashboard():void {
        this._dashboard = new Dashboard();
        this.addChild(this._dashboard);
    }

    private function _renderPlayer():void {
        this._player = new Player();
        this.addChild(this._player);

        this._player.pivotX = this._player.width / 2;
        this._player.pivotY = this._player.height;
        this._player.x = stage.stageWidth / 2;
        this._player.y = stage.stageHeight;
    }

    private function _initBlockCollection():Vector.<Block> {
        this._blockCollection = new Vector.<Block>();
        for (var i:Number = 0; i < State.block.rowCount; i++) {
            for (var j:Number = 0; j < State.block.colCount; j++) {
                var block:Block = new Block();
                block.x = j * Block.SIZE;
                block.y = i * Block.SIZE + this._dashboard.height;
                block.width = Block.SIZE;
                block.height = Block.SIZE;
                this._blockCollection.push(block);
            }
        }
        return this._blockCollection;
    }

    private function _hitTestOnBall():Block {
        var hitObject:Object = {};
        hitObject.top = this.hitTest(new Point(this._ball.x + this._ball.width / 2, this._ball.y));
        hitObject.topRight = this.hitTest(new Point(this._ball.x + this._ball.width, this._ball.y));
        hitObject.right = this.hitTest(new Point(this._ball.x + this._ball.width, this._ball.y + this._ball.height / 2));
        hitObject.bottomRight = this.hitTest(new Point(this._ball.x + this._ball.width, this._ball.y + this._ball.height));
        hitObject.bottom = this.hitTest(new Point(this._ball.x + this._ball.width / 2, this._ball.y + this._ball.height));
        hitObject.topLeft = this.hitTest(new Point(this._ball.x, this._ball.y));
        hitObject.left = this.hitTest(new Point(this._ball.x, this._ball.y + this._ball.height / 2));
        hitObject.bottomLeft = this.hitTest(new Point(this._ball.x, this._ball.y + this._ball.height));

        if (hitObject.top === hitObject.right === hitObject.bottom === hitObject.left) {
            return null;
        }
        for (var side:String in hitObject) {
            if (hitObject[side]) {
                var detected:* = (hitObject[side] as DisplayObject).parent.parent;
                if (detected) {
                    if (this._blockCollection.indexOf(detected as Block) !== -1) {
                        switch (side) {
                            case 'top':
                            case 'bottom':
                            case 'topLeft':
                            case 'topRight':
                                State.ball.fy *= -1; //todo change direction
                                break;
                            case 'right':
                            case 'left':
                            case 'bottomLeft':
                            case 'bottomRight':
                                State.ball.fx *= -1; //todo change direction
                                break;
                        }
                        return detected;
                    }
                    if (detected as Player && side === 'bottom') {
                        State.ball.fy *= -1; //todo change direction
                    }
                }
            }
        }

        return null;
    }

    private function _renderStage():void {
        this._initBlockCollection().map(this._renderBlock);
        this._renderPlayer();

        State.ball.point = new Point(this._player.x, this._player.y - this._player.height - 20);
        this._renderBall();
        this._dashboard.resetScore();
    }

    private function _clearStage():void {
        this._ball.removeFromParent(true);
        this._player.removeFromParent(true);
        this._blockCollection.map(function (block:Block, key:int, arr:Vector.<Block>):* {
            block.removeFromParent(true);
        });
    }

    private function _setGameBounds():void {
        if (this._ball.x <= 0) {
            this._ball.x = 0;
            State.ball.fx *= -1;
        }
        if (this._ball.x >= State.stage.width - this._ball.width / 2) {
            this._ball.x = State.stage.width - this._ball.width / 2;
            State.ball.fx *= -1;
        }
        if (this._ball.y <= 0) {
            this._ball.y = 0;
            State.ball.fy *= -1;
        }
        if (this._ball.y >= State.stage.height - this._ball.height / 2) {
            this._ball.y = State.stage.height - this._ball.height / 2;
            State.ball.fy *= -1;
        }
    }

    private function _gameEnd():void {
        if (State.game.isWin) {
            trace('Winner');
            this._button.filter = new GlowFilter(0x12FF12, 1, 5, 1);
        } else {
            trace('Looser');
            this._button.filter = new GlowFilter(0xFF1212, 1, 5, 1);
        }
        this._clearStage();
        this._button.visible = true;
        State.game.isPlaying = false;
        this.removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
    }

    private function _onAddedToStage(event:Event):void {
        this.removeEventListener(Event.ADDED_TO_STAGE, this._onAddedToStage);
        this.addEventListener(TouchEvent.TOUCH, this._onTouch);

        this._renderBackground();
        this._renderDashboard();

        this._button = new PlayButton();
        this.addChild(this._button);

    }

    private function _onTouch(event:TouchEvent):void {
        var touch:Touch = event.getTouch(stage);
        if (touch && touch.phase === TouchPhase.ENDED && event.target is Button) {
            this._button.visible = false;
            this._renderStage();
            State.game.isPlaying = true;
            State.game.isWin = false;
            if (!this.hasEventListener(Event.ENTER_FRAME)) {
                this.addEventListener(Event.ENTER_FRAME, _onEnterFrame);
            }
        } else if (touch && touch.phase === TouchPhase.MOVED && this._player) {
            var mouseX:Number = touch.getLocation(stage).x;
            var diapasonLeft:Number = this._player.width / 2;
            var diapasonRight:Number = stage.stageWidth - diapasonLeft;
            if (mouseX <= diapasonLeft) {
                mouseX = diapasonLeft;
            }
            if (mouseX >= diapasonRight) {
                mouseX = diapasonRight;
            }
            this._player.x = mouseX;

        }
    }

    private function _onEnterFrame(event:Event):void {
        if (State.game.isPlaying) {
            this._setGameBounds();
            var crashBlock:* = this._hitTestOnBall();

            if (crashBlock && crashBlock is Block) {
                crashBlock.removeFromParent(true);
                this._dashboard.addScore(1);
                if (State.game.score === State.block.rowCount * State.block.colCount) {
                    State.game.isWin = true;
                    State.game.isPlaying = false;
                    this._gameEnd();
                    return;
                }
            }
            this._ball.move(State.ball.fx, State.ball.fy);
        } else {
            this._gameEnd();
        }
    }
}
}