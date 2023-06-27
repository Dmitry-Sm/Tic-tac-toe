import haxe.Timer;
import pixi.core.Application;
import pixi.core.math.Point;
import pixi.loaders.Loader;
import pixi.core.math.shapes.Rectangle;
import Line;

class Board {
    public var cells: Map<Int, Cell>;
    public var onEnd: () -> Void;
    public var onWin: (SignType: SignType) -> Void;
    private var app: Application;
    private var lines: Array<Line>;
    private var move: SignType;
    private var spineDatas: Map<SignType, Any> = new Map<SignType, Any>();
    private var rect: Rectangle = new Rectangle(640, 220, 640, 640);

    public function new(app: Application) {
        this.app = app;
		var loader = new Loader();
		loader.add("circle", "assets/spine/skeletons/circle.json");
		loader.add("cross", "assets/spine/skeletons/cross.json");
		loader.load(onAssetsLoaded);

        var Grid = new Grid(app, rect);
        InitCells();
        InitLines();

        move = SignType.Cross;
    }

    public function Restart() {
        Clear();
        move = SignType.Cross;
    }

    private function Clear() {
        for (cell in cells) {
            cell.Clear();
        }
    }

    private function InitCells() {
        cells = new Map<Int, Cell>();
        var point = new Point();
        var position = new Point();
        var i = 1;
        
        for (x in 0...3) {
            for (y in 0...3) {
                point.set(x, y);
                position.set(x * 220 + rect.x, y * 220 + rect.y);

                var cell = new Cell(app, position);
                cells[i++] = cell;
                cell.onClick = OnClick;
            }
        }
    }

	private function onAssetsLoaded(loader) {
        spineDatas[SignType.Circle] = Reflect.field(loader.resources, "circle").spineData;
        spineDatas[SignType.Cross] = Reflect.field(loader.resources, "cross").spineData;
	}

    private function OnClick(cell: Cell): Void {
        if (move != SignType.Cross) {
            return;
        }

        cell.SetSign(SignType.Cross, spineDatas[SignType.Cross]);
        move = SignType.Circle;

        if (CheckEndGame()) {
            onEnd();

            return;
        }

        Timer.delay(EnemyMove, 500);
    }

    private function EnemyMove() {
        var cell = FindBestMove();

        if (cell == null) {
            return;
        }

        cell.SetSign(SignType.Circle, spineDatas[SignType.Circle]);
        move = SignType.Cross;
        
        if (CheckEndGame()) {
            onEnd();
        }
    }

    private function CheckEndGame(): Bool {
        if (CheckWin()) {
            return true;
        }

        for (cell in cells) {
            if (cell.sign == SignType.None) {
                return false;
            }
        }

        return true;
    }

    private function CheckWin(): Bool {
        for (line in lines) {
            for (sign in [SignType.Circle, SignType.Cross]) {
                if (line.GetSum(sign) == 3) {
                    line.AnimateWin();
                    onWin(sign);
    
                    return true;
                }
            }
        }

        return false;
    }

    private function FindBestMove(): Cell {
        if (cells[5].sign == SignType.None) {
            return cells[5];
        }

        for (line in lines) {
            var empty = line.GetEmpty();

            if (line.GetSum(SignType.Circle) == 2 && empty != null) {
                return empty;
            }
        }

        for (line in lines) {
            var empty = line.GetEmpty();

            if (line.GetSum(SignType.Cross) == 2 && empty != null) {
                return empty;
            }
        }

        // Player can win
        for (line in lines) {
            var empty = line.GetEmpty();

            if (line.GetSum(SignType.Circle) == 1 && empty != null) {
                return empty;
            }
        }

        for (line in lines) {
            var empty = line.GetEmpty();

            if (empty != null) {
                return empty;
            }
        }

        return null;
    }

    private function InitLines() {
        lines = [
            new Line([cells[1], cells[2], cells[3]]),
            new Line([cells[4], cells[5], cells[6]]),
            new Line([cells[7], cells[8], cells[9]]),

            new Line([cells[1], cells[4], cells[7]]),
            new Line([cells[2], cells[5], cells[8]]),
            new Line([cells[3], cells[6], cells[9]]),

            new Line([cells[1], cells[5], cells[9]]),
            new Line([cells[3], cells[5], cells[7]]),
        ];
    }
}