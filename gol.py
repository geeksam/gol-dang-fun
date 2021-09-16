import unittest

from approvaltests.approvals import verify


from approvaltests.reporters.generic_diff_reporter_factory import GenericDiffReporterFactory
from approvaltests.storyboard import Storyboard


def print_grid(width, height, board):
    t= ""
    for y in range (0  , height):
        for x in range (0, width):
            t+= f"{board(x,y)} "
        t+="\n"
    return t


def advance_turn(board):
    #next turn tells you is that coordinate alive or dead
    def next_turn(x,y):
        living_neighbors = board(x-1, y-1)+ board(x-1,y) + board(x-1, y+1) +\
                board(x , y - 1)               + board(x , y + 1) + \
                board(x + 1, y - 1) + board(x + 1, y) + board(x + 1, y + 1)
        #  or two neighbors and you are alive
        return living_neighbors == 3 or (living_neighbors == 2 and board(x,y))
    return next_turn


class RegressionTest(unittest.TestCase):
    def setUp(self):
        self.reporter = None #Use the first difftool found on your system
        #self.reporter = GenericDiffReporterFactory().get("DiffMerge")
        #Download DiffMerge at https://sourcegear.com/diffmerge/



    def test_single_square_dies(self):
        board = lambda x, y: x == 1 and y == 2
        self.verify_game_of_life_board(board)

    def test_square_survives(self):
        board = lambda x, y: 1 <= x <= 2 and 1 <= y <= 2
        self.verify_game_of_life_board(board)

# look at https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life  see visual example Oscillator Beacon
    def test_square_blinker(self):
        board = lambda x, y: (0 <= x <= 1 and 0 <= y <= 1) or (2 <= x <= 3 and 2 <= y <= 3)
        self.verify_game_of_life_board(board)

    # a cell with 2 living neighbors becomes alive
    def test_blinker(self):
        board = lambda x, y: 1 <= x <= 3 and y == 2
        self.verify_game_of_life_board(board)

    def verify_game_of_life_board(self, board):
        s = Storyboard()
        # create a board with 1,2 alive
        s.add_frame(print_grid(5, 4, lambda x, y: "x" if board(x, y) else "."))
        # advance the board
        board = advance_turn(board)
        s.add_frame(print_grid(5, 4, lambda x, y: "x" if board(x, y) else "."))
        # verify that the board is empty
        verify(s, self.reporter)

