import pixi.core.math.shapes.Rectangle;
import pixi.core.graphics.Graphics;
import pixi.core.math.Point;
import pixi.core.Application;

class Grid {
    private var size = 20;

    public function new(app: Application, rect: Rectangle) {

		var graphic = new Graphics();
		graphic.beginFill(0x00A492);
		graphic.drawRect(rect.x + 200, rect.y, size, rect.height);
		graphic.drawRect(rect.x + 420, rect.y, size, rect.height);
		graphic.drawRect(rect.x, rect.y + 200, rect.width, size);
		graphic.drawRect(rect.x, rect.y + 420, rect.width, size);
		graphic.endFill();

        app.stage.addChild(graphic);
    }
}