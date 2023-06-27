import haxe.Timer;
import pixi.core.graphics.Graphics;
import pixi.loaders.Loader;
import pixi.extras.BitmapText;
import pixi.core.Application;

class Game {
    private var app: Application;
    private var board: Board;
    private var winText: Map<SignType, BitmapText> = new Map<SignType, BitmapText>();
    private var graphic: Graphics;

    public function new(app: Application) {
        this.app = app;
        board = new Board(app);
        board.onWin = OnWin;
        board.onEnd = OnEnd;

        LoadAssets();
        
		graphic = new Graphics();
		graphic.beginFill();
		graphic.drawRect(0, 0, app.renderer.width, app.renderer.height);
		graphic.endFill();
        graphic.alpha = 0;
        graphic.interactive = true;
        graphic.on("click", Restart);
        graphic.visible = false;

        app.stage.addChild(graphic);
    }

    private function OnEnd() {
        graphic.visible = true;
    }

    private function Restart() {
        graphic.visible = false;
        board.Restart();

        for (sign in [SignType.Circle, SignType.Cross]) {
            winText[sign].visible = false;
        }
    }

    private function LoadAssets() {
		var loader = new Loader();
		loader.add("darkFont", "assets/fonts/darkFont.fnt");
		loader.add("lightFont", "assets/fonts/lightFont.fnt");
		loader.load(onAssetsLoaded);
    }

    private function OnWin(sign: SignType): Void {
        winText[sign].visible = true;
    }

    private function onAssetsLoaded(): Void {
        var styleDark = {
            font: 'darkFont',
            fontSize: 120,
            align: CENTER
        };
        var styleLight = {
            font: 'lightFont',
            fontSize: 120,
            align: CENTER
        };

        var circleText = new BitmapText('Circle Wins', styleLight);
        circleText.position.x = 600;
        circleText.visible = false;
        app.stage.addChild(circleText);
        winText[SignType.Circle] = circleText;

        var crossText = new BitmapText('Cross Wins', styleDark);
        crossText.position.x = 600;
        crossText.visible = false;
        app.stage.addChild(crossText);
        winText[SignType.Cross] = crossText;
    }
}