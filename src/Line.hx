class Line {
    public var cells: Array<Cell> = [];
    
    public function new(cells: Array<Cell>) {
        this.cells = cells;
    }

    public function GetSum(sign: SignType): Int {
        var sum = 0;

        for (cell in cells) {
            if (cell.sign == sign) {
                sum++;
            }
        }

        return sum;
    }

    public function GetEmpty(): Cell {
        for (cell in cells) {
            if (cell.sign == SignType.None) {
                return cell;
            }
        }

        return null;
    }

    public function AnimateWin() {
        for (cell in cells) {
            cell.AnimateWin();
        }
    }
}