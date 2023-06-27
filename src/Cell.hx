
import pixi.core.graphics.Graphics;
import pixi.core.Application;
import pixi.plugins.spine.Spine;
import pixi.core.math.Point;
import SignType;

class Cell {
    public var sign = SignType.None;
    public var onClick: (cell: Cell) -> Void;
    public var size:Int = 200;

    private var app: Application;
    private var spine: Spine;
    private var graphic: Graphics;
    private var position: Point;
    
    public function new(app: Application, position: Point) {
        this.app = app;
        this.position = new Point(position.x, position.y);

		graphic = new Graphics();
		graphic.beginFill(0x1FE1CC);
		graphic.drawRect(position.x, position.y, size, size);
		graphic.endFill();
        graphic.interactive = true;
        graphic.on("click", OnClick);
        graphic.alpha = 0;

        app.stage.addChild(graphic);
    }

    public function SetSign(sign: SignType, spineData) {
        this.sign = sign;
        spine = new Spine(spineData);
        spine.position.set(position.x + size / 2, position.y + size / 2);
        app.stage.addChild(spine);
        spine.state.setAnimation(0, "draw", false);
    }

    public function AnimateWin() {
        graphic.alpha = 1;
        spine.state.setAnimation(0, "win", true);
    }

    public function Clear() {
        sign = SignType.None;
        graphic.alpha = 0;
        app.stage.removeChild(spine);
    }

    private function OnClick() {
        if (sign == SignType.None) {
            onClick(this);
        }
    }
}