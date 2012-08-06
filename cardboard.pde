public class CardBoard {
	
	int xpos, ypos;
	int boardSize[] = {385 / divider, 280 / divider};

	CardBoard() {
		
		xpos = (customSize[0] / divider / 2) - (boardSize[0] / 2);
		ypos = (customSize[1] / divider - 330 / divider );
	
	}
	
	void display() {
		
		// only for testing
		rect(xpos, ypos, boardSize[0], boardSize[1]);
		
	}
	
}