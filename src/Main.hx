import pixi.core.Application;
import js.Browser;

class Main extends Application {

	public function new() {
		
		var options:ApplicationOptions = {
			width: 1920,
			height: 1080,
			backgroundColor: 0x00C1AC,
			antialias: true
		};
		
		super(options);
		Browser.document.body.appendChild(view);

		var game = new Game(this);
	}

	static function main() {
		new Main();
	}
}